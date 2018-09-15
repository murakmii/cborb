module Cborb
  class Error < ::StandardError; end

  class DecodingError < Error; end

  class InvalidByteSequenceError < DecodingError
    def initialize
      super("CBOR has invalid byte sequence")
    end
  end
end
