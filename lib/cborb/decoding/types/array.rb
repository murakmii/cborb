module Cborb::Decoding::Types
  # To represent major type: 4(definite-length)
  #
  # @see https://tools.ietf.org/html/rfc7049#section-2.1
  class Array < Type
    extend Cborb::Decoding::Types::IntegerDecodable

    Intermediate = Struct.new(:size, :array)

    def self.decode(state, additional_info)
      size = consume_as_integer(state, additional_info)

      if size > 0
        state.push_stack(self, Intermediate.new(size, []))
      else
        state.accept_value(self, [])
      end
    end

    def self.accept(im_data, type, value)
      im_data.array << value
      im_data.size == im_data.array.size ? im_data.array : Cborb::Decoding::State::CONTINUE
    end
  end
end
