defmodule TodoopData.Tasks.Task do
  use TodoopData, :data

  schema "tasks" do
    field(:title, :string)
    field(:description, :string)
    field(:status, TaskStatus, default: :active)

    timestamps()

    belongs_to(:board, TodoopData.Boards.Board)
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description, :status])
    |> validate_required([:title])
  end
end
