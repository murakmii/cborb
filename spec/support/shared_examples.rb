RSpec.shared_examples "definite-length type" do
  describe ".indefinite?" do
    subject { described_class.indefinite? }

    it { is_expected.to be false }
  end
end

RSpec.shared_examples "indefinite-length type" do
  describe ".indefinite?" do
    subject { described_class.indefinite? }

    it { is_expected.to be true }
  end
end

RSpec.shared_examples "non-following data type" do
  describe ".accept" do
    subject { described_class.accept(nil, nil, nil) }

    it "Raises error" do
      expect { subject }.to raise_error("#{described_class} can't accept value")
    end
  end
end
