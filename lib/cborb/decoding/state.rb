module Cborb::Decoding
  # State of processing to decode
  class State
    CONTINUE = Object.new
    NO_RESULT = Object.new

    def initialize
      @buffer = Cborb::Decoding::SimpleBuffer.new
      @stack = [[Cborb::Decoding::Types::Root, nil]]
      @result = NO_RESULT

      # This fiber decodes CBOR.
      # If buffer becomes empty, this fiber is stopped(#consume)
      # When new CBOR data is buffered(#<<), that is resumed.
      @decoding_fiber = Fiber.new { loop_consuming }
    end

    # Buffering new CBOR data
    #
    # @param [String] cbor
    def <<(cbor)
      @buffer.write(cbor)
      @decoding_fiber.resume

    rescue FiberError => e
      msg = e.message

      # umm...
      if msg.include?("dead")
        raise Cborb::InvalidByteSequenceError
      elsif msg.include?("threads")
        raise Cborb::DecodingError, "Can't decode across threads"
      else
        raise
      end
    end

    # Consume CBOR data.
    # This method will be called only in fiber.
    #
    # @param [Integer] size Size to consume
    def consume(size)
      data = @buffer.read(size).to_s

      # If buffered data is not enought, yield fiber until new data will be buffered.
      if data.size < size
        @buffer.reset!

        while data.size != size
          Fiber.yield
          data += @buffer.read(size - data.size)
        end
      end

      data
    end

    # Push type that has following data(e.g. Array) to stack
    #
    # @param [Class] type Class constant that inherits Cborb::Decoding::Types::Type
    # @param [Object] im_data depends on type
    def push_stack(type, im_data = nil)
      @stack << [type, im_data]
    end

    # @param [Class] type Class constant that inherits Cborb::Decoding::Types::Type
    # @param [Object] value
    def accept_value(type, value)
      loop do
        stacked_type, im_data = @stack.last
        value = stacked_type.accept(im_data, type, value)
        type = stacked_type

        if value.equal?(CONTINUE)
          break
        else
          @stack.pop
          if @stack.empty?
            raise Cborb::InvalidByteSequenceError unless @buffer.eof?
            @result = value
            break
          end
        end
      end
    end

    # @return [Class] Class constant that inherits Cborb::Decoding::Types::Type on top of stack.
    def stack_top
      @stack.last.first
    end

    # @return [Boolean]
    def finished?
      !@result.eql?(NO_RESULT)
    end

    # @return [Object]
    def result
      finished? ? @result : nil
    end

    private

    def loop_consuming
      loop do
        ib = consume(1).ord
        Cborb::Decoding::IB_JUMP_TABLE[ib].decode(self, ib & 0x1F)
        break if finished?
      end
    end
  end
end
