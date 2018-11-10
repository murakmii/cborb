module Cborb::Decoding::Types
  # To represent major type: 5(definite-length)
  #
  # @see https://tools.ietf.org/html/rfc7049#section-2.1
  class Map < Type
    extend Cborb::Decoding::Types::IntegerDecodable

    Intermediate = Struct.new(:size, :keys_and_values)

    def self.decode(state, additional_info)
      size = consume_as_integer(state, additional_info) * 2

      if size > 0
        state.push_stack(self, Intermediate.new(size, []))
      else
        state.accept_value(self, {})
      end
    end

    def self.accept(im_data, type, value)
      im_data.keys_and_values << value
      if im_data.keys_and_values.size == im_data.size
        Hash[*im_data.keys_and_values]
      else
        Cborb::Decoding::State::CONTINUE
      end
    end
  end
end
