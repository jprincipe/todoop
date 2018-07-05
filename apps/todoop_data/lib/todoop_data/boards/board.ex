defmodule TodoopData.Boards.Board do
  use TodoopData, :data

  schema "boards" do
    field(:name, :string)
    field(:description, :string)
    field(:status, BoardStatus, default: :active)

    timestamps()

    has_many(:tasks, TodoopData.Tasks.Task, on_delete: :delete_all)
    belongs_to(:user, TodoopData.Accounts.User)
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :status])
    |> validate_required([:name])
  end
end
