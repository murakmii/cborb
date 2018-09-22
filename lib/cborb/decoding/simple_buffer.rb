module Cborb::Decoding
  class SimpleBuffer
    extend Forwardable

    def_delegators :@buffer, :read, :eof?

    def initialize
      @buffer = StringIO.new
      @buffer.set_encoding(Encoding::ASCII_8BIT)
    end

    # @param [String] data
    def write(data)
      pos = @buffer.pos
      @buffer << data
      @buffer.pos = pos
    end

    def read(bytes)
      if bytes == 1
        @buffer.getc
      else
        @buffer.read(bytes)
      end
    end

    def reset!
      @buffer.rewind
      @buffer.truncate(0)
    end
  end
end
