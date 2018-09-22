module Cborb::SpecHelper
  def read_cbor_fixture(name)
    path = File.join(File.dirname(__FILE__), "../fixtures/#{name}.cbor")
    File.read(path, mode: "rb")
  end
end
