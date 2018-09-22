RSpec.describe Cborb::Decoding::Types::HalfPrecisionFloatingPoint do
  it_behaves_like "definite-length type"
  it_behaves_like "non-following data type"

  describe ".decode" do
    subject { described_class.decode(state, 25) }

    let(:state) do
      instance_double(Cborb::Decoding::State).tap do |mock|
        allow(mock).to receive(:consume).with(2).and_return("\x35\x55")
      end
    end

    it "Calls #accept_value with floatin point value" do
      allow(state).to receive(:accept_value)
      subject
      expect(state).to have_received(:accept_value).with(described_class, be_within(0.00001).of(0.33325))
    end
  end
end
