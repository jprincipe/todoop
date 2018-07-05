defmodule TodoopApi.BoardView do
  use TodoopApi, :view

  def render("index.json", %{boards: boards}) do
    %{data: render_many(boards, TodoopApi.BoardView, "board.json")}
  end

  def render("show.json", %{board: board}) do
    %{data: render_one(board, TodoopApi.BoardView, "board.json")}
  end

  def render("board.json", %{board: board}) do
    %{
      id: board.id,
      name: board.name,
      description: board.description,
      status: board.status,
      tasks: render_many(board.tasks, TodoopApi.TaskView, "task.json")
    }
  end
end
