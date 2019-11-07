defmodule Takta.MixProject do
  use Mix.Project

  @vsn "0.1.0"

  @deps [
    {:ecto_sql, "~> 3.1"},
    {:postgrex, ">= 0.0.0"},
    {:jason, "~> 1.0"},
    {:uuid, "~> 1.1"},
    {:timex, "~> 3.5"},
    {:auth, in_umbrella: true}
  ]

  @aliases [
    "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
    "ecto.reset": ["ecto.drop", "ecto.setup"],
    test: ["ecto.drop", "ecto.create --quiet", "ecto.migrate", "test"]
  ]

  def project do
    [
      app: :takta,
      version: @vsn,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: @aliases,
      deps: @deps
    ]
  end

  def application do
    [
      mod: {Takta.Application, []},
      extra_applications: [:logger, :runtime_tools, :auth, :timex]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib", "test/support/data"]
end
