# whitespace [![Version](https://img.shields.io/badge/version-v0.1.0-orange.svg?style=flat)](https://github.com/yuanqing/whitespace/releases) [![Build Status](https://img.shields.io/travis/yuanqing/whitespace.svg?branch=master&style=flat)](https://travis-ci.org/yuanqing/whitespace)

> A shell script for visualising the whitespace characters in text files.

## Usage

```
usage: whitespace file start_line [end_line]
  [-s [space_marker]]
  [-t [tab_marker]]
  [-r [carriage_return_marker]]
  [-n [newline_marker]]
  [-L [left_delimeter]]
  [-R [right_delimeter]]
```

## Example

```
$ cat foo
foo  bar
baz  qux
bim  bam
$ whitespace foo 1 2
foo(\s)(\s)bar(\n)baz(\t)qux(\n)
$ whitespace foo 1
foo(\s)(\s)bar(\n)
$ whitespace foo 1 -s S -n N
foo(S)(S)bar(N)
$ whitespace foo 1 -s S -n N -L [ -R ]
foo[S][S]bar[N]
```

## Tests

Run the [Roundup](https://github.com/bmizerany/roundup) tests like so:

```
$ cd test
$ sh vendor/roundup.sh
```

## Installation

To install `whitespace` into `/usr/local/bin`, run the [`install.sh`](https://github.com/yuanqing/whitespace/blob/master/install.sh) script:

```
$ curl -sS -o install.sh https://raw.githubusercontent.com/yuanqing/whitespace/master/install.sh
$ sh install.sh
```

## Changelog

- 0.1.0
  - Initial release

## License

[MIT](https://github.com/yuanqing/whitespace/blob/master/LICENSE)
