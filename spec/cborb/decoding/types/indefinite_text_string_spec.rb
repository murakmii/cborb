RSpec.describe Cborb::Decoding::Types::IndefiniteTextString do
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
        expect(im_data.encoding).to eq Encoding::UTF_8
      end
    end
  end

  describe ".accept" do
    subject { described_class.accept(im_data, type, value) }

    context "If text string follows" do
      let(:default_text) { "おはよう" }
      let(:im_data) { default_text.dup }
      let(:type) { Cborb::Decoding::Types::TextString }
      let(:value) { "ございます" }

      it { is_expected.to be Cborb::Decoding::State::CONTINUE }

      it "Appends text string to intermediate string" do
        expect { subject }.to change { im_data }.from(default_text).to(default_text + value)
      end
    end

    context 'If "break" stop code follows' do
      let(:im_data) { "おはようございます" }
      let(:type) { Cborb::Decoding::Types::Break }
      let(:value) { Cborb::Decoding::Types::Break }

      it { is_expected.to eq im_data }
    end

    context "If data that is not text string follows" do
      let(:im_data) { "おはようございます" }
      let(:type) { Cborb::Decoding::Types::Integer }
      let(:value) { 123 }

      it "Raises error" do
        expect { subject }.to raise_error(Cborb::DecodingError, "Unexpected chunk for indefinite text string")
      end
    end
  end
end
