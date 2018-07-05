defmodule TodoopData.BoardService do
  use TodoopData, :data

  alias TodoopData.Board

  def load_boards(user) do
    from(
      board in Board,
      where: board.user_id == ^user.id,
      order_by: board.name,
      preload: [tasks: ^task_query()]
    )
    |> Repo.all()
  end

  def load_board(user, board_id) do
    from(
      board in Board,
      where: board.user_id == ^user.id,
      where: board.id == ^board_id,
      preload: [tasks: ^task_query()]
    )
    |> Repo.one()
  end

  def task_query(), do: from(t in TodoopData.Task, order_by: t.inserted_at)
end
