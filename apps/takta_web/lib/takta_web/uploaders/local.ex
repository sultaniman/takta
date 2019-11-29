defmodule TaktaWeb.Uploaders.Local do
  @moduledoc false
  @behaviour TaktaWeb.Uploaders

  @impl true
  def upload(path, data) do
    UUID.uuid4()
    IO.inspect(path)
    IO.inspect(data)
    {:ok, path}
  end
end
