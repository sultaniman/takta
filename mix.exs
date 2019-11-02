defmodule Takta.Umbrella.MixProject do
  use Mix.Project

  @deps []

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: @deps
    ]
  end
end
