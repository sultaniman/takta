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
    {:poison, "~> 4.0"},
    {:plug_cowboy, "~> 2.0"},

    # Authentication deps
    {:ueberauth_google, "~> 0.8"},
    {:ueberauth_github, "~> 0.7"},

    # AWS
    {:ex_aws, "~> 2.1"},
    {:ex_aws_s3, "~> 2.0"},
    {:hackney, "~> 1.15"},
    {:sweet_xml, "~> 0.6"},
    {:configparser_ex, "~> 4.0"},
    {:ex_aws_sts, "~> 2.0"},

    # To handle temporary files
    {:briefly, github: "CargoSense/briefly"},

    # Domain apps
    {:auth, in_umbrella: true},
    {:takta, in_umbrella: true},

    # Test deps
    {:bypass, "~> 1.0", only: :test},
    {:html_sanitize_ex, "~> 1.3.0-rc3", only: :test},
    {:hammox, "~> 0.2.0", only: :test}
  ]

  @aliases [
    test: ["ecto.create --quiet", "ecto.migrate", "test"]
  ]

  @apps [
    mod: {TaktaWeb.Application, []},
    extra_applications: [
      :logger,
      :runtime_tools,
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
  defp elixirc_paths(_), do: ["lib", "test/support/data"]
end
