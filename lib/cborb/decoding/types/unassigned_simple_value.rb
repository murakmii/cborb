module Cborb::Decoding::Types
  # To represent unassigned simple value
  #
  # @see https://tools.ietf.org/html/rfc7049#section-2.3
  class UnassignedSimpleValue < Type
    extend Cborb::Decoding::Types::IntegerDecodable

    def self.decode(state, additional_info)
      raise Cborb::DecodingError, "Included unassigned simple value"
    end
  end
end
