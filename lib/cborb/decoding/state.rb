module Cborb::Decoding
  class State
    attr_reader :result

    # @param [String] initial_cbor
    # @param [Hash] opts
    def initialize(initial_cbor, opts, &block)
      @buffer = Cborb::Decoding::Buffer.new(initial_cbor)
      @opts = opts
      @stack = [[Cborb::Decoding::Types::Root, nil]]
      @requested_buffer_size = 0
      @result = nil

      @process_fiber = Fiber.new { block.call(self) }
      @process_fiber.resume
    end

    # @param [String] cbor
    def produce(cbor)
      raise Cborb::DecodingError, "Not streaming mode" unless @opts[:streaming]

      @buffer.write(cbor)
      if @requested_buffer_size > 0 && @requested_buffer_size <= @buffer.size
        @process_fiber.resume
      end
    end

    # @param [Integer] size
    def consume(size)
      if @buffer.size < size
        raise Cborb::DecodingError, "Insufficiency" unless @opts[:streaming]

        @requested_buffer_size = size
        Fiber.yield
        @requested_buffer_size = 0
      end

      @buffer.read(size)
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

        if ret
          @stack.pop
          if @stack.empty?
            @result = ret
            break
          else
            value = ret
          end
        else
          break
        end
      end
    end

    def stack_top
      @stack.last.first
    end

    def finished?
      if @stack.empty?
        raise Cborb::DecodingError, "Invalid extra data" unless @buffer.empty?
        true
      else
        false
      end
    end
  end
end
