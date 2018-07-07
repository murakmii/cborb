module Cborb::Decoding::Types
  # To represent major type: 2(definite-length)
  #
  # @see https://tools.ietf.org/html/rfc7049#section-2.1
  class ByteString < Type
    extend Cborb::Decoding::Types::IntegerDecodable

    def self.decode(state, additional_info)
      state.accept_value(self, state.consume(consume_as_integer(state, additional_info)))
    end
  end
end
