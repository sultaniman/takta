defmodule TaktaWeb.Uploaders.S3 do
  @moduledoc false
  @behaviour TaktaWeb.Uploaders

  @upload_to Application.get_env(:takta_web, :upload_to)

  @impl true
  def upload(filename, data) do
    @upload_to
    |> ExAws.S3.put_object(filename, data)
    |> ExAws.request!()
  end

  @impl true
  def name_only?, do: true
end
