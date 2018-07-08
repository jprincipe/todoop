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

  def get_task(%Board{} = board, id) do
    from(
      task in Task,
      where: task.board_id == ^board.id,
      where: task.id == ^id
    )
    |> Repo.one()
  end

  def create_task(%Board{} = board, attrs) do
    %Task{}
    |> Task.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:board, board)
    |> Repo.insert()
    |> case do
      {:ok, task} ->
        payload = TodoopApi.TaskView.render("task.json", %{task: task})
        TodoopApi.Endpoint.broadcast!("board:#{task.board_id}", "task:created", %{task: payload})

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
        payload = TodoopApi.TaskView.render("task.json", %{task: task})
        TodoopApi.Endpoint.broadcast!("board:#{task.board_id}", "task:updated", %{task: payload})

        {:ok, task}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def delete_task(%Task{} = task) do
    case Repo.delete(task) do
      {:ok, task} ->
        payload = TodoopApi.TaskView.render("task.json", %{task: task})
        TodoopApi.Endpoint.broadcast!("board:#{task.board_id}", "task:deleted", %{task: payload})

        {:ok, task}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
