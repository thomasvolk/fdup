defmodule GroupTest do
  use ExUnit.Case
  doctest FDup.Group
  import FDup.Group

  test "sub_path" do
    assert sub_path("", 1) == "."
    assert sub_path("", 10) == "."
    assert sub_path("foo.txt", 10) == "."

    assert sub_path("/", 1) == "/"
    assert sub_path("/", 2) == "/"
    assert sub_path("/test.2.3.png", 2) == "/"

    assert sub_path("/1/2/3/x.txt", 1) == "/"
    assert sub_path("/1/2/3/x.txt", 2) == "/1"

    assert sub_path("1/2/3/foo.txt", 1) == "1"
    assert sub_path("1/2/3/foo.txt", 2) == "1/2"
    assert sub_path("1/2/3/foo.txt", 3) == "1/2/3"
    assert sub_path("1/2/3/foo.txt", 4) == "1/2/3"
  end

  test "group" do
    group = new()
    group = update(group, [], 2)
    assert paths(group) == []

    group = update(group, ["foo.txt", "pic/33.jpg", "pic/2017/7.jpg", "pic/2008/2.jpg", "pic/test/1.jpg"], 2)
    assert paths(group) == [".", "pic", "pic/2008", "pic/2017", "pic/test"]
  end
end
