module Cborb::Decoding::Types
  # To represent part of major type: 7
  # 
  # @see https://tools.ietf.org/html/rfc7049#section-2.3
  class FloatingPoint < Type
    UNPACK_TEMPLATES = [
      "g".freeze,
      "G".freeze,
    ].freeze

    def self.decode(state, additional_info)
      index = additional_info - 26
      bytesize = 4 * (index + 1)

      state.accept_value(self, state.consume(bytesize).unpack(UNPACK_TEMPLATES[index]).first)
    end
  end
end
