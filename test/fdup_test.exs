defmodule FDupTest.Queue do
  use Agent

  def start_link(_opts), do: Agent.start_link(fn -> [] end)

  def get(queue), do: Agent.get(queue, fn q -> q end)

  def add(queue, value), do: Agent.update(queue, fn q -> q ++ [value] end)
end

defmodule FDupTest do
  use ExUnit.Case
  doctest FDup

  def fdup(args, queue) do
    FDup.process(args, fn s -> FDupTest.Queue.add(queue, s) end)
    Enum.join(FDupTest.Queue.get(queue), "\n") <> "\n"
  end

  setup do
    {:ok, queue} = start_supervised FDupTest.Queue
    %{path: "test_data", queue: queue, }
  end

  test "fdup unique", %{path: path, queue: queue} do
    assert fdup(%{options: [{:mode, "unique"}], args: [path]}, queue) == """
    test_data/1/foo.txt
    test_data/README.md
    """
  end

  test "fdup duplicate", %{path: path, queue: queue} do
    assert fdup(%{options: [{:mode, "duplicate"}], args: [path]}, queue) == """
    test_data/1/x.txt
    test_data/2/x.txt
    test_data/x.txt
    """
  end

  test "fdup unique group", %{path: path, queue: queue} do
    assert fdup(%{options: [{:mode, "unique"}, {:group, "1"}], args: [path]}, queue) == """
    2 test_data
    """
  end

  test "fdup duplicate group", %{path: path, queue: queue} do
    assert fdup(%{options: [{:mode, "duplicate"}, {:group, "1"}], args: [path]}, queue) == """
    3 test_data
    """
  end
end
