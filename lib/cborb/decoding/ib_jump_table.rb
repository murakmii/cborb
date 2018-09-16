module Cborb::Decoding
  # IB = Initial Byte
  # @see https://tools.ietf.org/html/rfc7049#appendix-B
  IB_JUMP_TABLE =
    Array.new(0xFF) do |ib|
      case ib
      when 0x00..0x1B
        Types::Integer
      when 0x20..0x3B
        Types::NegativeInteger
      when 0x40..0x5B
        Types::ByteString
      when 0x5F
        Types::IndefiniteByteString
      when 0x60..0x7B
        Types::TextString
      when 0x7F
        Types::IndefiniteTextString
      when 0x80..0x9B
        Types::Array
      when 0x9F
        Types::IndefiniteArray
      when 0xA0..0xBB
        Types::Map
      when 0xBF
        Types::IndefiniteMap
      when 0xC0..0xDB
        Types::Tag
      when 0xE0..0xF3
        Types::UnassignedSimpleValue
      when 0xF4..0xF7
        Types::SimpleValue
      when 0xF8
        Types::UnassignedSimpleValue
      when 0xF9
        Types::HalfPrecisionFloatingPoint
      when 0xFA, 0xFB
        Types::FloatingPoint
      when 0xFF
        Types::Break
      else
        Types::Unknown
      end
    end.freeze
end
