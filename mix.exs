defmodule FDup.Mixfile do
  use Mix.Project

  def project do
    [app: :fdup,
     version: "0.1.0",
     elixir: "~> 1.5",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: [main_module: FDup],
     test_coverage:     [tool: ExCoveralls],
     preferred_cli_env: [coveralls: :test],
     deps: deps()]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:excoveralls, "~> 0.7",   only: :test}
    ]
  end
end
