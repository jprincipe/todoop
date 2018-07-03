defmodule TodoopData.ListService do
  use TodoopData, :data

  alias TodoopData.List

  def load_lists(user) do
    from(
      list in List,
      where: list.user_id == ^user.id,
      order_by: list.name,
      preload: [:tasks]
    )
    |> Repo.all
  end

  def load_list(user, list_id) do
    from(
      list in List,
      where: list.user_id == ^user.id,
      where: list.id == ^list_id,
      preload: [:tasks]
    )
    |> Repo.one
  end
end
