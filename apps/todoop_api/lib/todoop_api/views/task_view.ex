defmodule TodoopApi.TaskView do
  use TodoopApi, :view

  def render("show.json", %{task: task}) do
    %{data: render_one(task, TodoopApi.TaskView, "task.json")}
  end

  def render("task.json", %{task: task}) do
    %{
      id: task.id,
      title: task.title,
      description: task.description,
      status: task.status
    }
  end
end
