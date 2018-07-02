defmodule TodoopApi.SessionController do
  use TodoopApi, :controller

  alias TodoopApi.AuthService

  def create(conn, %{"email" => email, "password" => password}) do
    case AuthService.authenticate(email, password) do
      {:ok, token: token} ->
        render(conn, TodoopApi.UserView, "token.json", token: token)
      _ ->
        conn
        |> put_status(:unauthorized)
        |> render(TodoopApi.ErrorView, "401.json")
    end
  end
end
