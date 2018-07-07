module Cborb::Decoding
  class Buffer
    CLEANUP_THRESHOLD = 100_000

    # @param [String] data
    def initialize(data = nil)
      @buffer = create_new_buffer(data)
    end

    # @param [String] data
    def write(data)
      pos = @buffer.pos
      @buffer.seek(0, IO::SEEK_END)
      @buffer.write(data)
      @buffer.pos = pos
    end

    # @param [Integer] required_size
    def read(required_size)
      raise "Required size is bigger than buffered data size" if required_size > size

      data = @buffer.read(required_size)
      cleanup
      data
    end

    # @return [Integer]
    def size
      @buffer.size - @buffer.pos
    end

    # @return [Boolean]
    def empty?
      size == 0
    end

    private

    # @param [String] data
    # @return [StringIO]
    def create_new_buffer(data)
      StringIO.new.tap do |buf|
        buf.set_encoding(Encoding::ASCII_8BIT)
        if data&.size > 0
          buf.write(data) 
          buf.rewind
        end
      end
    end

    def cleanup
      return if @buffer.pos < CLEANUP_THRESHOLD
      @buffer = create_new_buffer(@buffer.read)
    end
  end
end
