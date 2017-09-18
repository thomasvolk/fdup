defmodule FDup.Group do
  def new() do
    Map.new
  end

  def update(data, [path|rest], level) when level > 0 do
    key = sub_path(path, level)
    data = Map.update(data, key, [path], &( Enum.uniq( [ path | &1 ] ) ))
    update(data, rest, level)
  end

  def update(data, [], _), do: data

  def paths(data), do: Map.keys(data) |> Enum.sort

  def files(data, path), do: Map.get(data, path, []) |> Enum.sort

  def count(data, path), do: length(files(data, path))

  def counts(data) do
    Enum.map(paths(data), fn p -> [p, count(data, p)] end)
  end

  def sub_path(path, level) when level > 0 do
    dir_path = Path.dirname(path)
    {parts, _} = Enum.split(Path.split(dir_path), level)
    case parts do
      [] -> dir_path
      _  -> Path.join(parts)
    end
  end
end
