module Cborb::Decoding::Types
  # In CBOR, The process that decode some bytes as integer is popular.
  # Thus, we modularize that.
  module IntegerDecodable
    UNPACK_TEMPLATES = [
      "C".freeze,
      "S>".freeze,
      "I>".freeze,
      "Q>".freeze,
    ].freeze

    # @param [Cborb::Decoding::State] state
    # @param [Integer] additional_info
    # @return [Integer]
    def consume_as_integer(state, additional_info)
      return additional_info if additional_info < 24

      index = additional_info - 24
      bytesize = 2**index

      state.consume(bytesize).unpack(UNPACK_TEMPLATES[index]).first
    end
  end
end
