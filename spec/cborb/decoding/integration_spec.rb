RSpec.describe "Integration" do
  subject do |example|
    Cborb.decode(read_cbor_fixture(example.example_group.description))
  end

  describe "001" do
    it "Raises decoding error" do
      expect { subject }.to raise_error(Cborb::DecodingError, "Unknown initial byte")
    end
  end

  describe "002" do
    it "Raises decoding error" do
      expect { subject }.to raise_error(Cborb::DecodingError, "Unknown initial byte")
    end
  end

  describe "003" do
    it "Raises decoding error" do
      expect { subject }.to raise_error(Cborb::InvalidByteSequenceError)
    end
  end

  describe "004" do
    it "Raises decoding error" do
      expect { subject }.to raise_error(Cborb::InvalidByteSequenceError)
    end
  end

  describe "005" do
    it { is_expected.to eq [1, 2, 3] }
  end

  describe "006" do
    it "can decode it" do
      result = subject
      100000.times { result = result.first }

      expect(result).to eq 123
    end
  end

  describe "007" do
    it "can decode it" do
      expect(subject).to contain_exactly(
        {
          "description"         => "The map that contains positive integers",
          "zero byte integer"   => 23,
          "single byte integer" => 15,
          "2 byte integer"      => 255,
          "4 byte integer"      => 65535,
          "8 byte integer"      => 4294967295
        },
        {
          "description"         => "The map that contains negative integers",
          "zero byte integer"   => -24,
          "single byte integer" => -16,
          "2 byte integer"      => -256,
          "4 byte integer"      => -65536,
          "8 byte integer"      => -4294967296
        },
        {
          "description"                                => "The map that contains byte strings",
          "byte string(represented by 0 byte integer)" => "ABC",
          "byte string(represented by 1 byte integer)" => "ABC",
          "byte string(represented by 2 byte integer)" => "ABC",
          "byte string(represented by 4 byte integer)" => "ABC",
          "byte string(represented by 8 byte integer)" => "ABC",
          "indefinite byte string"                     => "ABC"
        },
        {
          "description"                                   => "The map that contains unicode strings",
          "unicode string(represented by 0 byte integer)" => "おはよう",
          "unicode string(represented by 1 byte integer)" => "おはよう",
          "unicode string(represented by 2 byte integer)" => "おはよう",
          "unicode string(represented by 4 byte integer)" => "おはよう",
          "unicode string(represented by 8 byte integer)" => "おはよう",
          "indefinite unicode string"                     => "おはようございます"
        },
        {
          "description"                          => "The map that contains arrays",
          "array(represented by 0 byte integer)" => [1, 2, 3],
          "array(represented by 1 byte integer)" => [1, 2, 3],
          "array(represented by 2 byte integer)" => [1, 2, 3],
          "array(represented by 4 byte integer)" => [1, 2, 3],
          "array(represented by 8 byte integer)" => [1, 2, 3],
          "indefinite array"                     => [1, 2, 3, "hello"]
        },
        Cborb::Decoding::TaggedValue.new(0, "1970-01-01T00:00Z"),
        Cborb::Decoding::TaggedValue.new(15, 123),
        Cborb::Decoding::TaggedValue.new(255, 123),
        Cborb::Decoding::TaggedValue.new(65535, 123),
        Cborb::Decoding::TaggedValue.new(4294967295, 123),
        false,
        true,
        nil,
        nil,
        {
          "description"            => "The map that contains floating point values",
          "half precision float"   => be_within(0.00001).of(0.33325),
          "single precision float" => be_within(0.00001).of(1.23),
          "double precision float" => 1.23,
        },
        Cborb::Decoding::UnassignedSimpleValue.new(15),
        Cborb::Decoding::UnassignedSimpleValue.new(255),
        {
          "abc" => 123,
          "def" => 456
        }
      )
    end
  end

  describe "008" do
    it "Raises decoding error" do
      expect { subject }.to raise_error(Cborb::DecodingError, "Unexpected chunk for indefinite byte string")
    end
  end

  describe "009" do
    it "Raises decoding error" do
      expect { subject }.to raise_error(Cborb::DecodingError, "Unexpected chunk for indefinite text string")
    end
  end

  describe "010" do
    it { is_expected.to be_nil }
  end

  describe "011" do
    it "Raises decoding error" do
      expect { subject }.to raise_error(Cborb::InvalidByteSequenceError)
    end
  end

  describe "012" do
    it "Raises decoding error" do
      expect { subject }.to raise_error(Cborb::InvalidByteSequenceError)
    end
  end

  describe "013" do
    it "Raises decoding error" do
      expect { subject }.to raise_error(Cborb::InvalidByteSequenceError)
    end
  end
end
