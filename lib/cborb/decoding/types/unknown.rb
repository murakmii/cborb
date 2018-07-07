module Cborb::Decoding::Types
  # The pseudo type to represent unknown/invalid initial byte
  class Unknown < Type
    def self.decode(state, additional_info)
      raise Cborb::DecodingError, "Unknown initial byte"
    end
  end
end
