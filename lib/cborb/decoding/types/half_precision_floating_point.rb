module Cborb::Decoding::Types
  # To represent part of major type: 7
  # 
  # @see https://tools.ietf.org/html/rfc7049#section-2.3
  # @see https://tools.ietf.org/html/rfc7049#appendix-D
  class HalfPrecisionFloatingPoint < Type
    class << self
      def decode(state, additional_info)
        bits = state.consume(2).unpack("n".freeze).first
        bits = (bits & 0x7FFF) << 13 | (bits & 0x8000) << 16
        fp = 
          if (bits & 0x7C00) != 0x7C00
            Math.ldexp(to_single(bits), 112)
          else
            to_single(bits | 0x7F800000)
          end

        state.accept_value(self, fp)
      end

      private

      def to_single(bits)
        [bits].pack("N".freeze).unpack("g".freeze).first
      end
    end
  end
end
