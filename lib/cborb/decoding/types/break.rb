module Cborb::Decoding::Types
  # To represent "break" stop code
  class Break < Type
    def self.decode(state, additional_info)
      unless state.stack_top.indefinite?
        raise Cborb::DecodingError, 'Unexpected "break" stop code' 
      end
      
      state.accept_value(self, self)
    end
  end
end
