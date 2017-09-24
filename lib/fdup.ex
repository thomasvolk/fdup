require Logger

defmodule FDup do
  @doc """
  Copyright 2017 Thomas Volk

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
  """
  alias FDup.Directory, as: Directory
  alias FDup.DB, as: DB
  alias FDup.Group, as: Group

  def main(args), do: System.halt(main(args, &IO.puts/1))

  def main(args, output) do
    result = args |> parse_args |> process(output)
    case result do
      { :error, msg } ->
         output.("ERROR: " <> msg)
         usage(output)
         1
      _ -> 0
    end
  end

  def usage(output) do
    output.("FDup 0.2")
    output.("Copyright 2017 Thomas Volk")
    output.("usage: fdup --mode [unique|duplicate] [--group level] PATH")
  end

  def process(%{options: _, args: []}, _) do
    {:error, "missing path argument!"}
  end

  def process(%{options: [], args: [path]}, output) do
    process([], "duplicate", path, output)
  end

  def process(%{options: [{:mode, mode}|options], args: [path]}, output) do
    process(options, mode, path, output)
  end

  def process(options, mode, path, output) do
    Logger.debug "create index path=#{path}"
    db = Directory.traverse([path], &DB.update_from_file/2, DB.new)
    Logger.debug "generate report mode=#{mode}"
    report(options, String.to_atom(mode), db, output)
    Logger.debug "done"
    {:ok, "done"}
  end

  def report([{:group, level}|_], :unique, db, output) do
    %{duplicates: _, uniques: uniques} = DB.groups(db, elem(Integer.parse(level), 0))
    Enum.each(Group.counts(uniques), fn [p, c] -> output.("#{c} #{p}") end)
  end

  def report([], :unique, db, output) do
    Enum.each(DB.unique_entries(db), output)
  end

  def report([{:group, level}], :duplicate, db, output) do
    %{duplicates: duplicates, uniques: _} = DB.groups(db, elem(Integer.parse(level), 0))
    Enum.each(Group.counts(duplicates), fn [p, c] -> output.("#{c} #{p}") end)
  end

  def report([], :duplicate, db, output) do
    Enum.each(DB.duplicate_entries(db), output)
  end

  defp parse_args(args) do
    {options, args, _} = OptionParser.parse(args,
      switches: [src: :string]
    )
    %{options: options, args: args}
  end
end
