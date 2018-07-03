defmodule TodoopData.TaskFactory do
  defmacro __using__(_opts) do
    quote do
      def task_factory do
        %TodoopData.Task{
          title: sequence(:title, &"task #{&1}"),
          description: "task description",
          status: :active,
          list: build(:list)
        }
      end
    end
  end
end
