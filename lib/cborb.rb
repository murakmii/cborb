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
require "cborb/decoding/types/unassigned_simple_value"
require "cborb/decoding/types/half_precision_floating_point"
require "cborb/decoding/types/floating_point"
require "cborb/decoding/types/break"

require "cborb/decoding/concatenated"
require "cborb/decoding/ib_jump_table"
require "cborb/decoding/tagged_value"
require "cborb/decoding/unassigned_simple_value"
require "cborb/decoding/simple_buffer"
require "cborb/decoding/state"
require "cborb/decoding/decoder"

module Cborb
  # The shorthand to decode CBOR
  #
  # @param [String] cbor
  # @param [Boolean] concatenated Whether "cbor" param is constructed by concatenated CBOR byte string.
  #                               If it's true, this method returns instance of Cborb::Decoding::Concatenated
  # @return [Object] decoded data(Array, Hash, etc...)
  def decode(cbor, concatenated: false)
    results = Decoding::Concatenated.new
    loop do
      decoder = Decoding::Decoder.new
      decoder.decode(cbor)

      raise Cborb::InvalidByteSequenceError unless decoder.finished?

      results << decoder.result

      if decoder.remaining_bytes.empty?
        break
      elsif !concatenated
        raise Cborb::InvalidByteSequenceError
      end

      cbor = decoder.remaining_bytes
    end

    concatenated ? results : results.first
  end

  module_function :decode
end
