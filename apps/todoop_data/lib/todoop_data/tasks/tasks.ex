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

  def get_task(id), do: Repo.get(Task, id)

  def create_task(%Board{} = board, attrs) do
    %Task{}
    |> Task.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:board, board)
    |> Repo.insert()
    |> case do
      {:ok, task} ->
        TodoopApi.Endpoint.broadcast!("board:#{task.board_id}", "task:created", %{task_id: task.id, task: task})

        {:ok, task}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, task} ->
        TodoopApi.Endpoint.broadcast!("board:#{task.board_id}", "task:updated", %{task_id: task.id, task: task})

        {:ok, task}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def delete_task(%Task{} = task) do
    case Repo.delete(task) do
      {:ok, task} ->
        TodoopApi.Endpoint.broadcast!("board:#{task.board_id}", "task:deleted", %{task_id: task.id, task: task})

        {:ok, task}
      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
