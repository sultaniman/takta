defmodule TaktaWeb.Uploaders.MockUploader do
  @moduledoc """
  Uploader which does nothing and only serves
  testing purposes.
  """
  @behaviour TaktaWeb.Uploaders

  @impl true
  def upload(path, _data), do: {:ok, path}

  @impl true
  def name_only?, do: false
end
