defmodule TodoopApi.BoardViewTest do
  use TodoopApi.ConnCase, async: true

  import Phoenix.View

  alias TodoopData.Boards

  test "renders index.json" do
    user = insert(:user)

    insert(:board, user: user) |> with_tasks()
    insert(:board, user: user) |> with_tasks()

    boards = Boards.list_boards(user)

    board1 = Enum.at(boards, 0)
    task1 = Enum.at(board1.tasks, 0)
    task2 = Enum.at(board1.tasks, 1)

    board2 = Enum.at(boards, 1)
    task3 = Enum.at(board2.tasks, 0)
    task4 = Enum.at(board2.tasks, 1)

    assert render(TodoopApi.BoardView, "index.json", %{boards: boards}) == %{
             data: [
               %{
                 id: board1.id,
                 name: board1.name,
                 description: board1.description,
                 status: board1.status,
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
                 id: board2.id,
                 name: board2.name,
                 description: board2.description,
                 status: board2.status,
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
    board = insert(:board) |> with_tasks()

    board = Boards.get_board(board.user, board.id)
    task1 = Enum.at(board.tasks, 0)
    task2 = Enum.at(board.tasks, 1)

    assert render(TodoopApi.BoardView, "show.json", %{board: board}) == %{
             data: %{
               id: board.id,
               name: board.name,
               description: board.description,
               status: board.status,
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
