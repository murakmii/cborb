module Cborb::Decoding
  class Decoder
    extend Forwardable

    def_delegators :@state, :result, :finished?, :remaining_bytes

    def initialize
      @state = Cborb::Decoding::State.new
    end

    def decode(cbor)
      @state << cbor.to_s
    end

    def inspect
      "#<#{self.class}:#{object_id} finished=#{finished?} result=#{finished? ? result : "nil"}>"
    end
  end
end
