# Cborb

Cborb is a pure ruby decoder for CBOR([RFC 7049](https://tools.ietf.org/html/rfc7049))

```rb
require "cborb"

Cborb.decode("\x83\x01\x02\x03")
# => [1, 2, 3]
```
