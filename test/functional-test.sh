#!/usr/bin/env roundup

describe "whitespace: functional test"

__fail() {

  # check that $actual starts with "whitespace: "
  if [[ "$1" != "whitespace: "* ]]; then
    exit 1
  fi

}

it_errors_if_no_file_name_given() {

  __fail "$(../whitespace 2>&1)"

}

it_parses_entire_file_if_no_line_number_given() {

  test "$(../whitespace fixtures/s 2>&1)" = '(\s)'
  test "$(../whitespace fixtures/t 2>&1)" = '(\t)'
  test "$(../whitespace fixtures/r 2>&1)" = '(\r)'

  test "$(../whitespace fixtures/_ 2>&1)" = '(\n)'
  test "$(../whitespace fixtures/__ 2>&1)" = '(\n)(\n)'
  test "$(../whitespace fixtures/___ 2>&1)" = '(\n)(\n)(\n)'

  test "$(../whitespace fixtures/foo 2>&1)" = 'foo'
  test "$(../whitespace fixtures/foo_ 2>&1)" = 'foo(\n)'
  test "$(../whitespace fixtures/_foo 2>&1)" = '(\n)foo'
  test "$(../whitespace fixtures/_foo_ 2>&1)" = '(\n)foo(\n)'
  test "$(../whitespace fixtures/foo_foo 2>&1)" = 'foo(\n)foo'

  test "$(../whitespace fixtures/str 2>&1)" = '(\s)(\t)(\r)'
  test "$(../whitespace fixtures/str_ 2>&1)" = '(\s)(\t)(\r)(\n)'
  test "$(../whitespace fixtures/_str 2>&1)" = '(\n)(\s)(\t)(\r)'
  test "$(../whitespace fixtures/_str_ 2>&1)" = '(\n)(\s)(\t)(\r)(\n)'
  test "$(../whitespace fixtures/str_str 2>&1)" = '(\s)(\t)(\r)(\n)(\s)(\t)(\r)'

  test "$(../whitespace fixtures/@empty 2>&1)" = ''

  test "$(../whitespace fixtures/@complex 2>&1)" = 'foobar\s\t\r\n(\n)foo(\s)bar(\n)baz(\t)(\t)foo(\r)(\s)(\n)'

}

it_parses_a_valid_line_number() {

  test "$(../whitespace fixtures/s 1 2>&1)" = '(\s)'
  test "$(../whitespace fixtures/t 1 2>&1)" = '(\t)'
  test "$(../whitespace fixtures/r 1 2>&1)" = '(\r)'

  test "$(../whitespace fixtures/_ 1 2>&1)" = '(\n)'
  test "$(../whitespace fixtures/__ 1 2>&1)" = '(\n)'
  test "$(../whitespace fixtures/__ 2 2>&1)" = '(\n)'
  test "$(../whitespace fixtures/___ 1 2>&1)" = '(\n)'
  test "$(../whitespace fixtures/___ 2 2>&1)" = '(\n)'
  test "$(../whitespace fixtures/___ 3 2>&1)" = '(\n)'

  test "$(../whitespace fixtures/foo 1 2>&1)" = 'foo'
  test "$(../whitespace fixtures/foo_ 1 2>&1)" = 'foo(\n)'
  test "$(../whitespace fixtures/_foo 1 2>&1)" = '(\n)'
  test "$(../whitespace fixtures/_foo 2 2>&1)" = 'foo'
  test "$(../whitespace fixtures/_foo_ 1 2>&1)" = '(\n)'
  test "$(../whitespace fixtures/_foo_ 2 2>&1)" = 'foo(\n)'
  test "$(../whitespace fixtures/foo_foo 1 2>&1)" = 'foo(\n)'
  test "$(../whitespace fixtures/foo_foo 2 2>&1)" = 'foo'

  test "$(../whitespace fixtures/str 1 2>&1)" = '(\s)(\t)(\r)'
  test "$(../whitespace fixtures/str_ 1 2>&1)" = '(\s)(\t)(\r)(\n)'
  test "$(../whitespace fixtures/_str 1 2>&1)" = '(\n)'
  test "$(../whitespace fixtures/_str 2 2>&1)" = '(\s)(\t)(\r)'
  test "$(../whitespace fixtures/_str_ 1 2>&1)" = '(\n)'
  test "$(../whitespace fixtures/_str_ 2 2>&1)" = '(\s)(\t)(\r)(\n)'
  test "$(../whitespace fixtures/str_str 1 2>&1)" = '(\s)(\t)(\r)(\n)'
  test "$(../whitespace fixtures/str_str 2 2>&1)" = '(\s)(\t)(\r)'

  test "$(../whitespace fixtures/@empty 1 2>&1)" = ''

  test "$(../whitespace fixtures/@complex 1 2>&1)" = 'foobar\s\t\r\n(\n)'
  test "$(../whitespace fixtures/@complex 2 2>&1)" = 'foo(\s)bar(\n)'
  test "$(../whitespace fixtures/@complex 3 2>&1)" = 'baz(\t)(\t)foo(\r)(\s)(\n)'

}

