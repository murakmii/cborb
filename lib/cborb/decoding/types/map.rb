module Cborb::Decoding::Types
  # To represent major type: 5(definite-length)
  #
  # @see https://tools.ietf.org/html/rfc7049#section-2.1
  class Map < Type
    extend Cborb::Decoding::Types::IntegerDecodable

    Intermediate = Struct.new(:size, :map)

    def self.decode(state, additional_info)
      im_data = Intermediate.new(consume_as_integer(state, additional_info), [])
      state.push_stack(self, im_data)
    end

    def self.accept(im_data, type, value)
      im_data.map << value
      if im_data.map.size / 2 == im_data.size
        Hash[im_data.map]
      else
        Cborb::Decoding::State::CONTINUE
      end
    end
  end
end
