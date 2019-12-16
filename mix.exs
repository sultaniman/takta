defmodule Takta.Umbrella.MixProject do
  use Mix.Project

  @deps []
  @aliases [
    "ecto.recreate": ["ecto.drop", "ecto.create", "ecto.migrate"],
  ]

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: @deps,
      aliases: @aliases
    ]
  end
end
