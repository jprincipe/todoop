defmodule TodoopData.Task do
  use TodoopData, :data
  use Ecto.Schema

  schema "tasks" do
    field(:title, :string)
    field(:description, :string)
    field(:status, TaskStatus, default: :active)

    timestamps()

    belongs_to(:list, TodoopData.List)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description, :status])
    |> validate_required([:title])
  end
end
