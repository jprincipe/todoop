defmodule TodoopData.BoardFactory do
  defmacro __using__(_opts) do
    quote do
      def board_factory do
        %TodoopData.Board{
          name: sequence(:name, &"board #{&1}"),
          description: "board description",
          status: :active,
          user: build(:user)
        }
      end

      def with_tasks(%TodoopData.Board{} = board) do
        insert_pair(:task, board: board)
        board
      end
    end
  end
end
