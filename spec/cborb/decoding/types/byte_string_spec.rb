RSpec.describe Cborb::Decoding::Types::ByteString do
  it_behaves_like "definite-length type"
  it_behaves_like "non-following data type"

  describe ".decode" do
    subject { described_class.decode(state, 25) }

    let(:byte_string) { SecureRandom.random_bytes(100) }
    let(:state) do
      instance_double(Cborb::Decoding::State).tap do |mock|
        allow(mock).to receive(:consume).with(2).and_return([byte_string.size].pack("S>"))
        allow(mock).to receive(:consume).with(byte_string.size).and_return(byte_string)
      end
    end

    it "Calls #accept_value with byte string" do
      allow(state).to receive(:accept_value)
      subject
      expect(state).to have_received(:accept_value).with(described_class, byte_string)
    end
  end
end
