RSpec.describe Cborb::Decoding::Types::FloatingPoint do
  it_behaves_like "definite-length type"
  it_behaves_like "non-following data type"

  describe ".decode" do
    subject { described_class.decode(state, additional_info) }

    let(:state) do
      instance_double(Cborb::Decoding::State).tap do |mock|
        allow(mock).to receive(:consume).with(floatint_point_bytes.size).and_return(floatint_point_bytes)
      end
    end

    context "for 32bit floating point" do
      let(:additional_info) { 26 }
      let(:floatint_point_bytes) { [12.34].pack("g") }

      it "Calls #accept_value with floatin point value" do
        allow(state).to receive(:accept_value)
        subject
        expect(state).to have_received(:accept_value).with(described_class, be_within(0.000001).of(12.34))
      end
    end

    context "for 64bit floating point" do
      let(:additional_info) { 27 }
      let(:floatint_point_bytes) { [123.456].pack("G") }

      it "Calls #accept_value with floatin point value" do
        allow(state).to receive(:accept_value)
        subject
        expect(state).to have_received(:accept_value).with(described_class, 123.456)
      end
    end
  end
end
