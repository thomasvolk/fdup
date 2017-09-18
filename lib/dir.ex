defmodule FDup.Directory do

  def traverse(path), do: traverse(path, fn r, p -> [p|r] end, [])

  def traverse([ path | rest ], handler, result) do
    stat = File.stat!(path)
    case stat.type do
      :directory ->
        traverse(list_dir(path) ++ rest, handler, result)
      :regular ->
        traverse(rest, handler, handler.(result, path))
      _ ->
        traverse(rest, handler, result)
    end
  end

  def traverse([], _, result), do: result

  defp list_dir(path) do
    :file.list_dir(path) |> ignore_error |> Enum.map(fn(rel) -> Path.join(path, rel) end)
  end

  defp ignore_error({:ok, list}), do: list

  defp ignore_error({:error, _}), do: []

end
