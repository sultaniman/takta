defmodule TaktaWeb.Uploaders.Local do
  @moduledoc false
  @behaviour TaktaWeb.Uploaders

  @impl true
  def upload(path, data) do
    ensure_directory(path)
    File.write!(path, data, [:raw, :binary])
  end

  defp ensure_directory(path) do
    unless File.exists?(path) do
      path
      |> Path.dirname()
      |> File.mkdir_p()
    end
  end
end
