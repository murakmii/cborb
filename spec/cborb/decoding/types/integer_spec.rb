RSpec.describe Cborb::Decoding::Types::Integer do
  it_behaves_like "definite-length type"
  it_behaves_like "non-following data type"

  describe ".decode" do
    subject { described_class.decode(state, additional_info) }

    let(:state) do
      instance_double(Cborb::Decoding::State).tap do |mock|
        allow(mock).to receive(:consume).with(1).and_return("\xFF")
      end
    end
    let(:additional_info) { 24 }

    it "Calls #accept_value with integer value" do
      allow(state).to receive(:accept_value)
      subject
      expect(state).to have_received(:accept_value).with(described_class, 0xFF)
    end
  end
end
