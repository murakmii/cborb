module Cborb::Decoding
  class Concatenated
    extend Forwardable
    include Enumerable

    def_delegators :@decoded, :each, :size, :length, :<<, :last

    def initialize
      @decoded = []
    end
  end
end
