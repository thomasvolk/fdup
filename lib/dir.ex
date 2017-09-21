defmodule FDup.Directory do

  def traverse([ path | rest ], file_consumer, result) do
    stat = File.stat!(path)
    { dirs, new_result } = case stat.type do
      :directory ->
        { list_dir(path) ++ rest, result }
      :regular ->
        { rest, file_consumer.(result, path) }
      _ ->
        { rest, result }
    end
    traverse(dirs, file_consumer, new_result)
  end

  def traverse([], _, result), do: result

  defp list_dir(path) do
    :file.list_dir(path) |> ignore_error |> Enum.map(fn(rel) -> Path.join(path, rel) end)
  end

  defp ignore_error({:ok, list}), do: list

  defp ignore_error({:error, _}), do: []

end
