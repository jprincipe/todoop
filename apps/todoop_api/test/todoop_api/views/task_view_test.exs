defmodule TodoopApi.TaskViewTest do
  use TodoopApi.ConnCase, async: true

  import Phoenix.View

  test "renders show.json" do
    task = insert(:task)

    assert render(TodoopApi.TaskView, "show.json", %{task: task}) == %{
             data: %{
               id: task.id,
               title: task.title,
               description: task.description,
               status: task.status,
               board_id: task.board.id
             }
           }
  end
end
