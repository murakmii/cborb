RSpec.describe Cborb::Decoding::Types::IndefiniteMap do
  it_behaves_like "indefinite-length type"

  describe ".decode" do
    subject { described_class.decode(state, 31) }

    let(:state) { instance_double(Cborb::Decoding::State) }

    it "Pushes intermediate data to stack" do
      allow(state).to receive(:push_stack)
      subject
      expect(state).to have_received(:push_stack).with(described_class, [])
    end
  end

  describe ".accept" do
    subject { described_class.accept(im_data, type, value) }

    context "If key or value follows" do
      let(:im_data) { ["a", 1, "b"] }
      let(:type) { Cborb::Decoding::Types::Integer }
      let(:value) { 2 }

      it { is_expected.to be Cborb::Decoding::State::CONTINUE }

      it "Appends byte string to intermediate string" do
        expect { subject }.to change { im_data }.from(["a", 1, "b"]).to(["a", 1, "b", 2])
      end
    end

    context 'If "break" stop code follows' do
      let(:im_data) { ["a", 1, "b", 2] }
      let(:type) { Cborb::Decoding::Types::Break }
      let(:value) { type }

      it { is_expected.to eq({ "a" => 1, "b" => 2 }) }
    end

    context 'If "break" stop code follows after key data' do
      let(:im_data) { ["a", 1, "b"] }
      let(:type) { Cborb::Decoding::Types::Break }
      let(:value) { type }

      it "Raises error" do
        expect { subject }.to raise_error(Cborb::DecodingError, "Invalid indefinite-length map")
      end
    end
  end
end
