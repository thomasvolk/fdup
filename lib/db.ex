defmodule FDup.DB do
  alias FDup.Group, as: Group
  alias FDup.Digest, as: Digest
  def new(), do: Map.new

  def update(data, key, entry) do
    Map.update(data, key, [entry], &( [ entry | &1 ] |> Enum.uniq() |> Enum.sort() ))
  end

  def update_from_file(data, path) do
    case File.read(path) do
      {:ok, content} ->
        key = Digest.hash(path, content)
        update(data, key, path)
      _ -> data
    end
  end

  def key_count(data), do: length(Map.keys(data))

  def entry_count(data), do: length(List.flatten(Map.values(data)))

  def unique_entries(data), do: Map.values(data) |> Enum.filter(&(length(&1) == 1)) |> List.flatten() |> Enum.sort()

  def duplicate_entries(data), do: Map.values(data) |> Enum.filter(&(length(&1) > 1)) |> List.flatten()

  def grouping(data, level) when level > 0 do
    grouping = Group.update_uniques(Group.new, unique_entries(data), level)
    Group.update_duplicates(grouping, duplicate_entries(data), level)
  end
end
