module Cborb::Decoding::Types
  # To represent major type: 5(indefinite-length)
  #
  # @see https://tools.ietf.org/html/rfc7049#section-2.2.1
  class IndefiniteMap < Type
    def self.indefinite?
      true
    end

    def self.decode(state, additional_info)
      state.push_stack(self, [])
    end

    def self.accept(im_data, type, value)
      if type == Cborb::Decoding::Types::Break
        raise Cborb::DecodingError, "Invalid indefinite-length map" if im_data.size.odd?
        Hash[*im_data]
      else
        im_data << value
        Cborb::Decoding::State::CONTINUE
      end
    end
  end
end
