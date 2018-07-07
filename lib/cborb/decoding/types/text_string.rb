module Cborb::Decoding::Types
  # To represent major type: 3(definite-length)
  #
  # @see https://tools.ietf.org/html/rfc7049#section-2.1
  class TextString < Type
    extend Cborb::Decoding::Types::IntegerDecodable

    def self.decode(state, additional_info)
      bytes = state.consume(consume_as_integer(state, additional_info))
      state.accept_value(self, bytes.force_encoding(::Encoding::UTF_8))
    end
  end
end
