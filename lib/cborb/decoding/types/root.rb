module Cborb::Decoding::Types
  class Root < Type
    def self.accept(im_data, type, value)
      value
    end
  end
end
