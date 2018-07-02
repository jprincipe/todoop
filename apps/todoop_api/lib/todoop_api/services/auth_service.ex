defmodule TodoopApi.AuthService do
  import Plug.Conn

  alias TodoopData.Repo
  alias TodoopData.User

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def authenticate(email, password) do
    case verify_user(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = TodoopApi.Guardian.encode_and_sign(user)

        {:ok, token: token}
      _ ->
        {:error, :unauthorized}
    end
  end

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> Phoenix.Controller.render(TodoopApi.ErrorView, "401.json")
  end

  defp verify_user(email, password) when is_binary(email) and is_binary(password) do
    with {:ok, user} <- load_user(email),
    do: verify_password(password, user)
  end

  defp load_user(email) when is_binary(email) do
    case Repo.get_by(User, email: email) do
      nil ->
        dummy_checkpw()
        {:error, "Login error."}
      user ->
        {:ok, user}
    end
  end

  defp verify_password(password, %User{} = user) when is_binary(password) do
    if checkpw(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :invalid_password}
    end
  end
end
