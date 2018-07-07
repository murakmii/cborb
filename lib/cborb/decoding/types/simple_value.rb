module Cborb::Decoding::Types
  # To represent part of major type: 7
  #
  # @see https://tools.ietf.org/html/rfc7049#section-2.3
  class SimpleValue < Type
    VALUES = [
      false,
      true,
      nil,
      nil, # doesn't exist "undefined" in ruby
    ].freeze

    def self.decode(state, additional_info) 
      state.accept_value(self, VALUES[additional_info - 20])
    end
  end
end
