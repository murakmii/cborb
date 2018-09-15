# Cborb

Cborb is a pure ruby decoder for CBOR([RFC 7049](https://tools.ietf.org/html/rfc7049))

```rb
require "cborb"

decoder = Cborb::Decoding::Decoder.new

decoder.decode("\x83\x01")
decoder.finished? # => false

decoder.decode("\x02\x03")
decoder.finished? # => true

decoder.result # => [1, 2, 3]

# Shorthand
Cborb.decode("\x83\x01\x02\x03") # => [1, 2, 3]
```
