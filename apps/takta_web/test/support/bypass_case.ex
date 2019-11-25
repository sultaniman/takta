defmodule TaktaWeb.BypassCase do
  @moduledoc false
  def start_bypass(_) do
    bypass = Bypass.open
    [bypass: bypass]
  end

  def exaws_config_for_bypass(bypass) do
    ExAws.Config.new(:s3, [
      access_key_id: "AKIAIOSFODNN7EXAMPLE",
      secret_access_key: "wJalrXUtnFEMI/YYMMENG/bPxSpiCYEXAMPLEKEY",
      host: "localhost",
      port: bypass.port,
      scheme: "http://",
      region: "eu-central-1",
    ])
  end
end
