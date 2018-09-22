RSpec.describe Cborb::Decoding::Types::Tag do
  it_behaves_like "definite-length type"

  describe ".decode" do
    subject { described_class.decode(state, additional_info) }

    let(:additional_info) { 0 }
    let(:state) { instance_double(Cborb::Decoding::State) }

    it "Pushes intermediate data to stack" do
      allow(state).to receive(:push_stack)
      subject
      expect(state).to have_received(:push_stack) do |type, im|
        expect(type).to be described_class
        expect(im).to eq 0
      end
    end
  end

  describe ".accept" do
    subject { described_class.accept(im_data, Cborb::Decoding::Types::TextString, value) }

    let(:im_data) { 0 }
    let(:value) { "1970-01-01T00:00Z" }

    it "returns instance of Cborb::Decoding::TaggedValue" do
      expect(subject.tag).to eq im_data
      expect(subject.value).to eq value
    end
  end
end
