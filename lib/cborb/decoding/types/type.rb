module Cborb::Decoding
  module Types
    # Base class for all type classes
    class Type
      # @return [Boolean]
      def self.indefinite?
        false
      end
      
      # @param [Cborb::Decoding::State] state
      # @param [Integer] additional_info
      def self.decode(state, additional_info)
        raise NotImplementedError
      end

      # @param [Object] im_data
      # @param [Class] type 
      # @param [Object] value
      def self.accept(im_data, type, value)
        raise "#{self} can't accept value"
      end
    end
  end
end
