RSpec.describe Cborb do
  describe ".decode" do
    subject { described_class.decode(cbor, **opts) }

    let(:opts) { {} }

    context "If CBOR is well-formed" do
      let(:cbor) { "\x83\x01\x02\x03" }

      it "returns value decoded" do
        expect(subject).to eq [1, 2, 3]
      end
    end

    context "If CBOR has extra byte string" do
      let(:cbor) { "\x83\x01\x02\x03\x04" }

      it { expect { subject }.to raise_error(Cborb::InvalidByteSequenceError) }
    end

    context "If CBOR is shortage" do
      let(:cbor) { "\x83\x01\x02" }

      it { expect { subject }.to raise_error(Cborb::InvalidByteSequenceError) }
    end

    context 'If "concatenated" param is true' do
      let(:opts) { { concatenated: true } }

      context "and CBOR is well-formed" do
        let(:cbor) { "\x83\x01\x02\x03" }

        it "returns value decoded" do
          expect(subject).to be_a Cborb::Decoding::Concatenated
          expect(subject.size).to eq 1
          expect(subject.first).to eq [1, 2, 3]
        end
      end

      context "and CBOR has extra byte string" do
        let(:cbor) { "\x83\x01\x02\x03\x04" }

        it "returns value decoded" do
          expect(subject).to be_a Cborb::Decoding::Concatenated
          expect(subject.size).to eq 2
          expect(subject.first).to eq [1, 2, 3]
          expect(subject.last).to eq 4
        end
      end

      context "If CBOR is shortage" do
        let(:cbor) { "\x83\x01\x02" }

        it { expect { subject }.to raise_error(Cborb::InvalidByteSequenceError) }
      end
    end
  end
end
