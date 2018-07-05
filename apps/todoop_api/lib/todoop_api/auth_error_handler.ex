defmodule TodoopApi.AuthErrorHandler do
  import Plug.Conn

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> Phoenix.Controller.render(TodoopApi.ErrorView, "401.json")
  end
end
