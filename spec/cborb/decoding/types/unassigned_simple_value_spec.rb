RSpec.describe Cborb::Decoding::Types::UnassignedSimpleValue do
  it_behaves_like "definite-length type"
  it_behaves_like "non-following data type"

  describe ".decode" do
    subject { described_class.decode(state, additional_info) }

    let(:state) { instance_double(Cborb::Decoding::State) }

    context "If additional information is lesser than 24" do
      let(:additional_info) { 23 }

      it "Raises error" do
        expect { subject }.to raise_error(Cborb::DecodingError, "Included unassigned simple value: 23")
      end
    end

    context "If additional information is 24" do
      let(:additional_info) { 24 }

      before { allow(state).to receive(:consume).with(1).and_return("\xFF") }

      it "Raises error" do
        expect { subject }.to raise_error(Cborb::DecodingError, "Included unassigned simple value: 255")
      end
    end
  end
end
