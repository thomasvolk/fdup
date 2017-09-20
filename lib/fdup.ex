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
  def main(args) do
    args |> parse_args |> process(&IO.puts/1)
  end
  alias FDup.Directory, as: Directory
  alias FDup.DB, as: DB
  alias FDup.Group, as: Group

  def usage() do
    IO.puts("FDup 0.1")
    IO.puts "missing path argument!"
    IO.puts "usage: fdup --mode [unique|duplicate] [--group level] PATH"
    System.halt(1)
  end

  def process(%{options: _, args: []}, _), do: usage()

  def process(%{options: [], args: [path]}, print) do
    process([], "duplicate", path, print)
  end

  def process(%{options: [{:mode, mode}|options], args: [path]}, print) do
    process(options, mode, path, print)
  end

  def process(options, mode, path, print) do
    Logger.debug "create index path=#{path}"
    db = Directory.traverse([path], &DB.update_from_file/2, DB.new)
    Logger.debug "generate report mode=#{mode}"
    report(options, String.to_atom(mode), db, print)
    Logger.debug "done"
  end

  def report([{:group, level}|_], :unique, db, print) do
    %{duplicates: _, uniques: uniques} = DB.groups(db, elem(Integer.parse(level), 0))
    Enum.each(Group.counts(uniques), fn [p, c] -> print.("#{c} #{p}") end)
  end

  def report([], :unique, db, print) do
    Enum.each(DB.unique_entries(db), print)
  end

  def report([{:group, level}], :duplicate, db, print) do
    %{duplicates: duplicates, uniques: _} = DB.groups(db, elem(Integer.parse(level), 0))
    Enum.each(Group.counts(duplicates), fn [p, c] -> print.("#{c} #{p}") end)
  end

  def report([], :duplicate, db, print) do
    Enum.each(DB.duplicate_entries(db), print)
  end

  defp parse_args(args) do
    {options, args, _} = OptionParser.parse(args,
      switches: [src: :string]
    )
    %{options: options, args: args}
  end
end
