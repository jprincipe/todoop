defmodule TodoopApi.BoardController do
  use TodoopApi, :controller

  alias TodoopApi.Guardian
  alias TodoopData.Board
  alias TodoopData.BoardService

  plug(:scrub_params, "board" when action in [:create, :update])
  plug(:load_board when action in [:show, :update, :delete])

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    boards = BoardService.load_boards(user)

    render(conn, "index.json", boards: boards)
  end

  def show(conn, %{"id" => _board_id}) do
    render(conn, "show.json", board: conn.assigns.board)
  end

  def create(conn, %{"board" => board_params}) do
    user = Guardian.Plug.current_resource(conn)

    %Board{}
    |> Board.changeset(board_params)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
    |> case do
      {:ok, board} ->
        board = Repo.preload(board, [:tasks])

        conn
        |> put_status(:created)
        |> render("show.json", board: board)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TodoopApi.ErrorView, "422.json", changeset: changeset)
    end
  end

  def update(conn, %{"id" => _board_id, "board" => board_params}) do
    conn.assigns.board
    |> Board.changeset(board_params)
    |> Repo.update()
    |> case do
      {:ok, board} ->
        board = Repo.preload(board, [tasks: BoardService.task_query()])

        conn
        |> put_status(:ok)
        |> render("show.json", board: board)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TodoopApi.ErrorView, "422.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => _board_id}) do
    case Repo.delete(conn.assigns.board) do
      {:ok, _} ->
        send_resp(conn, :no_content, "")

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TodoopApi.ErrorView, "422.json", changeset: changeset)
    end
  end

  defp load_board(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    board_id = conn.params["id"]

    case BoardService.load_board(user, board_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(TodoopApi.ErrorView, "404.json")
        |> halt

      board ->
        assign(conn, :board, board)
    end
  end
end
