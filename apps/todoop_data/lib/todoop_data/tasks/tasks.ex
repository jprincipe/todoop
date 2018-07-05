defmodule TodoopData.Tasks do
  @moduledoc "The Tasks context."

  import Ecto.Query, warn: false

  alias TodoopData.Repo
  alias TodoopData.Tasks.Task
  alias TodoopData.Boards.Board

  def list_tasks(%Board{} = board) do
    from(
      task in Task,
      where: task.board_id == ^board.id,
      order_by: task.inserted_at
    )
    |> Repo.all()
  end

  def get_task(task_id), do: Repo.get(Task, task_id)

  def create_task(%Board{} = board, attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:board, board)
    |> Repo.insert()
  end

  def update_task(%Task{} = task, attrs \\ %{}) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end
end
