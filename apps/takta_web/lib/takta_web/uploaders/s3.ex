defmodule TaktaWeb.Uploaders.S3 do
  @moduledoc false
  @behaviour TaktaWeb.Uploaders

  @bucket Application.get_env(:takta_web, :upload_to)

  @impl true
  def upload(filename, data) do
    with {:ok, path} <- Briefly.create() do
      File.write!(path, data)

      ExAws.S3.Upload.stream_file(path)
      |> ExAws.S3.upload(@bucket, filename)
      |> ExAws.request!()
    end
  end

  @impl true
  def name_only?, do: true
end