it_errors_if_invalid_line_number() {

  __fail "$(../whitespace fixtures/@complex 0 2>&1)"
  __fail "$(../whitespace fixtures/@complex -1 2>&1)"
  __fail "$(../whitespace fixtures/@complex foo 2>&1)"

}

it_parses_a_valid_line_number_range() {

  test "$(../whitespace fixtures/@complex 1,1 2>&1)" = 'foobar\s\t\r\n(\n)'
  test "$(../whitespace fixtures/@complex 1,2 2>&1)" = 'foobar\s\t\r\n(\n)foo(\s)bar(\n)'
  test "$(../whitespace fixtures/@complex 1,3 2>&1)" = 'foobar\s\t\r\n(\n)foo(\s)bar(\n)baz(\t)(\t)foo(\r)(\s)(\n)'
  test "$(../whitespace fixtures/@complex 1,4 2>&1)" = 'foobar\s\t\r\n(\n)foo(\s)bar(\n)baz(\t)(\t)foo(\r)(\s)(\n)'

  test "$(../whitespace fixtures/@complex 2,2 2>&1)" = 'foo(\s)bar(\n)'
  test "$(../whitespace fixtures/@complex 2,3 2>&1)" = 'foo(\s)bar(\n)baz(\t)(\t)foo(\r)(\s)(\n)'
  test "$(../whitespace fixtures/@complex 2,4 2>&1)" = 'foo(\s)bar(\n)baz(\t)(\t)foo(\r)(\s)(\n)'

  test "$(../whitespace fixtures/@complex 3,3 2>&1)" = 'baz(\t)(\t)foo(\r)(\s)(\n)'
  test "$(../whitespace fixtures/@complex 3,4 2>&1)" = 'baz(\t)(\t)foo(\r)(\s)(\n)'

}

it_errors_if_invalid_line_number_range() {

  __fail "$(../whitespace fixtures/@complex -1,-1 2>&1)"
  __fail "$(../whitespace fixtures/@complex -1,0 2>&1)"
  __fail "$(../whitespace fixtures/@complex -1,1 2>&1)"
  __fail "$(../whitespace fixtures/@complex -1,2 2>&1)"
  __fail "$(../whitespace fixtures/@complex -1,3 2>&1)"
  __fail "$(../whitespace fixtures/@complex -1,4 2>&1)"

  __fail "$(../whitespace fixtures/@complex 0,-1 2>&1)"
  __fail "$(../whitespace fixtures/@complex 0,0 2>&1)"
  __fail "$(../whitespace fixtures/@complex 0,1 2>&1)"
  __fail "$(../whitespace fixtures/@complex 0,2 2>&1)"
  __fail "$(../whitespace fixtures/@complex 0,3 2>&1)"
  __fail "$(../whitespace fixtures/@complex 0,4 2>&1)"

  __fail "$(../whitespace fixtures/@complex 1,-1 2>&1)"

  __fail "$(../whitespace fixtures/@complex 2,-1 2>&1)"
  __fail "$(../whitespace fixtures/@complex 2,0 2>&1)"
  __fail "$(../whitespace fixtures/@complex 2,1 2>&1)"

  __fail "$(../whitespace fixtures/@complex 3,-1 2>&1)"
  __fail "$(../whitespace fixtures/@complex 3,0 2>&1)"
  __fail "$(../whitespace fixtures/@complex 3,1 2>&1)"
  __fail "$(../whitespace fixtures/@complex 3,2 2>&1)"

  __fail "$(../whitespace fixtures/@complex 4,-1 2>&1)"
  __fail "$(../whitespace fixtures/@complex 4,0 2>&1)"
  __fail "$(../whitespace fixtures/@complex 4,1 2>&1)"
  __fail "$(../whitespace fixtures/@complex 4,2 2>&1)"
  __fail "$(../whitespace fixtures/@complex 4,3 2>&1)"

  __fail "$(../whitespace fixtures/@complex foo,bar 2>&1)"
  __fail "$(../whitespace fixtures/@complex 1,foo 2>&1)"
  __fail "$(../whitespace fixtures/@complex foo,1 2>&1)"
  __fail "$(../whitespace fixtures/@complex -1,foo 2>&1)"
  __fail "$(../whitespace fixtures/@complex foo,-1 2>&1)"

}

