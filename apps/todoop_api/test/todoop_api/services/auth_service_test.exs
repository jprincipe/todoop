defmodule TodoopApi.AuthServiceTest do
  use TodoopApi.ConnCase, async: false

  alias TodoopData.Accounts
  alias TodoopData.Accounts.User

  test "authenticates valid user" do
    user_params = %{email: "foo@bar.com", password: "s3cr3t"}
    %User{} |> User.registration_changeset(user_params) |> Repo.insert!()

    {result, token: token} = Accounts.authenticate(user_params[:email], user_params[:password])

    assert result == :ok
    assert token
  end

  test "returns unauthorized for unknown user" do
    assert {:error, :unauthorized} == Accounts.authenticate("bad@email.com", "password")
  end

  test "returns unauthorized for bad password" do
    user_params = %{email: "foo@bar.com", password: "s3cr3t"}
    %User{} |> User.registration_changeset(user_params) |> Repo.insert!()

    assert {:error, :unauthorized} == Accounts.authenticate(user_params[:email], "badpass")
  end
end
