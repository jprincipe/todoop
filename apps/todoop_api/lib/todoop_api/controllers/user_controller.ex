defmodule TodoopApi.UserController do
  use TodoopApi, :controller

  alias TodoopData.User
  alias TodoopApi.Guardian

  plug(:scrub_params, "user" when action in [:create])

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)

        conn
        |> put_status(:created)
        |> render("token.json", token: token)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TodoopApi.ErrorView, "422.json", changeset: changeset)
    end
  end

  def show(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    render(conn, "show.json", user: user)
  end
end
