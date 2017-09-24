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
    group = update_duplicates(group, [], 2)
    group = update_uniques(group, [], 2)
    assert group == %{}

    group = update_uniques(group, ["foo.txt", "pic/33.jpg", "pic/2017/7.jpg", "pic/2008/2.jpg", "pic/test/1.jpg"], 2)
    assert group == %{"." => %{unique: 1}, "pic" => %{unique: 1}, "pic/2008" => %{unique: 1}, "pic/2017" => %{unique: 1}, "pic/test" => %{unique: 1} }

    group = update_duplicates(group, ["xxx.txt", "yyy.txt", "pic/xxx.txt", "pic/2017/xxx.txt", "pic/yyy.txt"], 2)
    assert group == %{"." => %{unique: 1, duplicate: 2}, "pic" => %{unique: 1, duplicate: 2}, "pic/2008" => %{unique: 1}, "pic/2017" => %{unique: 1, duplicate: 1}, "pic/test" => %{unique: 1} }

  end
end
