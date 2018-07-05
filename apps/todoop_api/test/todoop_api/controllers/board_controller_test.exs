defmodule TodoopApi.BoardControllerTest do
  use TodoopApi.ConnCase, async: false

  alias TodoopData.Board
  alias TodoopData.Task

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json"), user: insert(:user)}
  end

  describe "index" do
    test "returns all boards associated with logged in user", %{conn: conn, user: user} do
      boards = insert_pair(:board, user: user)

      conn = conn |> set_auth_header(user) |> get(board_path(conn, :index))
      body = json_response(conn, 200)
      assert body["data"]

      expected_board_ids = Enum.map(boards, & &1.id)
      result_board_ids = Enum.map(body["data"], & &1["id"])

      assert expected_board_ids == result_board_ids
    end

    test "returns tasks associated with all boards", %{conn: conn, user: user} do
      board = insert(:board, user: user)
      task = insert(:task, board: board)

      conn = conn |> set_auth_header(user) |> get(board_path(conn, :index))
      body = json_response(conn, 200)
      assert body["data"]

      assert body["data"] == [%{
        "id" => board.id,
        "name" => board.name,
        "description" => board.description,
        "status" => to_string(board.status),
        "tasks" => [%{
          "id" => task.id,
          "title" => task.title,
          "description" => task.description,
          "status" => to_string(task.status)
        }]
      }]
    end

    test "doesn't return boards associated with different user", %{conn: conn, user: user} do
      insert(:board)

      conn = conn |> set_auth_header(user) |> get(board_path(conn, :index))
      body = json_response(conn, 200)
      assert body["data"]
      assert Enum.empty?(body["data"])
    end

    test "returns error if not logged in", %{conn: conn} do
      conn = conn |> put_req_header("authorization", "Bearer badtoken") |> get(board_path(conn, :index))

      body = json_response(conn, 401)
      assert body["errors"] == %{"detail" => "unauthorized"}
    end
  end

  describe "show" do
    test "returns requested board", %{conn: conn, user: user} do
      board = insert(:board, user: user)
      task = insert(:task, board: board)

      conn = conn |> set_auth_header(user) |> get(board_path(conn, :show, board.id))

      body = json_response(conn, 200)
      assert body["data"] == %{
        "id" => board.id,
        "name" => board.name,
        "description" => board.description,
        "status" => to_string(board.status),
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

    test "returns error if requested board not owned by user", %{conn: conn, user: user} do
      board = insert(:board)

      conn = conn |> set_auth_header(user) |> get(board_path(conn, :show, board.id))

      body = json_response(conn, 404)
      assert body["errors"] == %{"detail" => "not found"}
    end
  end

  describe "create" do
    test "creates and renders board", %{conn: conn, user: user} do
      board_params = params_for(:board)

      conn = conn |> set_auth_header(user) |> post(board_path(conn, :create), board: board_params)

      body = json_response(conn, 201)
      assert body["data"]["id"]
      assert body["data"]["name"] == board_params[:name]
      assert body["data"]["description"] == board_params[:description]
      assert body["data"]["status"] == to_string(board_params[:status])
      assert Enum.empty?(body["data"]["tasks"])

      board = Repo.get_by(TodoopData.Board, name: board_params[:name])
      assert board.user_id == user.id
    end

    test "does not create board and renders errors when data is invalid", %{conn: conn, user: user} do
      conn = conn |> set_auth_header(user) |> post(board_path(conn, :create), board: %{})
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "returns 401 when not authenticated", %{conn: conn} do
      conn = conn |> put_req_header("authorization", "Bearer badtoken") |> get(board_path(conn, :create), board: params_for(:board))

      body = json_response(conn, 401)
      assert body["errors"] == %{"detail" => "unauthorized"}
    end
  end

  describe "update" do
    test "updates board and renders updated board", %{conn: conn, user: user} do
      board = insert(:board, user: user)

      conn = conn |> set_auth_header(user) |> put(board_path(conn, :update, board.id), board: %{name: "Updated Board Name"})

      body = json_response(conn, 200)
      assert body["data"]["id"] == board.id
      assert body["data"]["name"] == "Updated Board Name"
    end

    test "does not update board and renders errors when data is invalid", %{conn: conn, user: user} do
      board = insert(:board, user: user)

      conn = conn |> set_auth_header(user) |> put(board_path(conn, :update, board.id), board: %{name: nil})
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "returns error if requested board not owned by user", %{conn: conn, user: user} do
      board = insert(:board)

      conn = conn |> set_auth_header(user) |> put(board_path(conn, :update, board.id), board: %{name: "updated board name"})

      body = json_response(conn, 404)
      assert body["errors"] == %{"detail" => "not found"}
    end
  end

  describe "destroy" do
    test "deletes board and all associated tasks", %{conn: conn, user: user} do
      board = insert(:board, user: user)
      task = insert(:task, board: board)

      conn = conn |> set_auth_header(user) |> delete(board_path(conn, :delete, board.id))

      response(conn, 204)

      refute Repo.get_by(Board, id: board.id)
      refute Repo.get_by(Task, id: task.id)
    end

    test "returns 401 when not authenticated", %{conn: conn, user: user} do
      board = insert(:board, user: user)

      conn = conn |> put_req_header("authorization", "Bearer badtoken") |> delete(board_path(conn, :delete, board.id))

      body = json_response(conn, 401)
      assert body["errors"] == %{"detail" => "unauthorized"}
    end

    test "returns error if requested board not owned by user", %{conn: conn, user: user} do
      board = insert(:board)

      conn = conn |> set_auth_header(user) |> delete(board_path(conn, :delete, board.id))

      body = json_response(conn, 404)
      assert body["errors"] == %{"detail" => "not found"}

      assert Repo.get_by(Board, id: board.id)
    end
  end
end
