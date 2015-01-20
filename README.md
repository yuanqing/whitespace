# whitespace [![Version](https://img.shields.io/badge/version-v0.0.0-orange.svg?style=flat)](https://github.com/yuanqing/whitespace/releases) [![Build Status](https://img.shields.io/travis/yuanqing/whitespace.svg?style=flat)](https://travis-ci.org/yuanqing/whitespace)

> A shell script for visualising the whitespace characters in text files.

## Usage

```
Usage: whitespace file [line_number | line_number_range]
  [-s [space]] [-t [tab]] [-r [carriage]] [-n [newline]]
  [-L [left_delimeter]] [-R [right_delimeter]]
```

## Tests

Run the [Roundup](https://github.com/bmizerany/roundup) tests like so:

```sh
$ cd test
$ sh roundup.sh
```

## Installation

To install `whitespace` into `/usr/local/bin`, run the [`install.sh`](https://raw.githubusercontent.com/yuanqing/whitespace/master/install.sh) script:

```sh
$ curl -sS -o install.sh https://raw.githubusercontent.com/yuanqing/whitespace/master/install.sh
$ sh install.sh
```

## License

[MIT](https://github.com/yuanqing/whitespace/blob/master/LICENSE)
