module Cborb::Decoding
  class State
    CONTINUE = Object.new

    attr_reader :result

    def initialize(&block)
      @buffer = StringIO.new
      @stack = [[Cborb::Decoding::Types::Root, nil]]
      @decoding_fiber = Fiber.new { block.call(self) }
      @result = nil
    end

    # Buffering new CBOR data
    #
    # @param [String] cbor
    def <<(cbor)
      pos = @buffer.pos
      @buffer.write(cbor)
      @buffer.pos = pos

      @decoding_fiber.resume

    rescue FiberError => e
      msg = e.message

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
        @buffer = StringIO.new # drop whole buffer that was consumed

        while data.size != size
          Fiber.yield
          data += @buffer.read(size - data.size)
        end
      end

      data
    end

    # @param [Class] type
    # @param [Object] im_data
    def push_stack(type, im_data = nil)
      @stack << [type, im_data]
    end

    # @param [Class] type
    # @param [Object] value
    def accept_value(type, value)
      loop do
        stacked_type, im_data = @stack.last
        ret = stacked_type.accept(im_data, type, value)

        if ret.equal?(CONTINUE)
          break
        else
          @stack.pop
          if @stack.empty?
            raise Cborb::InvalidByteSequenceError unless @buffer.eof?
            @result = ret
            break
          else
            value = ret
          end
        end
      end
    end

    def stack_top
      @stack.last.first
    end

    def finished?
      !@result.nil?
    end
  end
end
