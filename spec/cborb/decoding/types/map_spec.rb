RSpec.describe Cborb::Decoding::Types::Map do
  it_behaves_like "definite-length type"

  describe ".decode" do
    subject { described_class.decode(state, additional_info) }

    let(:additional_info) { 25 }
    let(:state) do
      # additional_info = 25 means that following 2 bytes to represent map size
      instance_double(Cborb::Decoding::State).tap do |mock|
        allow(mock).to receive(:consume).with(2).and_return([1000].pack("S>"))
      end
    end

    it "Pushes intermediate data to stack" do
      allow(state).to receive(:push_stack)
      subject
      expect(state).to have_received(:push_stack) do |type, im|
        expect(type).to be described_class
        expect(im.size).to eq 2000
        expect(im.keys_and_values).to be_empty
      end
    end

    context "If size is 0" do
      let(:additional_info) { 0 }

      it "Calls #accept_value with empth hash" do
        allow(state).to receive(:accept_value)
        subject
        expect(state).to have_received(:accept_value).with(described_class, {})
      end
    end
  end

  describe ".accept" do
    subject { described_class.accept(im_data, type, value) }

    let(:type) { Cborb::Decoding::Types::Integer }

    context "If array is unoccupied" do
      let(:im_data) { described_class::Intermediate.new(4, ["a"]) }
      let(:value) { 123 }

      it { is_expected.to be Cborb::Decoding::State::CONTINUE }

      it "Appends value to intermediate array" do
        expect { subject }.to change { im_data.keys_and_values }.from(["a"]).to(["a", value])
      end
    end

    context "If array is occupied" do
      let(:im_data) { described_class::Intermediate.new(4, ["a", 123, "b"]) }
      let(:value) { 456 }

      it { is_expected.to eq({ "a" => 123, "b" => 456 }) }
    end
  end
end
