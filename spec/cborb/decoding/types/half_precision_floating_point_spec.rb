RSpec.describe Cborb::Decoding::Types::HalfPrecisionFloatingPoint do
  it_behaves_like "definite-length type"
  it_behaves_like "non-following data type"

  describe ".decode" do
    pending
  end
end
