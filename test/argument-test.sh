#!/usr/bin/env roundup

describe "whitespace: arguments test"

alias whitespace="../whitespace"

__fail() {

  # check that $1 starts with "whitespace: "
  case $1 in
    "whitespace: "* ) true;;
    * ) false;;
  esac

}

it_allows_the_double_dash_construct() {

  test "$(whitespace -- fixtures/@complex)" = 'foobar\s\t\r\n(\n)foo(\s)bar(\n)baz(\t)(\t)foo(\r)(\s)'
  test "$(whitespace -- fixtures/@complex 3)" = 'baz(\t)(\t)foo(\r)(\s)'

  test "$(whitespace -L -- fixtures/@complex)" = 'foobar\s\t\r\n\n)foo\s)bar\n)baz\t)\t)foo\r)\s)'
  test "$(whitespace -L -- fixtures/@complex 3)" = 'baz\t)\t)foo\r)\s)'

  test "$(whitespace -L [ -- fixtures/@complex)" = 'foobar\s\t\r\n[\n)foo[\s)bar[\n)baz[\t)[\t)foo[\r)[\s)'

  test "$(whitespace -L -R -- fixtures/@complex)" = 'foobar\s\t\r\n\nfoo\sbar\nbaz\t\tfoo\r\s'

  test "$(whitespace fixtures/@complex --)" = 'foobar\s\t\r\n(\n)foo(\s)bar(\n)baz(\t)(\t)foo(\r)(\s)'
  test "$(whitespace fixtures/@complex -- 3)" = 'baz(\t)(\t)foo(\r)(\s)'

}

