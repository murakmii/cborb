module Cborb::Decoding::Types
  # To represent major type: 6
  #
  # @see https://tools.ietf.org/html/rfc7049#section-2.1
  class Tag < Type
    extend Cborb::Decoding::Types::IntegerDecodable

    def self.decode(state, additional_info)
      consume_as_integer(state, additional_info)
      state.push_stack(self)
    end

    def self.accept(im_data, value)
      # TODO: implementation
      value
    end
  end
end
