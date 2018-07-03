defmodule TodoopApi.ListViewTest do
  use TodoopApi.ConnCase, async: true

  import Phoenix.View

  alias TodoopData.ListService

  test "renders index.json" do
    user = insert(:user)

    insert(:list, user: user) |> with_tasks()
    insert(:list, user: user) |> with_tasks()

    lists = ListService.load_lists(user)

    list1 = Enum.at(lists, 0)
    task1 = Enum.at(list1.tasks, 0)
    task2 = Enum.at(list1.tasks, 1)

    list2 = Enum.at(lists, 1)
    task3 = Enum.at(list2.tasks, 0)
    task4 = Enum.at(list2.tasks, 1)

    assert render(TodoopApi.ListView, "index.json", %{lists: lists}) == %{
             data: [
               %{
                 id: list1.id,
                 name: list1.name,
                 description: list1.description,
                 status: list1.status,
                 tasks: [
                   %{
                     id: task1.id,
                     title: task1.title,
                     description: task1.description,
                     status: task1.status
                   },
                   %{
                     id: task2.id,
                     title: task2.title,
                     description: task2.description,
                     status: task2.status
                   }
                 ]
               },
               %{
                 id: list2.id,
                 name: list2.name,
                 description: list2.description,
                 status: list2.status,
                 tasks: [
                   %{
                     id: task3.id,
                     title: task3.title,
                     description: task3.description,
                     status: task3.status
                   },
                   %{
                     id: task4.id,
                     title: task4.title,
                     description: task4.description,
                     status: task4.status
                   }
                 ]
               }
             ]
           }
  end

  test "renders show.json" do
    list = insert(:list) |> with_tasks()

    list = ListService.load_list(list.user, list.id)
    task1 = Enum.at(list.tasks, 0)
    task2 = Enum.at(list.tasks, 1)

    assert render(TodoopApi.ListView, "show.json", %{list: list}) == %{
             data: %{
               id: list.id,
               name: list.name,
               description: list.description,
               status: list.status,
               tasks: [
                 %{
                   id: task1.id,
                   title: task1.title,
                   description: task1.description,
                   status: task1.status
                 },
                 %{
                   id: task2.id,
                   title: task2.title,
                   description: task2.description,
                   status: task2.status
                 }
               ]
             }
           }
  end
end
