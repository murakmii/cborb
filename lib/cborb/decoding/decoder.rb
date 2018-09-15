module Cborb::Decoding
  class Decoder
    extend Forwardable

    def_delegators :@state, :result, :finished?

    def initialize
      @state = Cborb::Decoding::State.new
    end

    def decode(cbor)
      @state << cbor.to_s
    end
  end
end
