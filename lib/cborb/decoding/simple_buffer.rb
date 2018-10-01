module Cborb::Decoding
  class SimpleBuffer
    extend Forwardable

    def_delegators :@buffer, :read, :getbyte, :eof?

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

    def reset!
      @buffer.rewind
      @buffer.truncate(0)
    end

    def peek
      pos = @buffer.pos
      @buffer.read.to_s.tap { @buffer.pos = pos }
    end
  end
end
