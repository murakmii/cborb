RSpec.describe Cborb::Decoding::Types::IndefiniteArray do
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

    context "If any data follows" do
      let(:im_data) { [123] }
      let(:type) { Cborb::Decoding::Types::Integer }
      let(:value) { 456 }

      it { is_expected.to be Cborb::Decoding::State::CONTINUE }

      it "Appends value to intermediate array" do
        expect { subject }.to change { im_data }.from([123]).to([123, 456])
      end
    end

    context 'If "break" stop code follows' do
      let(:im_data) { [123] }
      let(:type) { Cborb::Decoding::Types::Break }
      let(:value) { Cborb::Decoding::Types::Break }

      it { is_expected.to eq [123] }
    end
  end
end
