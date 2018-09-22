RSpec.describe Cborb::Decoding::Types::Tag do
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
        expect(im).to eq 1000
      end
    end
  end

  describe ".accept" do
    subject { described_class.accept(1000, Cborb::Decoding::Types::Integer, value) }

    let(:value) { [1, 2, 3] }

    it { is_expected.to eq value }
  end
end
