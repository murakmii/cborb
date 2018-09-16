RSpec.describe Cborb::Decoding::Types::Array do
  it_behaves_like "definite-length type"

  describe ".decode" do
    subject { described_class.decode(state, additional_info) }

    let(:additional_info) { 25 }
    let(:state) do
      # additional_info = 25 means that following 2 bytes to represent array size
      instance_double(Cborb::Decoding::State).tap do |mock|
        allow(mock).to receive(:consume).with(2).and_return([1000].pack("S>"))
      end
    end

    it "Pushes intermediate data to stack" do
      allow(state).to receive(:push_stack)
      subject
      expect(state).to have_received(:push_stack) do |type, im|
        expect(type).to be described_class
        expect(im.size).to eq 1000
        expect(im.array).to be_empty
      end
    end
  end

  describe ".accept" do
    subject { described_class.accept(im_data, type, value) }

    let(:type) { Cborb::Decoding::Types::Integer }
    let(:value) { 123 }

    context "If array is unoccupied" do
      let(:im_data) { described_class::Intermediate.new(3, [456]) }

      it { is_expected.to be Cborb::Decoding::State::CONTINUE }

      it "Appends value to intermediate array" do
        expect { subject }.to change { im_data.array }.from([456]).to([456, 123])
      end
    end

    context "If array is occupied" do
      let(:im_data) { described_class::Intermediate.new(3, [456, 789]) }

      it { is_expected.to eq [456, 789, 123] }
    end
  end
end
