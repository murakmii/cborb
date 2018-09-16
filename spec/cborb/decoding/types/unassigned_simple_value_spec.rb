RSpec.describe Cborb::Decoding::Types::UnassignedSimpleValue do
  it_behaves_like "definite-length type"
  it_behaves_like "non-following data type"

  describe ".decode" do
    subject { described_class.decode(instance_double(Cborb::Decoding::State), 0) }

    it "Always raises error" do
      expect { subject }.to raise_error(Cborb::DecodingError, "Included unassigned simple value")
    end
  end
end
