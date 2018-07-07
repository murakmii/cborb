require "forwardable"
require "stringio"

require "cborb/version"
require "cborb/errors"

require "cborb/decoding/types/type"
require "cborb/decoding/types/unknown"
require "cborb/decoding/types/root"
require "cborb/decoding/types/integer_decodable"
require "cborb/decoding/types/integer"
require "cborb/decoding/types/negative_integer"
require "cborb/decoding/types/byte_string"
require "cborb/decoding/types/indefinite_byte_string"
require "cborb/decoding/types/text_string"
require "cborb/decoding/types/indefinite_text_string"
require "cborb/decoding/types/array"
require "cborb/decoding/types/indefinite_array"
require "cborb/decoding/types/map"
require "cborb/decoding/types/indefinite_map"
require "cborb/decoding/types/tag"
require "cborb/decoding/types/simple_value"
require "cborb/decoding/types/half_precision_floating_point"
require "cborb/decoding/types/floating_point"
require "cborb/decoding/types/break"

require "cborb/decoding/buffer"
require "cborb/decoding/state"
require "cborb/decoding/decoder"

module Cborb
  # @param [String] cbor
  def decode(cbor)
    decoder = Decoding::Decoder.new(streaming: false)
    decoder.decode(cbor)
    decoder.result
  end

  module_function :decode
end
