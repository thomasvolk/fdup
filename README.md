# FDup

FDup is an command line application to find duplicate files.

[![Build Status](https://travis-ci.org/thomasvolk/fdup.svg?branch=master)](https://travis-ci.org/thomasvolk/fdup)
[![Coverage Status](https://coveralls.io/repos/github/thomasvolk/fdup/badge.svg?branch=master)](https://coveralls.io/github/thomasvolk/fdup?branch=master)

## Build

To build fdup you need to install erlang and elixir:

    $ sudo apt-get install elixir

run mix to build the fdup executable:

    $ mix escript.build

## Quick Start

usage:

    fdup --mode [unique|duplicate] [--group level] PATH

Let's find all duplicates:

    $ fdup --mode duplicate test_data
    test_data/1/x.txt
    test_data/2/x.txt
    test_data/x.txt

Let's group them:

    $ fdup --mode duplicate --group 1 test_data/
    3 test_data

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `fdup` to your list of dependencies in `mix.exs`:

```elixir
    def deps do
      [{:fdup, git: "https://github.com/thomasvolk/fdup.git", tag: "0.2"}]
    end
```

  2. Ensure `fdup` is started before your application:

```elixir
    def application do
      [applications: [:fdup]]
    end
```
