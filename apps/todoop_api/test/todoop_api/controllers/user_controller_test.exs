defmodule TodoopApi.UserControllerTest do
  use TodoopApi.ConnCase, async: false

  alias TodoopData.User

  @valid_attrs %{email: "foo@bar.com", password: "s3cr3t"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "register" do
    test "creates and renders resource when data is valid", %{conn: conn} do
      conn = post(conn, user_path(conn, :create), user: @valid_attrs)
      body = json_response(conn, 201)
      assert body["token"]
      assert Repo.get_by(User, email: "foo@bar.com")
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "me" do
    test "returns current user when authenticated", %{conn: conn} do
      source_user = %User{} |> User.registration_changeset(@valid_attrs) |> Repo.insert!()

      {:ok, token, _claims} = TodoopApi.Guardian.encode_and_sign(source_user)

      conn = conn |> put_req_header("authorization", "Bearer #{token}") |> get(user_path(conn, :show))

      body = json_response(conn, 200)
      assert body["id"] == source_user.id
      assert body["email"] == source_user.email
    end

    test "returns 401 when not authenticated", %{conn: conn} do
      conn = conn |> put_req_header("authorization", "Bearer badtoken") |> get(user_path(conn, :show))

      body = json_response(conn, 401)
      assert body["errors"] == %{"detail" => "unauthorized"}
    end
  end
end
