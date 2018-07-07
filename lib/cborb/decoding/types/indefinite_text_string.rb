module Cborb::Decoding::Types
  # To represent major type: 3(indefinite-length)
  #
  # @see https://tools.ietf.org/html/rfc7049#section-2.2.2
  class IndefiniteTextString < Type
    def self.indefinite?
      true
    end

    def self.decode(state, additional_info)
      state.push_stack(self, String.new.force_encoding(::Encoding::UTF_8))
    end

    def self.accept_value(im_data, type, value)
      if type == Cborb::Decoding::Types::TextString
        im_data.concat(value)
        nil
      elsif type == Cborb::Decoding::Types::Break
        im_data
      else
        raise Cborb::DecodingError, "Unexpected chunk for indefinite byte string" 
      end
    end
  end
end
