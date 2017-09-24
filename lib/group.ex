defmodule FDup.Group do
  def new(), do: Map.new

  def update_duplicates(data, duplicates, level), do: update(data, duplicates, level, :duplicate)

  def update_uniques(data, uniques, level), do: update(data, uniques, level, :unique)

  defp update(data, [path|rest], level, tag) when level > 0 do
    key = sub_path(path, level)
    data = Map.update(data, key, %{tag => 1}, &( increase(tag, &1) ))
    update(data, rest, level, tag)
  end

  defp update(data, [], _, _), do: data

  defp increase(tag, entry), do: Map.update(entry, tag, 1, &( &1 + 1 ))

  def sub_path(path, level) when level > 0 do
    dir_path = Path.dirname(path)
    {parts, _} = Enum.split(Path.split(dir_path), level)
    case parts do
      [] -> dir_path
      _  -> Path.join(parts)
    end
  end
end
