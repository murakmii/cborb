RSpec.describe Cborb::Decoding::Types::Break do
  it_behaves_like "definite-length type"
  it_behaves_like "non-following data type"

  describe ".decode" do
    subject { described_class.decode(state, 31) }

    let(:state) do
      instance_double(Cborb::Decoding::State).tap do |mock|
        allow(mock).to receive(:stack_top).and_return(stack_top_type)
      end
    end

    context "If definite-type exists on top of stack" do
      let(:stack_top_type) { Cborb::Decoding::Types::Array }

      it "Raises exception" do
        expect { subject }.to raise_error(Cborb::DecodingError, 'Unexpected "break" stop code')
      end
    end

    context "If indefinite-type exists on top of stack" do
      let(:stack_top_type) { Cborb::Decoding::Types::IndefiniteArray }

      it "Calls #accept_value with self" do
        allow(state).to receive(:accept_value)
        subject
        expect(state).to have_received(:accept_value).with(described_class, described_class)
      end
    end
  end
end
