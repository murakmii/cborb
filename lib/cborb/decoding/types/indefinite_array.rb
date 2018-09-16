module Cborb::Decoding::Types
  # To represent major type: 4(indefinite-length)
  #
  # @see https://tools.ietf.org/html/rfc7049#section-2.2.1
  class IndefiniteArray < Type
    def self.indefinite?
      true
    end

    def self.decode(state, additional_info)
      state.push_stack(self, [])
    end

    def self.accept(im_data, type, value)
      if type == Cborb::Decoding::Types::Break
        im_data
      else
        im_data << value
        Cborb::Decoding::State::CONTINUE
      end
    end
  end
end
