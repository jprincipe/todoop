defmodule TodoopApi.BoardChannelTest do
  use TodoopApi.ChannelCase

  alias TodoopData.Boards
  alias TodoopData.Boards.Board
  alias TodoopData.Tasks
  alias TodoopData.Tasks.Task
  alias TodoopApi.BoardChannel

  setup do
    user = insert(:user)
    socket = authed_socket(socket(), user)

    %{socket: socket, user: user}
  end

  describe "join board:list" do
    test "join board:list channel, returns empty list of boards", %{socket: socket} do
      {:ok, data, _socket} = subscribe_and_join(socket, BoardChannel, "board:list")

      assert data[:data] == []
    end

    test "join board:list channel, returns list of boards with tasks", %{socket: socket, user: user} do
      board = insert(:board, user: user)
      task = insert(:task, board: board)

      {:ok, data, _socket} = subscribe_and_join(socket, BoardChannel, "board:list")

      assert data[:data] == [
               %{
                 id: board.id,
                 name: board.name,
                 description: board.description,
                 status: board.status,
                 tasks: [
                   %{
                     id: task.id,
                     title: task.title,
                     description: task.description,
                     status: task.status,
                     board_id: task.board_id
                   }
                 ]
               }
             ]
    end
  end

  describe "join board:board_id" do
    test "join board:board_id channel, returns board with tasks", %{socket: socket, user: user} do
      board = insert(:board, user: user)
      task = insert(:task, board: board)

      {:ok, data, _socket} = subscribe_and_join(socket, BoardChannel, "board:#{board.id}")

      assert data[:data] == %{
               id: board.id,
               name: board.name,
               description: board.description,
               status: board.status,
               tasks: [
                 %{
                   id: task.id,
                   title: task.title,
                   description: task.description,
                   status: task.status,
                   board_id: task.board_id
                 }
               ]
             }
    end

    test "return error trying to join board:board_id channel with bad id", %{socket: socket} do
      {:error, %{reason: reason}} = subscribe_and_join(socket, BoardChannel, "board:0")

      assert reason == "not found"
    end

    test "return error trying to join board:board_id channel for unauthorized board", %{socket: socket} do
      board = insert(:board)

      {:error, %{reason: reason}} = subscribe_and_join(socket, BoardChannel, "board:#{board.id}")

      assert reason == "not found"
    end
  end

  describe "board:create" do
    test "successfully creates board", %{socket: socket} do
      board_params = params_for(:board)

      {:ok, _data, socket} = subscribe_and_join(socket, BoardChannel, "board:list")
      ref = push(socket, "board:create", board_params)

      assert_reply(ref, :ok)
      assert_broadcast("board:created", %{board: payload})

      assert payload[:id]
      assert payload[:name] == board_params[:name]
      assert payload[:description] == board_params[:description]
      assert payload[:status] == board_params[:status]
      assert payload[:tasks] == []

      assert Repo.get(Board, payload[:id])
    end

    test "does not create board and renders errors when data is invalid", %{socket: socket} do
      {:ok, _data, socket} = subscribe_and_join(socket, BoardChannel, "board:list")
      ref = push(socket, "board:create", %{})

      assert_reply(ref, :error, %{errors: %{name: ["can't be blank"]}})
    end
  end

  describe "board:update" do
    test "successfully updates board", %{socket: socket, user: user} do
      board = insert(:board, user: user)
      new_board_name = "Updated Board Name"

      {:ok, _data, socket} = subscribe_and_join(socket, BoardChannel, "board:#{board.id}")
      ref = push(socket, "board:update", %{name: new_board_name})

      assert_reply(ref, :ok)
      assert_broadcast("board:updated", %{board: payload})

      board = Boards.get_board(user, board.id)
      assert board.name == new_board_name
      assert payload[:name] == new_board_name
    end

    test "does not update board and renders errors when data is invalid", %{socket: socket, user: user} do
      board = insert(:board, user: user)

      {:ok, _data, socket} = subscribe_and_join(socket, BoardChannel, "board:#{board.id}")
      ref = push(socket, "board:update", %{name: nil})

      assert_reply(ref, :error, %{errors: %{name: ["can't be blank"]}})
    end
  end

  describe "board:delete" do
    test "deletes board and all associated tasks", %{socket: socket, user: user} do
      board = insert(:board, user: user)
      task = insert(:task, board: board)

      {:ok, _data, socket} = subscribe_and_join(socket, BoardChannel, "board:#{board.id}")
      ref = push(socket, "board:delete", %{})

      assert_reply(ref, :ok)
      assert_broadcast("board:deleted", %{})

      refute Repo.get_by(Board, id: board.id)
      refute Repo.get_by(Task, id: task.id)
    end
  end

  describe "task:create" do
    test "successfully creates task", %{socket: socket, user: user} do
      board = insert(:board, user: user)
      task_params = params_for(:task, board: board)

      {:ok, _data, socket} = subscribe_and_join(socket, BoardChannel, "board:#{board.id}")
      ref = push(socket, "task:create", task_params)

      assert_reply(ref, :ok)
      assert_broadcast("task:created", %{task: payload})

      assert payload[:id]
      assert payload[:title] == task_params[:title]
      assert payload[:description] == task_params[:description]
      assert payload[:status] == task_params[:status]
      assert payload[:board_id] == board.id

      assert Repo.get(Task, payload[:id])
    end

    test "does not create task and renders errors when data is invalid", %{socket: socket, user: user} do
      board = insert(:board, user: user)

      {:ok, _data, socket} = subscribe_and_join(socket, BoardChannel, "board:#{board.id}")
      ref = push(socket, "task:create", %{})

      assert_reply(ref, :error, %{errors: %{title: ["can't be blank"]}})
    end
  end

  describe "task:update" do
    test "successfully updates task", %{socket: socket, user: user} do
      board = insert(:board, user: user)
      task = insert(:task, board: board)
      new_task_title = "Updated Task Title"

      {:ok, _data, socket} = subscribe_and_join(socket, BoardChannel, "board:#{board.id}")
      ref = push(socket, "task:update", %{id: task.id, title: new_task_title})

      assert_reply(ref, :ok)
      assert_broadcast("task:updated", %{task: payload})

      task = Tasks.get_task(board, task.id)
      assert task.title == new_task_title
      assert payload[:title] == new_task_title
    end

    test "does not update task and renders errors when data is invalid", %{socket: socket, user: user} do
      board = insert(:board, user: user)
      task = insert(:task, board: board)

      {:ok, _data, socket} = subscribe_and_join(socket, BoardChannel, "board:#{board.id}")
      ref = push(socket, "board:update", %{id: task.id, name: nil})

      assert_reply(ref, :error, %{errors: %{name: ["can't be blank"]}})
    end
  end

  describe "task:delete" do
    test "deletes task", %{socket: socket, user: user} do
      board = insert(:board, user: user)
      task = insert(:task, board: board)

      {:ok, _data, socket} = subscribe_and_join(socket, BoardChannel, "board:#{board.id}")
      ref = push(socket, "task:delete", %{id: task.id})

      assert_reply(ref, :ok)
      assert_broadcast("task:deleted", %{})

      assert Repo.get_by(Board, id: board.id)
      refute Repo.get_by(Task, id: task.id)
    end
  end
end
