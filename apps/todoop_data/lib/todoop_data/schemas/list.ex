defmodule TodoopData.List do
  use TodoopData, :data
  use Ecto.Schema

  schema "lists" do
    field(:name, :string)
    field(:description, :string)
    field(:status, ListStatus, default: :active)

    timestamps()

    has_many(:tasks, TodoopData.Task, on_delete: :delete_all)
    belongs_to(:user, TodoopData.User)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :status])
    |> validate_required([:name])
  end
end
