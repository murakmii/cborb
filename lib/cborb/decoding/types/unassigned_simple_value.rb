module Cborb::Decoding::Types
  # To represent unassigned simple value
  #
  # @see https://tools.ietf.org/html/rfc7049#section-2.3
  class UnassignedSimpleValue < Type
    extend Cborb::Decoding::Types::IntegerDecodable

    def self.decode(state, additional_info)
      simple_value = consume_as_integer(state, additional_info)
      state.accept_value(self, Cborb::Decoding::UnassignedSimpleValue.new(simple_value))
    end
  end
end
