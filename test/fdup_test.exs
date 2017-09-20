defmodule FDupTest do
  use ExUnit.Case
  doctest FDup

  test "fdup" do
    path = "test_data"
    FDup.process(%{options: [{:mode, "unique"}], args: [path]}, fn s -> s end)
  end
end
