RSpec.describe Cborb::Decoding::Types::IntegerDecodable do
  let(:stub) { Object.new.tap { |obj| obj.extend(described_class) } }

  describe ".consume_as_integer" do
    subject { stub.consume_as_integer(state, additional_info) }

    let(:state) { instance_double(Cborb::Decoding::State) }

    context "If additional information is lesser than 24" do
      let(:additional_info) { 23 }

      it { is_expected.to eq additional_info }

      it "doesn't consume data" do
        allow(state).to receive(:consume)
        subject
        expect(state).not_to have_received(:consume)
      end
    end

    context "If additional information is 24" do
      let(:additional_info) { 24 }

      before do
        allow(state).to receive(:consume).with(1).and_return("\xFF")
      end

      it { is_expected.to eq 0xFF }
    end

    context "If additional information is 25" do
      let(:additional_info) { 25 }

      before do
        allow(state).to receive(:consume).with(2).and_return("\xFF\xFF")
      end

      it { is_expected.to eq 0xFFFF }
    end

    context "If additional information is 26" do
      let(:additional_info) { 26 }

      before do
        allow(state).to receive(:consume).with(4).and_return("\xFF\xFF\xFF\xFF")
      end

      it { is_expected.to eq 0xFFFFFFFF }
    end

    context "If additional information is 27" do
      let(:additional_info) { 27 }

      before do
        allow(state).to receive(:consume).with(8).and_return("\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF")
      end

      it { is_expected.to eq 0xFFFFFFFFFFFFFFFF }
    end
  end
end
