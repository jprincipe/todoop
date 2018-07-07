defmodule TodoopApi.UserControllerTest do
  use TodoopApi.ConnCase

  alias TodoopData.Accounts.User

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "register" do
    test "creates and renders resource when data is valid", %{conn: conn} do
      user_params = params_for(:user)
      conn = post(conn, user_path(conn, :create), user: user_params)
      body = json_response(conn, 201)
      assert body["token"]
      assert Repo.get_by(User, email: user_params[:email])
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, user_path(conn, :create), user: %{})
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "me" do
    test "returns current user when authenticated", %{conn: conn} do
      source_user = insert(:user)

      {:ok, token, _claims} = TodoopApi.Guardian.encode_and_sign(source_user)

      conn = conn |> put_req_header("authorization", "Bearer #{token}") |> get(user_path(conn, :show))

      body = json_response(conn, 200)
      assert body["data"]["id"] == source_user.id
      assert body["data"]["email"] == source_user.email
    end

    test "returns 401 when not authenticated", %{conn: conn} do
      conn = conn |> put_req_header("authorization", "Bearer badtoken") |> get(user_path(conn, :show))

      body = json_response(conn, 401)
      assert body["errors"] == %{"detail" => "unauthorized"}
    end
  end
end