it_allows_custom_markers() {

  test "$(../whitespace fixtures/@complex -s 2>&1)" = 'foobar\s\t\r\n(\n)foo()bar(\n)baz(\t)(\t)foo(\r)()(\n)'
  test "$(../whitespace fixtures/@complex -s space 2>&1)" = 'foobar\s\t\r\n(\n)foo(space)bar(\n)baz(\t)(\t)foo(\r)(space)(\n)'

  test "$(../whitespace fixtures/@complex -t 2>&1)" = 'foobar\s\t\r\n(\n)foo(\s)bar(\n)baz()()foo(\r)(\s)(\n)'
  test "$(../whitespace fixtures/@complex -t tab 2>&1)" = 'foobar\s\t\r\n(\n)foo(\s)bar(\n)baz(tab)(tab)foo(\r)(\s)(\n)'

  test "$(../whitespace fixtures/@complex -r 2>&1)" = 'foobar\s\t\r\n(\n)foo(\s)bar(\n)baz(\t)(\t)foo()(\s)(\n)'
  test "$(../whitespace fixtures/@complex -r return 2>&1)" = 'foobar\s\t\r\n(\n)foo(\s)bar(\n)baz(\t)(\t)foo(return)(\s)(\n)'

  test "$(../whitespace fixtures/@complex -n 2>&1)" = 'foobar\s\t\r\n()foo(\s)bar()baz(\t)(\t)foo(\r)(\s)()'
  test "$(../whitespace fixtures/@complex -n newline 2>&1)" = 'foobar\s\t\r\n(newline)foo(\s)bar(newline)baz(\t)(\t)foo(\r)(\s)(newline)'

  test "$(../whitespace fixtures/@complex -s -t -r -n 2>&1)" = 'foobar\s\t\r\n()foo()bar()baz()()foo()()()'
  test "$(../whitespace fixtures/@complex -s space -t tab -r return -n newline 2>&1)" = 'foobar\s\t\r\n(newline)foo(space)bar(newline)baz(tab)(tab)foo(return)(space)(newline)'

}

it_allows_custom_marker_delimiters() {

  test "$(../whitespace fixtures/@complex -L 2>&1)" = 'foobar\s\t\r\n\n)foo\s)bar\n)baz\t)\t)foo\r)\s)\n)'
  test "$(../whitespace fixtures/@complex -L [ 2>&1)" = 'foobar\s\t\r\n[\n)foo[\s)bar[\n)baz[\t)[\t)foo[\r)[\s)[\n)'

  test "$(../whitespace fixtures/@complex -R 2>&1)" = 'foobar\s\t\r\n(\nfoo(\sbar(\nbaz(\t(\tfoo(\r(\s(\n'
  test "$(../whitespace fixtures/@complex -R ] 2>&1)" = 'foobar\s\t\r\n(\n]foo(\s]bar(\n]baz(\t](\t]foo(\r](\s](\n]'

  test "$(../whitespace fixtures/@complex -L -R 2>&1)" = 'foobar\s\t\r\n\nfoo\sbar\nbaz\t\tfoo\r\s\n'
  test "$(../whitespace fixtures/@complex -L [ -R 2>&1)" = 'foobar\s\t\r\n[\nfoo[\sbar[\nbaz[\t[\tfoo[\r[\s[\n'
  test "$(../whitespace fixtures/@complex -L -R ] 2>&1)" = 'foobar\s\t\r\n\n]foo\s]bar\n]baz\t]\t]foo\r]\s]\n]'
  test "$(../whitespace fixtures/@complex -L [ -R ] 2>&1)" = 'foobar\s\t\r\n[\n]foo[\s]bar[\n]baz[\t][\t]foo[\r][\s][\n]'

}
