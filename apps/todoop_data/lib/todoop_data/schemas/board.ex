defmodule TodoopData.Board do
  use TodoopData, :data
  use Ecto.Schema

  schema "boards" do
    field(:name, :string)
    field(:description, :string)
    field(:status, BoardStatus, default: :active)

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
