defmodule TaktaWeb.Base.StatusErrors do
  def __using__(_) do
    quote do
      @auth_required {401, %{error: :auth_required}}
      @not_found {404, %{error: :not_found}}
      @server_error {500, %{error: :server_error}}
    end
  end
end
