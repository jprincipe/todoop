defmodule TodoopData.Repo.Migrations.CreateBoard do
  use Ecto.Migration

  def up do
    BoardStatus.create_type

    create table(:boards) do
      add :name, :string, null: false
      add :description, :text
      add :status, :board_status, null: false, default: "active"
      add :user_id, references(:users), null: false

      timestamps()
    end

    create index(:boards, [:user_id])
  end

  def down do
    drop table(:boards)

    BoardStatus.drop_type
  end
end
