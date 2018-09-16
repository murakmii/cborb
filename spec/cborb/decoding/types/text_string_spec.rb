RSpec.describe Cborb::Decoding::Types::TextString do
  it_behaves_like "definite-length type"
  it_behaves_like "non-following data type"

  describe ".decode" do
    subject { described_class.decode(state, 25) }

    let(:text) { "おはようございます" }
    let(:text_as_binary) { text.dup.force_encoding(Encoding::ASCII_8BIT) }
    let(:state) do
      instance_double(Cborb::Decoding::State).tap do |mock|
        allow(mock).to receive(:consume).with(2).and_return([text_as_binary.size].pack("S>"))
        allow(mock).to receive(:consume).with(text_as_binary.size).and_return(text_as_binary)
      end
    end

    it "Calls #accept_value with text that is encoded UTF-8" do
      allow(state).to receive(:accept_value)
      subject
      expect(state).to have_received(:accept_value) do |type, value|
        expect(type).to be described_class
        expect(value).to eq text
        expect(value.encoding).to eq Encoding::UTF_8
      end
    end
  end
end
