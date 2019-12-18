defmodule Mailer.MixProject do
  use Mix.Project

  @vsn "0.1.0"

  @deps [
    {:bamboo_smtp, "~> 2.1.0"}
  ]

  def project do
    [
      app: :mailer,
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
      mod: {Mailer.Application, []}
    ]
  end
end
