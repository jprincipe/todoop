defmodule TodoopApi.ListController do
  use TodoopApi, :controller

  alias TodoopApi.Guardian
  alias TodoopData.List
  alias TodoopData.ListService

  plug(:scrub_params, "list" when action in [:create, :update])

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    lists = ListService.load_lists(user)

    render(conn, "index.json", lists: lists)
  end

  def show(conn, %{"id" => list_id}) do
    user = Guardian.Plug.current_resource(conn)
    list = ListService.load_list(user, list_id)

    render(conn, "show.json", list: list)
  end

  def create(conn, %{"list" => list_params}) do
    user = Guardian.Plug.current_resource(conn)

    %List{}
    |> List.changeset(list_params)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
    |> case do
      {:ok, list} ->
        list = Repo.preload(list, [:tasks])

        conn
        |> put_status(:created)
        |> render("show.json", list: list)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TodoopApi.ErrorView, "422.json", changeset: changeset)
    end
  end

  def update(conn, %{"id" => list_id, "list" => list_params}) do
    conn
    |> Guardian.Plug.current_resource()
    |> ListService.load_list(list_id)
    |> List.changeset(list_params)
    |> Repo.update()
    |> case do
      {:ok, list} ->
        list = Repo.preload(list, [:tasks])

        conn
        |> put_status(:updated)
        |> render("show.json", list: list)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TodoopApi.ErrorView, "422.json", changeset: changeset)
    end
  end
end
