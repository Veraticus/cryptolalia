# cryptolalia

Are you envious of your hacker friends, government entities, and corporate spies who trade fancy codes back and forth using crazy ciphers involving the Hebrew alphabet, the Declaration of Independence, and image steganography? Well, now you too can create fun ciphertexts using extremely esoteric ciphers, all in the ease and comfort of your own console!

cryptolalia is designed to produce fun ciphertext puzzles from plaintexts. A dedicated person with enough time could probably crack your codes, using some combination of frequency analysis, crypto knowledge, and good research. How long it'll take them will probably depend on their cleverness and the obviousness of your ciphers and keys.

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

2. The result of the Pollux cipher is fed into a Beale homophonic substitution cipher with the Declaration of Independence as a source text:
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

Bold cipher attributes are required; normal strength are optional.

### Atbash Inversion

The [atbash inversion cipher](http://en.wikipedia.org/wiki/Atbash), originally a Hebrew cipher, works just as well in English. It's a simple substitution cipher that encodes the ciphertext by reversing each letter's position in the target alphabet. (So "a" becomes "z", "b" becomes "y", and so on.)

##### Encoding Usage

* **plaintext** - the plaintext to encode.
* alphabet - the alphabet in which to encode the plaintext. (Default: `('a'..'z').to_a`)

##### Decoding Usage

* **ciphertext** - the ciphertext to decode.
* alphabet - the alphabet from which to decode the ciphertext. (Default: `('a'..'z').to_a`)

### Beale Homophonic Substitution

The [Beale homophonic substitution cipher](http://en.wikipedia.org/wiki/Substitution_cipher#Homophonic_substitution) requires an input file in text format. For each letter in the ciphertext, it finds a word in the source text that begins with that letter and adds its position in the source to the ciphertext. Choose something appropriately long and widely-known for your source text, like the Bible, or else no one will ever figure out your cipher.

##### Encoding Usage

* **plaintext** - the plaintext to encode.
* **file** - the file to use as a source for the cipher.
* only_first_word - whether to always choose the first word with that letter in the source text, or some random word with that letter. (Default: `false`)
* nth_letter - which letter of the word to use to match to the plaintext to create the ciphertext. (Default: `1`)

##### Decoding Usage

* **ciphertext** - the ciphertext to decode.
* **file** - the file to use as a source for the cipher.
* nth_letter - which letter of the word was used to generate the ciphertext from the source. (Default: `1`)

### Caesar

The classic [Caesar cipher](http://en.wikipedia.org/wiki/Caesar_cipher) is a simple rotational cipher. Each letter of the plaintext is rotated a constant amount in its alphabet to generate the ciphertext. (So with a rotation of 1, "a" becomes "b", "b" becomes "c", and so on.)

##### Encoding Usage

* **plaintext** - the plaintext to encode.
* **rot** - the distance to rotate through the alphabet.
* alphabet - the alphabet to use for encoding. (Default: `('a'..'z').to_a`)

##### Decoding Usage

* **ciphertext** - the ciphertext to decode.
* **rot** - the distance to rotate through the alphabet.
* alphabet - the alphabet to use for decoding. (Default: `('a'..'z').to_a`)

### Pollux

The [Pollux Morse code cipher](http://www.cryptool-online.org/index.php?option=com_content&view=article&id=66&Itemid=76&lang=en) translates each letter of the plaintext into the Morse alphabet -- but instead of only using dots and dashes, multiple possible letters or numbers are used that could translate to dots, dashes, or separators.

##### Encoding Usage

* **plaintext** - the plaintext to encode.
* dot - the characters to use for dots. (Default: 10 random UTF-8 characters)
* dash - the characters to use for dashes. (Default: 10 random UTF-8 characters)
* separators - the characters to use for separators. (Default: 10 random UTF-8 characters)

##### Decoding Usage

* **ciphertext** - the ciphertext to decode.
* **dot** - the characters to use for dots. (Default: 10 random UTF-8 characters)
* **dash** - the characters to use for dashes. (Default: 10 random UTF-8 characters)
* **separators** - the characters to use for separators. (Default: 10 random UTF-8 characters)

### Steganography

[Steganography](http://en.wikipedia.org/wiki/Steganography) is a technique to embed one message inside another, preferably in a manner that is very difficult to detect. cryptolalia incldues a PNG steganography cipher, that allows encoding or decoding of messages contained in PNG images. It uses one of two methods to do so: either `lsb` (least significant bit), which hides the binary encoding of a message in the least significant bit of every pixel of an image, or `comment`, which hides the message as a comment in the image's metadata.

##### Encoding Usage

* **plaintext** - the plaintext to encode.
* **file** - the image in which to encode the cipher.
* **output_file** - the location to output the encoded image.
* encoded_in - the method used to perform encoding, either `:lsb` or `:comment`. (Default: `:lsb`)

##### Decoding Usage

* **file** - the image in which the cipher is encoded.
* **encoded_in** - the method used to encode the cipher, either `:lsb` or `:comment`.

### Vigenere

The [Vigenere cipher](http://en.wikipedia.org/wiki/Vigenere_cipher) is a essentially a Caesar cipher with a rotation that changes on a per-letter basis. By supplying a keyword, every letter of the plaintext is encoded using a different rotation through its alphabet into the ciphertext.

##### Encoding Usage

* **plaintext** - the plaintext to encode.
* **keyword** - they keyword to use for moving the alphabet.
* alphabet - the alphabet to use for encoding. (Default: `('a'..'z').to_a`)

##### Decoding Usage

* **ciphertext** - the ciphertext to decode.
* **keyword** - they keyword used for moving the alphabet.
* alphabet - the alphabet to use for decoding. (Default: `('a'..'z').to_a`)

## Attribution

The included Declaration of Independence file was taken from Project Gutenberg (http://www.gutenberg.org/ebooks/1). It has been altered to include only the text from the document itself, removing the Project Gutenberg copyright notices as allowed by the Project Gutenberg license (http://www.gutenberg.org/wiki/Gutenberg:The_Project_Gutenberg_License).

## A Note on Security

This might seem obvious, but...

cryptolalia is **not** designed to create cryptographically-secure ciphertexts. All of these ciphers are vulnerable -- some may be easy to solve and others difficult, but all of them are eventually solvable. cryptolalia is intended to be used for the creation of interesting puzzles, not to hide your nuclear secrets, so please don't use it for anything serious.

## Copyright

Copyright (c) 2013 Josh Symonds.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
