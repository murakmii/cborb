RSpec.describe Cborb::Decoding::Types::SimpleValue do
  it_behaves_like "definite-length type"
  it_behaves_like "non-following data type"

  describe ".decode" do
    subject { described_class.decode(state, additional_info) }

    let(:state) do
      instance_double(Cborb::Decoding::State).tap do |mock|
        allow(mock).to receive(:accept_value)
      end
    end

    context "If additional information is 20" do
      let(:additional_info) { 20 }

      it "Calls #accept_value with false" do
        subject
        expect(state).to have_received(:accept_value).with(described_class, false)
      end
    end

    context "If additional information is 21" do
      let(:additional_info) { 21 }

      it "Calls #accept_value with true" do
        subject
        expect(state).to have_received(:accept_value).with(described_class, true)
      end
    end

    context "If additional information is 22" do
      let(:additional_info) { 22 }

      it "Calls #accept_value with nil" do
        subject
        expect(state).to have_received(:accept_value).with(described_class, nil)
      end
    end

    context "If additional information is 23" do
      let(:additional_info) { 23 }

      it "Calls #accept_value with nil" do
        subject
        expect(state).to have_received(:accept_value).with(described_class, nil)
      end
    end
  end
end
