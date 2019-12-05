defmodule TaktaWeb.Services.WhiteboardService do
  @moduledoc false

  alias Takta.Whiteboards
  alias Takta.Whiteboards.Whiteboard
  alias TaktaWeb.Whiteboards.WhiteboardMapper


  def delete(wid) do
    case Whiteboards.delete(wid) do
      {:ok, %Whiteboard{} = wb} -> {200, WhiteboardMapper.to_json_basic(wb)}
      {:error, :not_found} -> {404, %{error: :not_found}}
      {:error, details} -> {500, %{error: :server_error, details: details}}
    end
  end
end
