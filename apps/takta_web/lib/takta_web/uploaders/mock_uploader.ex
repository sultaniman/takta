defmodule TaktaWeb.Uploaders.MockUploader do
  @moduledoc false
  @behaviour TaktaWeb.Uploaders

  @impl true
  def upload(path, _data), do: {:ok, path}
end
