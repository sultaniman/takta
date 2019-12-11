defmodule TaktaWeb.Services.ServiceHelpers do
  @moduledoc false
  alias TaktaWeb.Base.StatusResponse

  def call_if(_action, nil, _has_permission), do: StatusResponse.not_found()
  def call_if(_action, _entity, false), do: StatusResponse.permission_denied()
  def call_if(action, entity, true) do
    action.(entity)
  end
end
