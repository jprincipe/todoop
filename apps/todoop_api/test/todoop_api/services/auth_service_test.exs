defmodule TodoopApi.AuthServiceTest do
  use TodoopApi.ConnCase, async: false

  alias TodoopData.User
  alias TodoopApi.AuthService

  test "authenticates valid user" do
    user_params = %{email: "foo@bar.com", password: "s3cr3t"}
    source_user = %User{} |> User.registration_changeset(user_params) |> Repo.insert!()

    {result, user: user, jwt: jwt} = AuthService.authenticate(user_params[:email], user_params[:password])

    assert result == :ok
    assert user
    assert user.email == source_user.email
    assert user.id == source_user.id
    assert jwt
  end

  test "returns unauthorized for unknown user" do
    assert {:error, :unauthorized} == AuthService.authenticate("bad@email.com", "password")
  end

  test "returns unauthorized for bad password" do
    user_params = %{email: "foo@bar.com", password: "s3cr3t"}
    %User{} |> User.registration_changeset(user_params) |> Repo.insert!()

    assert {:error, :unauthorized} == AuthService.authenticate(user_params[:email], "badpass")
  end
end
