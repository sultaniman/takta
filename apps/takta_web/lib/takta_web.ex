defmodule TaktaWeb do
  @moduledoc false

  def controller do
    quote do
      use Phoenix.Controller, namespace: TaktaWeb
      import Plug.Conn
      import TaktaWeb.Gettext
      alias TaktaWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/takta_web/templates",
        pattern: "**/*",
        namespace: TaktaWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      import TaktaWeb.ErrorHelpers
      import TaktaWeb.Gettext
      alias TaktaWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import TaktaWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
