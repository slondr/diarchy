defmodule Diarchy.MixProject do
  use Mix.Project

  def project do
    [
      app: :diarchy,
      version: "0.2.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Diarchy.Application, []}
    ]
  end

  defp deps, do: []
end
