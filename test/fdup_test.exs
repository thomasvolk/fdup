defmodule FDupTest.Queue do
  use Agent

  def start_link(_opts), do: Agent.start_link(fn -> [] end)

  def get(queue), do: Agent.get(queue, fn q -> q end)

  def add(queue, value), do: Agent.update(queue, fn q -> q ++ [value] end)

  def handler(queue), do: fn s -> FDupTest.Queue.add(queue, s) end
end

defmodule FDupTest do
  use ExUnit.Case
  doctest FDup

  def fdup(args, queue) do
    FDup.main(args, FDupTest.Queue.handler(queue))
    as_string(queue)
  end

  def as_string(queue), do: Enum.join(FDupTest.Queue.get(queue), "\n") <> "\n"

  setup do
    {:ok, queue} = start_supervised FDupTest.Queue
    %{path: "test_data", queue: queue, }
  end


  test "fdup usage", %{path: _, queue: queue} do
    FDup.usage(FDupTest.Queue.handler(queue))
    assert as_string(queue) == """
    FDup 0.1
    usage: fdup --mode [unique|duplicate] [--group level] PATH
    """
  end

  test "fdup default", %{path: path, queue: queue} do
    assert fdup([path], queue) == """
    test_data/1/x.txt
    test_data/2/x.txt
    test_data/x.txt
    """
  end

  test "fdup unique", %{path: path, queue: queue} do
    assert fdup(["--mode", "unique", path], queue) == """
    test_data/1/foo.txt
    test_data/README.md
    """
  end

  test "fdup duplicate", %{path: path, queue: queue} do
    assert fdup(["--mode", "duplicate", path], queue) == """
    test_data/1/x.txt
    test_data/2/x.txt
    test_data/x.txt
    """
  end

  test "fdup unique group", %{path: path, queue: queue} do
    assert fdup(["--mode", "unique", "--group", "1", path], queue) == """
    2 test_data
    """
  end

  test "fdup duplicate group", %{path: path, queue: queue} do
    assert fdup(["--mode", "duplicate", "--group", "1", path], queue) == """
    3 test_data
    """
  end
end
