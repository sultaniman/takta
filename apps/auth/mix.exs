defmodule Auth.MixProject do
  use Mix.Project

  @vsn  "0.1.0"

  @deps [
    {:argon2_elixir, "~> 2.0"},
    {:ecto_sql, "~> 3.1"},
    {:postgrex, ">= 0.0.0"}
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
      start_permanent: Mix.env() == :prod,
      deps: @deps
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Auth.Application, []}
    ]
  end
end
