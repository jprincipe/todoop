defmodule TodoopApi.UserController do
  use TodoopApi, :controller

  alias TodoopData.User
  alias TodoopApi.Guardian

  plug :scrub_params, "user" when action in [:create]

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)

        conn
        |> put_status(:created)
        |> render("user.json", user: user, jwt: token)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TodoopApi.ErrorView, "422.json", changeset: changeset)
    end
  end
end
