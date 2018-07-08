defmodule TodoopApi.BoardChannel do
  use TodoopApi, :channel

  alias TodoopData.Boards
  alias TodoopData.Tasks

  def join("board:list", _message, socket) do
    user = current_resource(socket)
    boards = Boards.list_boards(user)
    data = TodoopApi.BoardView.render("index.json", %{boards: boards})

    {:ok, data, socket}
  end

  def join("board:" <> board_id, _params, socket) do
    user = current_resource(socket)

    case Boards.get_board(user, board_id) do
      nil ->
        {:error, %{reason: "not found"}}

      board ->
        socket = assign(socket, :board_id, board_id)
        data = TodoopApi.BoardView.render("show.json", %{board: board})
        {:ok, data, socket}
    end
  end

  def handle_in("board:create", params, socket) do
    user = current_resource(socket)

    case Boards.create_board(user, params) do
      {:ok, _board} ->
        {:reply, :ok, socket}

      {:error, changeset} ->
        handle_error(socket, changeset)
    end
  end

  def handle_in("board:update", params, socket) do
    user = current_resource(socket)
    board = Boards.get_board(user, socket.assigns.board_id)

    case Boards.update_board(board, params) do
      {:ok, _board} ->
        {:reply, :ok, socket}

      {:error, changeset} ->
        handle_error(socket, changeset)
    end
  end

  def handle_in("board:delete", _params, socket) do
    user = current_resource(socket)
    board = Boards.get_board(user, socket.assigns.board_id)

    case Boards.delete_board(board) do
      {:ok, _board} ->
        {:reply, :ok, socket}

      {:error, changeset} ->
        handle_error(socket, changeset)
    end
  end

  def handle_in("task:create", params, socket) do
    user = current_resource(socket)
    board = Boards.get_board(user, socket.assigns.board_id)

    case Tasks.create_task(board, params) do
      {:ok, _task} ->
        {:reply, :ok, socket}

      {:error, changeset} ->
        handle_error(socket, changeset)
    end
  end

  def handle_in("task:update", %{"id" => task_id} = params, socket) do
    user = current_resource(socket)
    board = Boards.get_board(user, socket.assigns.board_id)
    task = Tasks.get_task(board, task_id)

    case Tasks.update_task(task, params) do
      {:ok, _task} ->
        {:reply, :ok, socket}

      {:error, changeset} ->
        handle_error(socket, changeset)
    end
  end

  def handle_in("task:delete", %{"id" => task_id}, socket) do
    user = current_resource(socket)
    board = Boards.get_board(user, socket.assigns.board_id)
    task = Tasks.get_task(board, task_id)

    case Tasks.delete_task(task) do
      {:ok, _task} ->
        {:reply, :ok, socket}

      {:error, changeset} ->
        handle_error(socket, changeset)
    end
  end

  defp handle_error(socket, changeset) do
    response = TodoopApi.ErrorView.render("422.json", changeset: changeset)

    {:reply, {:error, response}, socket}
  end
end
