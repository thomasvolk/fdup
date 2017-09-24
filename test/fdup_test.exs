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
    error_code = FDup.main(args, FDupTest.Queue.handler(queue))
    output = as_string(queue)
    %{output: output, error_code: error_code}
  end

  def as_string(queue), do: Enum.join(FDupTest.Queue.get(queue), "\n") <> "\n"

  setup do
    {:ok, queue} = start_supervised FDupTest.Queue
    %{path: "test_data", queue: queue, }
  end


  test "fdup usage", %{path: _, queue: queue} do
    FDup.usage(FDupTest.Queue.handler(queue))
    assert as_string(queue) == """
    FDup 0.3
    Copyright 2017 Thomas Volk
    usage: fdup --mode [unique|duplicate|group] [--level grouping_level] PATH
    """
  end

  test "fdup error", %{path: _, queue: queue} do
    assert fdup([], queue) == %{ output: """
    ERROR: missing path argument!
    FDup 0.3
    Copyright 2017 Thomas Volk
    usage: fdup --mode [unique|duplicate|group] [--level grouping_level] PATH
    """, error_code: 1 }
  end

  test "fdup default", %{path: path, queue: queue} do
    assert fdup([path], queue) == %{ output: """
    test_data/1/x.txt
    test_data/2/x.txt
    test_data/x.txt
    """, error_code: 0 }
  end

  test "fdup unique", %{path: path, queue: queue} do
    assert fdup(["--mode", "unique", path], queue) == %{ output: """
    test_data/1/foo.txt
    test_data/README.md
    """, error_code: 0 }
  end

  test "fdup duplicate", %{path: path, queue: queue} do
    assert fdup(["--mode", "duplicate", path], queue) == %{ output: """
    test_data/1/x.txt
    test_data/2/x.txt
    test_data/x.txt
    """, error_code: 0 }
  end

  test "fdup group", %{path: path, queue: queue} do
    assert fdup(["--mode", "group", "--level", "1", path], queue) == %{ output: """
    u=2 d=3 : test_data
    """, error_code: 0 }
  end
end
