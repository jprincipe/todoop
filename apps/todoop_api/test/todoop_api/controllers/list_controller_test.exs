defmodule TodoopApi.ListControllerTest do
  use TodoopApi.ConnCase, async: false

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json"), user: insert(:user)}
  end

  describe "index" do
    test "returns all lists associated with logged in user", %{conn: conn, user: user} do
      lists = insert_pair(:list, user: user)

      conn = conn |> set_auth_header(user) |> get(list_path(conn, :index))
      body = json_response(conn, 200)
      assert body["data"]

      expected_list_ids = Enum.map(lists, & &1.id)
      result_list_ids = Enum.map(body["data"], & &1["id"])

      assert expected_list_ids == result_list_ids
    end

    test "returns tasks associated with all lists", %{conn: conn, user: user} do
      list = insert(:list, user: user)
      task = insert(:task, list: list)

      conn = conn |> set_auth_header(user) |> get(list_path(conn, :index))
      body = json_response(conn, 200)
      assert body["data"]

      assert body["data"] == [%{
        "id" => list.id,
        "name" => list.name,
        "description" => list.description,
        "status" => to_string(list.status),
        "tasks" => [%{
          "id" => task.id,
          "title" => task.title,
          "description" => task.description,
          "status" => to_string(task.status)
        }]
      }]
    end

    test "doesn't return lists associated with different user", %{conn: conn, user: user} do
      insert(:list)

      conn = conn |> set_auth_header(user) |> get(list_path(conn, :index))
      body = json_response(conn, 200)
      assert body["data"]
      assert Enum.empty?(body["data"])
    end

    test "returns error if not logged in", %{conn: conn} do
      conn = conn |> put_req_header("authorization", "Bearer badtoken") |> get(list_path(conn, :index))

      body = json_response(conn, 401)
      assert body["errors"] == %{"detail" => "unauthorized"}
    end
  end

  describe "show" do
    test "returns requested list", %{conn: conn, user: user} do
      list = insert(:list, user: user)
      task = insert(:task, list: list)

      conn = conn |> set_auth_header(user) |> get(list_path(conn, :show, list.id))

      body = json_response(conn, 200)
      assert body["data"] == %{
        "id" => list.id,
        "name" => list.name,
        "description" => list.description,
        "status" => to_string(list.status),
        "tasks" => [%{
          "id" => task.id,
          "title" => task.title,
          "description" => task.description,
          "status" => to_string(task.status)
        }]
      }
    end

    test "returns 401 when not authenticated", %{conn: conn} do
      conn = conn |> put_req_header("authorization", "Bearer badtoken") |> get(user_path(conn, :show))

      body = json_response(conn, 401)
      assert body["errors"] == %{"detail" => "unauthorized"}
    end

    test "returns error if requested list not owned by user", %{conn: conn, user: user} do
      list = insert(:list)

      conn = conn |> set_auth_header(user) |> get(list_path(conn, :show, list.id))

      body = json_response(conn, 404)
      assert body["errors"] == %{"detail" => "not found"}
    end
  end

  describe "create" do
  end

  describe "update" do
  end

  describe "destroy" do
  end
end
