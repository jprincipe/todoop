defmodule TodoopApi.SessionController do
  use TodoopApi, :controller

  alias TodoopApi.AuthService

  def create(conn, %{"email" => email, "password" => password}) do
    case AuthService.authenticate(email, password) do
      {:ok, user: user, jwt: jwt} ->
        render(conn, TodoopApi.UserView, "user.json", user: user, jwt: jwt)
      _ ->
        conn
        |> put_status(:unauthorized)
        |> render(TodoopApi.ErrorView, "401.json")
    end
  end
end
