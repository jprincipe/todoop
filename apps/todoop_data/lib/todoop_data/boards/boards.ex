defmodule TodoopData.Boards do
  @moduledoc "The Boards context."

  import Ecto.Query, warn: false

  alias TodoopData.Repo
  alias TodoopData.Accounts.User
  alias TodoopData.Boards.Board

  def list_boards(%User{} = user) do
    from(
      board in Board,
      where: board.user_id == ^user.id,
      order_by: board.name,
      preload: [tasks: ^task_query()]
    )
    |> Repo.all()
  end

  def get_board(%User{} = user, id) do
    from(
      board in Board,
      where: board.user_id == ^user.id,
      where: board.id == ^id,
      preload: [tasks: ^task_query()]
    )
    |> Repo.one()
  end

  def create_board(%User{} = user, attrs) do
    %Board{}
    |> Board.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
    |> case do
      {:ok, board} ->
        board = Repo.preload(board, tasks: task_query())
        payload = TodoopApi.BoardView.render("board.json", %{board: board})
        TodoopApi.Endpoint.broadcast!("board:list", "board:created", %{board: payload})

        {:ok, board}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def update_board(%Board{} = board, attrs) do
    board
    |> Board.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, board} ->
        board = Repo.preload(board, tasks: task_query())
        payload = TodoopApi.BoardView.render("board.json", %{board: board})
        TodoopApi.Endpoint.broadcast!("board:#{board.id}", "board:updated", %{board: payload})

        {:ok, board}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def delete_board(%Board{} = board) do
    case Repo.delete(board) do
      {:ok, board} ->
        TodoopApi.Endpoint.broadcast!("board:#{board.id}", "board:deleted", %{})

        {:ok, board}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp task_query(), do: from(t in TodoopData.Tasks.Task, order_by: t.inserted_at)
end
