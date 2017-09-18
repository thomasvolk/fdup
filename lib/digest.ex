defmodule FDup.Digest do
  def hash(path, data) do
    filename = Path.basename(path)
    hash("#{filename}#{data}")
  end
  def hash(data) do
    :crypto.hash(:sha256, data) |> Base.encode16
  end
end
