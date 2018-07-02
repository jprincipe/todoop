defmodule TodoopApi.SessionControllerTest do
  use TodoopApi.ConnCase, async: false

  alias TodoopData.User

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "authenticates valid user", %{conn: conn} do
    user_params = %{email: "foo@bar.com", password: "s3cr3t"}
    source_user = %User{} |> User.registration_changeset(user_params) |> Repo.insert!()

    conn = post conn, session_path(conn, :create), user_params
    body = json_response(conn, 200)
    assert body["id"] == source_user.id
    assert body["email"] == source_user.email
    refute is_nil(body["jwt"])
  end

  test "returns unauthorized for unknown user", %{conn: conn} do
    conn = post conn, session_path(conn, :create), %{email: "bad@email.com", password: "badpass"}

    body = json_response(conn, 401)
    assert body == %{"errors" => %{"detail" => "unauthorized"}}
  end

  test "returns unauthorized for invalid user password", %{conn: conn} do
    user_params = %{email: "foo@bar.com", password: "s3cr3t"}
    source_user = %User{} |> User.registration_changeset(user_params) |> Repo.insert!()

    conn = post conn, session_path(conn, :create), %{email: source_user.email, password: "badpass"}

    body = json_response(conn, 401)
    assert body == %{"errors" => %{"detail" => "unauthorized"}}
  end
end
