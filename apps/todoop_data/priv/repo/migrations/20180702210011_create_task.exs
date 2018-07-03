defmodule TodoopData.Repo.Migrations.CreateTask do
  use Ecto.Migration

  def up do
    TaskStatus.create_type

    create table(:tasks) do
      add :title, :string, null: false
      add :description, :text
      add :status, :task_status, null: false, default: "active"
      add :list_id, references(:lists), null: false

      timestamps()
    end

    create index(:tasks, [:list_id])
  end

  def down do
    drop table(:tasks)

    TaskStatus.drop_type
  end
end