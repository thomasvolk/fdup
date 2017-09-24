defmodule FDup.Group do
  def new(), do: Map.new

  def new(list, level), do: update(Map.new, list, level)

  def update(data, [path|rest], level) when level > 0 do
    key = sub_path(path, level)
    data = Map.update(data, key, [path], &( Enum.uniq( [ path | &1 ] ) ))
    update(data, rest, level)
  end

  def update(data, [], _), do: data

  def paths(data), do: Map.keys(data) |> Enum.sort

  def merge(label, data), do: merge(Map.new, label, data)

  def merge(merged_map, label, data) do
    to_merge = data |> Map.to_list |> Enum.map(fn {k,v} -> {k, {label, v}} end) |> Map.new
    Map.merge(merged_map, to_merge, fn _k, v1, v2 -> Map.new([v1, v2]) end)
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
