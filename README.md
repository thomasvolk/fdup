# FDup

FDup is an command line application to find duplicate files.

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
      [{:fdup, "~> 0.1.0"}]
    end
    ```

  2. Ensure `fdup` is started before your application:

    ```elixir
    def application do
      [applications: [:fdup]]
    end
    ```