it_handles_arguments_correctly() {

  # 1 argument
  test "$(whitespace fixtures/@complex 2>&1)" = 'foobar\s\t\r\n(\n)foo(\s)bar(\n)baz(\t)(\t)foo(\r)(\s)'
  __fail "$(whitespace 3 2>&1)"
  __fail "$(whitespace -s space 2>&1)"
  __fail "$(whitespace -L 2>&1)"

  # 2 arguments
  test "$(whitespace fixtures/@complex -s space 2>&1)" = 'foobar\s\t\r\n(\n)foo(space)bar(\n)baz(\t)(\t)foo(\r)(space)'
  test "$(whitespace fixtures/@complex 3 2>&1)" = 'baz(\t)(\t)foo(\r)(\s)'
  test "$(whitespace fixtures/@complex -L 2>&1)" = 'foobar\s\t\r\n\n)foo\s)bar\n)baz\t)\t)foo\r)\s)'
  __fail "$(whitespace 3 fixtures/@complex 2>&1)"
  __fail "$(whitespace 3 -s space 2>&1)"
  __fail "$(whitespace 3 -L 2>&1)"
  test "$(whitespace -L '' fixtures/@complex 2>&1)" = 'foobar\s\t\r\n\n)foo\s)bar\n)baz\t)\t)foo\r)\s)'
  __fail "$(whitespace -L '' 3 2>&1)"
  __fail "$(whitespace -L '' -s space 2>&1)"
  test "$(whitespace -s space fixtures/@complex 2>&1)" = 'foobar\s\t\r\n(\n)foo(space)bar(\n)baz(\t)(\t)foo(\r)(space)'
  __fail "$(whitespace -s space 3 2>&1)"
  __fail "$(whitespace -s space -L 2>&1)"

  # 3 arguments
  test "$(whitespace fixtures/@complex 3 -s space 2>&1)" = 'baz(\t)(\t)foo(\r)(space)'
  test "$(whitespace fixtures/@complex 3 -L 2>&1)" = 'baz\t)\t)foo\r)\s)'
  test "$(whitespace fixtures/@complex -s space 3 2>&1)" = 'baz(\t)(\t)foo(\r)(space)'
  test "$(whitespace fixtures/@complex -s space -L 2>&1)" = 'foobar\s\t\r\n\n)foospace)bar\n)baz\t)\t)foo\r)space)'
  test "$(whitespace fixtures/@complex -L '' 3 2>&1)" = 'baz\t)\t)foo\r)\s)'
  test "$(whitespace fixtures/@complex -L -s space 2>&1)" = 'foobar\s\t\r\n\n)foospace)bar\n)baz\t)\t)foo\r)space)'
  __fail "$(whitespace 3 fixtures/@complex -s space 2>&1)"
  __fail "$(whitespace 3 fixtures/@complex -L 2>&1)"
  __fail "$(whitespace 3 -s space fixtures/@complex 2>&1)"
  __fail "$(whitespace 3 -s space -L 2>&1)"
  __fail "$(whitespace 3 -L '' fixtures/@complex 2>&1)"
  __fail "$(whitespace 3 -L -s space 2>&1)"
  test "$(whitespace -L '' fixtures/@complex 3 2>&1)" = 'baz\t)\t)foo\r)\s)'
  test "$(whitespace -L '' fixtures/@complex -s space 2>&1)" = 'foobar\s\t\r\n\n)foospace)bar\n)baz\t)\t)foo\r)space)'
  __fail "$(whitespace -L '' 3 fixtures/@complex 2>&1)"
  __fail "$(whitespace -L '' 3 -s space 2>&1)"
  __fail "$(whitespace -L '' -s space 3 2>&1)"
  test "$(whitespace -L '' -s space fixtures/@complex 2>&1)" = 'foobar\s\t\r\n\n)foospace)bar\n)baz\t)\t)foo\r)space)'
  test "$(whitespace -s space fixtures/@complex 3 2>&1)" = 'baz(\t)(\t)foo(\r)(space)'
  test "$(whitespace -s space fixtures/@complex -L 2>&1)" = 'foobar\s\t\r\n\n)foospace)bar\n)baz\t)\t)foo\r)space)'
  __fail "$(whitespace -s space 3 fixtures/@complex 2>&1)"
  __fail "$(whitespace -s space 3 -L 2>&1)"
  test "$(whitespace -s space -L '' fixtures/@complex 2>&1)" = 'foobar\s\t\r\n\n)foospace)bar\n)baz\t)\t)foo\r)space)'
  __fail "$(whitespace -s space -L '' 3 2>&1)"

  # 4 arguments
  local expected='baz\t)\t)foo\r)space)'
  test "$(whitespace fixtures/@complex 3 -s space -L 2>&1)" = "$expected"
  test "$(whitespace fixtures/@complex 3 -L -s space 2>&1)" = "$expected"
  test "$(whitespace fixtures/@complex -s space 3 -L 2>&1)" = "$expected"
  test "$(whitespace fixtures/@complex -s space -L '' 3 2>&1)" = "$expected"
  test "$(whitespace fixtures/@complex -L '' 3 -s space 2>&1)" = "$expected"
  test "$(whitespace fixtures/@complex -L -s space 3 2>&1)" = "$expected"
  __fail "$(whitespace 3 fixtures/@complex -s space -L 2>&1)"
  __fail "$(whitespace 3 fixtures/@complex -L -s space 2>&1)"
  __fail "$(whitespace 3 -s space fixtures/@complex -L 2>&1)"
  __fail "$(whitespace 3 -s space -L '' fixtures/@complex 2>&1)"
  __fail "$(whitespace 3 -L '' fixtures/@complex -s space 2>&1)"
  __fail "$(whitespace 3 -L -s space fixtures/@complex 2>&1)"
  test "$(whitespace -L '' fixtures/@complex 3 -s space 2>&1)" = "$expected"
  test "$(whitespace -L '' fixtures/@complex -s space 3 2>&1)" = "$expected"
  __fail "$(whitespace -L '' 3 fixtures/@complex -s space 2>&1)"
  __fail "$(whitespace -L '' 3 -s space fixtures/@complex 2>&1)"
  __fail "$(whitespace -L '' -s space 3 fixtures/@complex 2>&1)"
  test "$(whitespace -L '' -s space fixtures/@complex 3 2>&1)" = "$expected"
  test "$(whitespace -s space fixtures/@complex 3 -L 2>&1)" = "$expected"
  test "$(whitespace -s space fixtures/@complex -L '' 3 2>&1)" = "$expected"
  __fail "$(whitespace -s space 3 fixtures/@complex -L 2>&1)"
  __fail "$(whitespace -s space 3 -L '' fixtures/@complex 2>&1)"
  __fail "$(whitespace -s space 3 -L '' fixtures/@complex 2>&1)"
  test "$(whitespace -s space -L '' fixtures/@complex 3 2>&1)" = 'baz\t)\t)foo\r)space)'
  __fail "$(whitespace -s space -L '' 3 fixtures/@complex 2>&1)"

}
