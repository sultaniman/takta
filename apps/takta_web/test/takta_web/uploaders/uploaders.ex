defmodule TaktaWeb.Uploaders do
  @moduledoc false
  @callback upload(String.t, binary()) :: String.t | {:error, String.t}
end
