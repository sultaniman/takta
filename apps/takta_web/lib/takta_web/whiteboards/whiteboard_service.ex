defmodule TaktaWeb.Whiteboards.WhiteboardService do
  @moduledoc """
  Whiteboard service carries business logic of handling
  certain operations and related responses.
  """
  alias Takta.Whiteboards
  alias Takta.Whiteboards.Whiteboard
  alias TaktaWeb.Base.StatusResponse
  alias TaktaWeb.Whiteboards.WhiteboardMapper


  def delete(wid) do
    case Whiteboards.delete(wid) do
      {:ok, %Whiteboard{} = wb} -> StatusResponse.ok(WhiteboardMapper.to_json_basic(wb))
      {:error, :not_found} -> StatusResponse.not_found()
      {:error, details} -> StatusResponse.server_error(details)
    end
  end
end
