defmodule TodoopData.Accounts do
  @moduledoc "The Boards context."

  import Ecto.Query, warn: false
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias TodoopData.Repo
  alias TodoopData.Accounts.User

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def get_user(id), do: Repo.get(User, id)

  def authenticate(email, password) do
    case verify_user(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = TodoopApi.Guardian.encode_and_sign(user)

        {:ok, token: token}

      _ ->
        {:error, :unauthorized}
    end
  end

  defp verify_user(email, password) when is_binary(email) and is_binary(password) do
    with {:ok, user} <- load_user(email), do: verify_password(password, user)
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
