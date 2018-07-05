defmodule TodoopApi.ListControllerTest do
  use TodoopApi.ConnCase, async: false

  alias TodoopData.List
  alias TodoopData.Task

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
    test "creates and renders list", %{conn: conn, user: user} do
      list_params = params_for(:list)

      conn = conn |> set_auth_header(user) |> post(list_path(conn, :create), list: list_params)

      body = json_response(conn, 201)
      assert body["data"]["id"]
      assert body["data"]["name"] == list_params[:name]
      assert body["data"]["description"] == list_params[:description]
      assert body["data"]["status"] == to_string(list_params[:status])
      assert Enum.empty?(body["data"]["tasks"])

      list = Repo.get_by(TodoopData.List, name: list_params[:name])
      assert list.user_id == user.id
    end

    test "does not create list and renders errors when data is invalid", %{conn: conn, user: user} do
      conn = conn |> set_auth_header(user) |> post(list_path(conn, :create), list: %{})
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "returns 401 when not authenticated", %{conn: conn} do
      conn = conn |> put_req_header("authorization", "Bearer badtoken") |> get(list_path(conn, :create), list: params_for(:list))

      body = json_response(conn, 401)
      assert body["errors"] == %{"detail" => "unauthorized"}
    end
  end

  describe "update" do
    test "updates list and renders updated list", %{conn: conn, user: user} do
      list = insert(:list, user: user)

      conn = conn |> set_auth_header(user) |> put(list_path(conn, :update, list.id), list: %{name: "Updated List Name"})

      body = json_response(conn, 200)
      assert body["data"]["id"] == list.id
      assert body["data"]["name"] == "Updated List Name"
    end

    test "does not update list and renders errors when data is invalid", %{conn: conn, user: user} do
      list = insert(:list, user: user)

      conn = conn |> set_auth_header(user) |> put(list_path(conn, :update, list.id), list: %{name: nil})
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "returns error if requested list not owned by user", %{conn: conn, user: user} do
      list = insert(:list)

      conn = conn |> set_auth_header(user) |> put(list_path(conn, :update, list.id), list: %{name: "updated list name"})

      body = json_response(conn, 404)
      assert body["errors"] == %{"detail" => "not found"}
    end
  end

  describe "destroy" do
    test "deletes list and all associated tasks", %{conn: conn, user: user} do
      list = insert(:list, user: user)
      task = insert(:task, list: list)

      conn = conn |> set_auth_header(user) |> delete(list_path(conn, :delete, list.id))

      response(conn, 204)

      refute Repo.get_by(List, id: list.id)
      refute Repo.get_by(Task, id: task.id)
    end

    test "returns 401 when not authenticated", %{conn: conn, user: user} do
      list = insert(:list, user: user)

      conn = conn |> put_req_header("authorization", "Bearer badtoken") |> delete(list_path(conn, :delete, list.id))

      body = json_response(conn, 401)
      assert body["errors"] == %{"detail" => "unauthorized"}
    end

    test "returns error if requested list not owned by user", %{conn: conn, user: user} do
      list = insert(:list)

      conn = conn |> set_auth_header(user) |> delete(list_path(conn, :delete, list.id))

      body = json_response(conn, 404)
      assert body["errors"] == %{"detail" => "not found"}

      assert Repo.get_by(List, id: list.id)
    end
  end
end
