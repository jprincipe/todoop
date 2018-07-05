defmodule TodoopData.TaskFactory do
  defmacro __using__(_opts) do
    quote do
      def task_factory do
        %TodoopData.Tasks.Task{
          title: sequence(:title, &"task #{&1}"),
          description: "task description",
          status: :active,
          board: build(:board)
        }
      end
    end
  end
end
