# cryptolalia

Are you envious of your hacker friends, government entities, and corporate spies who trade fancy codes back and forth using crazy ciphers involving the Hebrew alphabet, the Declaration of Independence, and image steganography? Well, now you too can create fun ciphertexts using extremely esoteric ciphers, all in the ease and comfort of your own console!

cryptolalia is designed to produce fun ciphertext puzzles from plaintexts. A dedicated person with enough time could probably crack your codes, using some combination of frequency analysis, crypto knowledge, and good research, but it'll take them awhile. And hopefully it'll prove entertaining for them.

## Encoding Example

![Rainbows](http://f.cl.ly/items/2D0N2H0Z2T3M0R3J3p0X/rainbow.png)

The above image contains a ciphertext! It was inserted there using cryptolalia in the following manner:

1. The plaintext ("secrets are fun") was transformed with a Pollux Morse code cipher:

```ruby
pollux = Cryptolalia::Cipher::Pollux.new
pollux.plaintext = 'secrets are fun'
pollux.dot = ['a', 'b', 'c']
pollux.dash = ['d', 'e', 'f']
pollux.seperator = ['g', 'h', 'i']
pollux.encode! # "ccchagfadbgafcgbgficbaiadiadbgbgccfbhbbegfai"
```

1. The result of the Pollux cipher is fed into a Beale homophonic substitution cipher with the Declaration of Independence as a source text:

```ruby
beale = Cryptolalia::Cipher::Beale.new
beale.plaintext = "ccchagfadbgafcgbgficbaiadiadbgbgccfbhbbegfai"
beale.file = "test/fixtures/Declaration\ of\ Independence.txt"
beale.encode! # "917 574 917 978 254 366 1016 1111 601 99 860 872 1197 1225 1259 692 308 305 667 1217 913 10 1235 61 415 12 690 1267 1138 794 1061 794 1287 819 960 1068 580 1246 1040 594 837 754 518 1048"
```

3. The result of the homophonic substitution cipher is further moved into a steganographic PNG cipher to encode it into the least-significant bits of an image:

```ruby
steg = Cryptolalia::Cipher::Steganography.new
steg.plaintext = "917 574 917 978 254 366 1016 1111 601 99 860 872 1197 1225 1259 692 308 305 667 1217 913 10 1235 61 415 12 690 1267 1138 794 1061 794 1287 819 960 1068 580 1246 1040 594 837 754 518 1048"
steg.file = "test/fixtures/sample.png"
steg.encoded_in = :lsb
steg.output_file = File.open('rainbow.png', 'w+')
steg.encode! # true, see the file above
```

Don't believe me? You can decode it yourself, also using cryptolalia:

1. Download the file above (rainbow.png) locally and decipher it with the steganographic PNG decipherer:

```ruby
steg = Cryptolalia::Cipher::Steganography.new
steg.file = 'rainbow.png'
steg.encoded_in = :lsb
steg.decode! # A very very long string, starting with: "917 574 917 978 254 366 1016 1111 601 99 860 872 1197 1225 1259 692 308 305 667 1217 913 10 1235 61 415 12 690 1267 1138 794 1061 794 1287 819 960 1068 580 1246 1040 594 837 754 518 1048"
```

2. Insert the numbers of the Beale homophonic substitution cipher back in:

```ruby
beale = Cryptolalia::Cipher::Beale.new
beale.ciphertext = "917 574 917 978 254 366 1016 1111 601 99 860 872 1197 1225 1259 692 308 305 667 1217 913 10 1235 61 415 12 690 1267 1138 794 1061 794 1287 819 960 1068 580 1246 1040 594 837 754 518 1048"
beale.file = "test/fixtures/Declaration\ of\ Independence.txt"
beale.decode! # "ccchagfadbgafcgbgficbaiadiadbgbgccfbhbbegfai"
```

3. And finally, plug it right back into the Pollux cipher:

```ruby
pollux = Cryptolalia::Cipher::Pollux.new
pollux.ciphertext = "ccchagfadbgafcgbgficbaiadiadbgbgccfbhbbegfai"
pollux.dot = ['a', 'b', 'c']
pollux.dash = ['d', 'e', 'f']
pollux.seperator = ['g', 'h', 'i']
pollux.decode! # "secretsarefun"
```

## Ciphers

### Atbash Inversion

### Beale Homophonic Substitution

### Caesar

### Pollux

### Steganography

### Vigenere

## Attribution

The included Declaration of Indepenence file was taken from Project Gutenberg (http://www.gutenberg.org/ebooks/1). It has been altered to include only the text from the document itself, removing the Project Gutenberg copyright notices as allowed by the Project Gutenberg license (http://www.gutenberg.org/wiki/Gutenberg:The_Project_Gutenberg_License).

## A Note on Security

This might seem obvious, but...

cryptolalia is **not** designed to create cryptographically-secure ciphertexts. All of these ciphers are vulnerable -- some may be easy to solve and others difficult, but all of them are eventually solvable. cryptolalia is intended to be used for the creation of interesting puzzles, not to hide your nuclear secrets, so please don't use it for anything serious.

## Copyright

Copyright (c) 2013 Josh Symonds.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
