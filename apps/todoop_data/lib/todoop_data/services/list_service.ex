defmodule TodoopData.ListService do
  use TodoopData, :data

  alias TodoopData.List

  def load_lists(user) do
    from(
      list in List,
      where: list.user_id == ^user.id,
      order_by: list.name,
      preload: [tasks: ^task_query()]
    )
    |> Repo.all
  end

  def load_list(user, list_id) do
    from(
      list in List,
      where: list.user_id == ^user.id,
      where: list.id == ^list_id,
      preload: [tasks: ^task_query()]
    )
    |> Repo.one
  end

  defp task_query(), do: from(t in TodoopData.Task, order_by: t.inserted_at)
end
