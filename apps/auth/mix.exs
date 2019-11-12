defmodule Auth.MixProject do
  use Mix.Project

  @vsn  "0.1.0"

  @deps [
    {:argon2_elixir, "~> 2.0"},
    {:ecto_sql, "~> 3.1"},
    {:postgrex, ">= 0.0.0"},
    {:guardian, "~> 2.0"},
    {:plug, "~> 1.8.3"},
    {:uuid, "~> 1.1"},
    {:poison, "~> 4.0"}
  ]

  @aliases [
    "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
    "ecto.reset": ["ecto.drop", "ecto.setup"],
    test: ["ecto.create --quiet", "ecto.migrate", "test"]
  ]

  def project do
    [
      app: :auth,
      version: @vsn,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: @deps,
      aliases: @aliases
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Auth.Application, []}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib", "test/support/data"]
end
