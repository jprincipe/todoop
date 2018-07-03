defmodule TodoopData.Repo.Migrations.CreateList do
  use Ecto.Migration

  def up do
    ListStatus.create_type

    create table(:lists) do
      add :name, :string, null: false
      add :description, :text
      add :status, :list_status, null: false, default: "active"
      add :user_id, references(:users), null: false

      timestamps()
    end

    create index(:lists, [:user_id])
  end

  def down do
    drop table(:lists)

    ListStatus.drop_type
  end
end
