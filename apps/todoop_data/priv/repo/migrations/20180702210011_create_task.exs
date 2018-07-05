defmodule TodoopData.Repo.Migrations.CreateTask do
  use Ecto.Migration

  def up do
    TaskStatus.create_type

    create table(:tasks) do
      add :title, :string, null: false
      add :description, :text
      add :status, :task_status, null: false, default: "active"
      add :board_id, references(:boards, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:tasks, [:board_id])
  end

  def down do
    drop table(:tasks)

    TaskStatus.drop_type
  end
end
