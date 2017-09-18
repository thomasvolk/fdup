defmodule FDup.DBTest do
  use ExUnit.Case
  doctest FDup.DB
  import FDup.DB

  test "update entries" do
    data = new()
    assert key_count(data) == 0
    assert entry_count(data) == 0

    data = data |> update("1", "/tmp/test.txt")
                |> update("1", "/tmp/test.txt")
                |> update("1", "/tmp/test.txt")
    assert unique_entries(data) == ["/tmp/test.txt"]

    data = data |> update("1", "/tmp/1/test.txt")
                |> update("1", "/tmp/2/test.txt")
    assert key_count(data) == 1
    assert entry_count(data) == 3
    assert unique_entries(data) == []

    data = update(data, "2", "/tmp/foo.txt")
    assert key_count(data) == 2
    assert entry_count(data) == 4
    assert unique_entries(data) == ["/tmp/foo.txt"]
    assert duplicate_entries(data) == ["/tmp/1/test.txt", "/tmp/2/test.txt", "/tmp/test.txt"]
  end
end
