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
    end
  end
end
