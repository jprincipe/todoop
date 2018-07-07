defmodule TodoopApi.BoardChannel do
  use TodoopApi, :channel

  alias TodoopData.Boards

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

  def handle_in("board:create", attrs, socket) do
    user = current_resource(socket)

    case Boards.create_board(user, attrs) do
      {:ok, _board} ->
        {:reply, :ok, socket}

      {:error, changeset} ->
        response = TodoopApi.ErrorView.render("422.json", changeset: changeset)

        {:reply, {:error, response}, socket}
    end
  end

  def handle_in("board:update", attrs, socket) do
    user = current_resource(socket)
    board = Boards.get_board(user, socket.assigns.board_id)

    case Boards.update_board(board, attrs) do
      {:ok, _board} ->
        {:reply, :ok, socket}

      {:error, changeset} ->
        response = TodoopApi.ErrorView.render("422.json", changeset: changeset)

        {:reply, {:error, response}, socket}
    end
  end

  def handle_in("board:delete", _attrs, socket) do
    user = current_resource(socket)
    board = Boards.get_board(user, socket.assigns.board_id)

    case Boards.delete_board(board) do
      {:ok, _board} ->
        {:reply, :ok, socket}

      {:error, changeset} ->
        response = TodoopApi.ErrorView.render("422.json", changeset: changeset)

        {:reply, {:error, response}, socket}
    end
  end
end
