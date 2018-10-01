# Cborb

[![Gem Version](https://badge.fury.io/rb/cborb.svg)](https://badge.fury.io/rb/cborb)
[![CircleCI](https://circleci.com/gh/murakmii/cborb/tree/master.svg?style=svg)](https://circleci.com/gh/murakmii/cborb/tree/master)

Cborb is a pure ruby decoder for CBOR([RFC 7049](https://tools.ietf.org/html/rfc7049))

```rb
require "cborb"

decoder = Cborb::Decoding::Decoder.new

decoder.decode("\x83\x01")
decoder.finished? # => false

decoder.decode("\x02\x03\x04")
decoder.finished? # => true

decoder.result # => [1, 2, 3]
decoder.remaining_bytes # => "\x04"

# Shorthand
Cborb.decode("\x83\x01\x02\x03") # => [1, 2, 3]
```

## Handling indefinite-length data

Cborb can handle indefinite-length data(array, map, byte string, unicode string).

```rb
Cborb.decode("\x9F\x01\x82\x02\x03\x9F\x04\x05\xFF\xFF") # => [1, [2, 3], [4, 5]]
```

## Handling tags

If Cborb encounters a tag, generates instance of `Cborb::Decoding::TaggedValue`.  
That contains tag number and original value.

```rb
Cborb.decode "\xC0" + "\x71" + "1970-01-01T00:00Z"
# => #<struct Cborb::Decoding::TaggedValue tag=0, value="1970-01-01T00:00Z">
```

## Handling simple values

Cborb can handle simple values(true, false, nil, undefined).

```rb
Cborb.decode "\xF5" # => true
```

"Undefined" doesn't exist in Ruby.
So, Cborb converts "undefined" to `nil`.

```rb
Cborb.decode "\xF7" # => nil
```

If Cborb encounters unassigned simple value, generates instance of `Cborb::Decoding::UnassignedSimpleValue`.  
That contains simple value number.

```rb
Cborb.decode "\xEF"
# => #<struct Cborb::Decoding::UnassignedSimpleValue number=15>
```

## Handling concatenated CBOR

By default, when decoder received concatenated CBOR, that raises error.

```rb
Cborb.decode("\x83\x01\x02\x03\x04") # => Cborb::InvalidByteSequenceError
```

If you want to decode concatenated CBOR, set `concatenated` option to `true`.
Decoder decodes whole of concatenated CBOR and returns instance of `Cborb::Decoding::Concatenated`.

```rb
results = Cborb.decode("\x83\x01\x02\x03\x04", concatenated: true)
# => #<Cborb::Decoding::Concatenated:0x00007fcb1b8b2e30 @decoded=[[1, 2, 3], 4]>

results.first # => [1, 2, 3]
results.last  # => 4
```

## Development

```bash
# Clone
git clone git@github.com:murakmii/cborb && cd cborb

# Setup
bin/setup

# Edit code...

# Run test
bundle exec rspec
```

## Contribution

Contributions are always welcome :kissing_heart:
