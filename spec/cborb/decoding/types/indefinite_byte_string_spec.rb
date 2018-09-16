RSpec.describe Cborb::Decoding::Types::IndefiniteByteString do
  it_behaves_like "indefinite-length type"

  describe ".decode" do
    subject { described_class.decode(state, 31) }

    let(:state) { instance_double(Cborb::Decoding::State) }

    it "Pushes intermediate data to stack" do
      allow(state).to receive(:push_stack)
      subject
      expect(state).to have_received(:push_stack) do |type, im_data|
        expect(type).to be described_class
        expect(im_data).to be_a(String)
        expect(im_data).to be_empty
        expect(im_data.encoding).to eq Encoding::ASCII_8BIT
      end
    end
  end

  describe ".accept" do
    subject { described_class.accept(im_data, type, value) }

    context "If byte string follows" do
      let(:default_byte_string) { SecureRandom.random_bytes(10) }
      let(:im_data) { default_byte_string.dup }
      let(:type) { Cborb::Decoding::Types::ByteString }
      let(:value) { SecureRandom.random_bytes(10) }

      it { is_expected.to be Cborb::Decoding::State::CONTINUE }

      it "Appends byte string to intermediate string" do
        expect { subject }.to change { im_data }.from(default_byte_string).to(default_byte_string + value)
      end
    end

    context 'If "break" stop code follows' do
      let(:im_data) { SecureRandom.random_bytes(10) }
      let(:type) { Cborb::Decoding::Types::Break }
      let(:value) { Cborb::Decoding::Types::Break }

      it { is_expected.to eq im_data }
    end

    context "If data that is not byte string follows" do
      let(:im_data) { SecureRandom.random_bytes(10) }
      let(:type) { Cborb::Decoding::Types::Integer }
      let(:value) { 123 }

      it "Raises error" do
        expect { subject }.to raise_error(Cborb::DecodingError, "Unexpected chunk for indefinite byte string")
      end
    end
  end
end
