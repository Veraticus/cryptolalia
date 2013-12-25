# cryptolalia

Are you envious of your hacker friends, government entities, and corporate spies who trade fancy codes back and forth using crazy ciphers involving the Hebrew alphabet, the Declaration of Independence, and image steganography? Well, now you too can create fun ciphertexts using extremely esoteric ciphers, all in the ease and comfort of your own console!

cryptolalia is designed to produce fun ciphertext puzzles from plaintexts. The resulting ciphertexts are secure through obscurity -- a dedicated person with enough time could probably crack your codes, using some combination of frequency analysis, crypto knowledge, and good research, but it'll take them awhile.

## Example

![Rainbows](http://veratic.us/T6e5)

The above image contains a ciphertext! It was inserted there using cryptolalia to do the following:

1. The plaintext ("secrets are fun") was transformed with a Beale homophonic substitution cipher with the Declaration of Independence as a source text:
```ruby
beale = Cryptolalia::Cipher::Beale.new
beale.file = "test/fixtures/Declaration\ of\ Independence.txt"
beale.plaintext = 'secrets are fun'
beale.encode! # "1009 1041 855 422 594 744 1100 614 405 187 282 1088 1107"
```
2. The result of the Beale cipher ("1009 1041 855 422 594 744 1100 614 405 187 282 1088 1107") is fed into an atbash inversion cipher with an alphabet of all numbers from 0 to 10000:
```ruby
atbash = Cryptolalia::Cipher::Atbash.new
atbash.alphabet = (0..10000).to_a.collect(&:to_s)
atbash.encode! # "999910000100009991 99991000099969999 999299959995 999699989998 999599919996 999399969996 999999991000010000 999499999996 9996100009995 999999929993 999899929998 99991000099929992 99999999100009993"
```
3. The result of the Atbash cipher ("999910000100009991 99991000099969999 999299959995 999699989998 999599919996 999399969996 999999991000010000 999499999996 9996100009995 999999929993 999899929998 99991000099929992 99999999100009993") is further moved into a steganographic PNG cipher to encode it into the least-significant bits of an image:
```ruby
steg = Cryptolalia::Cipher::Steganography.new
steg.file = "test/fixtures/sample.png"
steg.encode_in = :lsb
steg.output_file = File.open('rainbow.png', 'w+')
steg.encode! # true, see the file above
```

## Ciphers

### Atbash Inversion

### Beale Homophonic Substitution

### Caesar

### Pollux

### Steganography

## Attribution

The included Declaration of Indepenence file was taken from Project Gutenberg (http://www.gutenberg.org/ebooks/1). It has been altered to include only the text from the document itself, removing the Project Gutenberg copyright notices as allowed by the Project Gutenberg license (http://www.gutenberg.org/wiki/Gutenberg:The_Project_Gutenberg_License).

## A Note on Security

This might seem obvious, but...

cryptolalia is *not* designed to create cryptographically-secure ciphertexts. All of these ciphers are vulnerable. Some are more easy to solve than others, but all of them are eventually solvable. cryptolalia is intended to be used for the creation of interesting puzzles, not to hide your nuclear secrets, so please don't use it for anything serious.

## Copyright

Copyright (c) 2013 Josh Symonds.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
