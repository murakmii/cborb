module Cborb::Decoding::Types
  # To represent major type: 0
  #
  # @see https://tools.ietf.org/html/rfc7049#section-2.1
  class Integer < Type
    extend Cborb::Decoding::Types::IntegerDecodable

    def self.decode(state, additional_info)
      state.accept_value(self, consume_as_integer(state, additional_info))
    end
  end
end
