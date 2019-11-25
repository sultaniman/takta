defmodule TaktaWeb.MixProject do
  use Mix.Project

  @vsn "0.1.0"

  @deps [
    {:phoenix, "~> 1.4.10"},
    {:phoenix_pubsub, "~> 1.1"},
    {:phoenix_ecto, "~> 4.0"},
    {:phoenix_html, "~> 2.13.3"},
    {:gettext, "~> 0.11"},
    {:jason, "~> 1.0"},
    {:plug_cowboy, "~> 2.0"},
    {:ueberauth_google, "~> 0.8"},
    {:ueberauth_github, "~> 0.7"},
    {:poison, "~> 4.0"},
    {:bypass, "~> 1.0"},
    {:ex_aws, "~> 2.1"},
    {:ex_aws_s3, "~> 2.0"},
    {:auth, in_umbrella: true},
    {:takta, in_umbrella: true},
    {:storage, in_umbrella: true}
  ]

  @aliases [
    test: ["ecto.create --quiet", "ecto.migrate", "test"]
  ]

  @apps [
    mod: {TaktaWeb.Application, []},
    extra_applications: [
      :logger,
      :runtime_tools,
      :storage,
      :auth,
      :ueberauth_google,
      :ueberauth_github
    ]
  ]

  def project do
    [
      app: :takta_web,
      version: @vsn,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: @aliases,
      deps: @deps
    ]
  end

  def application, do: @apps

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
