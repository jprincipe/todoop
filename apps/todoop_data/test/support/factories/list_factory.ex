defmodule TodoopData.ListFactory do
  defmacro __using__(_opts) do
    quote do
      def list_factory do
        %TodoopData.List{
          name: sequence(:name, &"list #{&1}"),
          description: "list description",
          status: :active,
          user: build(:user)
        }
      end

      def with_tasks(%TodoopData.List{} = list) do
        insert_pair(:task, list: list)
        list
      end
    end
  end
end
