RSpec.describe Cborb::Decoding::Types::UnassignedSimpleValue do
  it_behaves_like "definite-length type"
  it_behaves_like "non-following data type"

  describe ".decode" do
    subject { described_class.decode(state, additional_info) }

    let(:state) { instance_double(Cborb::Decoding::State) }

    context "If additional information is lesser than 24" do
      let(:additional_info) { 23 }

      it "Calls #accept_value with Unassigned Simple Value" do
        allow(state).to receive(:accept_value)
        subject
        expect(state).
          to have_received(:accept_value).with(described_class, Cborb::Decoding::UnassignedSimpleValue.new(23))
      end
    end

    context "If additional information is 24" do
      let(:additional_info) { 24 }

      before { allow(state).to receive(:consume).with(1).and_return("\xFF") }

      it "Calls #accept_value with Unassigned Simple Value" do
        allow(state).to receive(:accept_value)
        subject
        expect(state).
          to have_received(:accept_value).with(described_class, Cborb::Decoding::UnassignedSimpleValue.new(255))
      end
    end
  end
end
