defmodule TodoopApi.ListView do
  use TodoopApi, :view

  def render("index.json", %{lists: lists}) do
    %{data: render_many(lists, TodoopApi.ListView, "list.json")}
  end

  def render("show.json", %{list: list}) do
    %{data: render_one(list, TodoopApi.ListView, "list.json")}
  end

  def render("list.json", %{list: list}) do
    %{
      id: list.id,
      name: list.name,
      description: list.description,
      status: list.status,
      tasks: render_many(list.tasks, TodoopApi.TaskView, "task.json")
    }
  end
end
