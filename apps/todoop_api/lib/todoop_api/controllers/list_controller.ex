defmodule TodoopApi.ListController do
  use TodoopApi, :controller

  alias TodoopApi.Guardian
  alias TodoopData.List
  alias TodoopData.ListService

  plug(:scrub_params, "list" when action in [:create, :update])
  plug(:load_list when action in [:show, :update, :delete])

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    lists = ListService.load_lists(user)

    render(conn, "index.json", lists: lists)
  end

  def show(conn, %{"id" => _list_id}) do
    render(conn, "show.json", list: conn.assigns.list)
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

  def update(conn, %{"id" => _list_id, "list" => list_params}) do
    conn.assigns.list
    |> List.changeset(list_params)
    |> Repo.update()
    |> case do
      {:ok, list} ->
        list = Repo.preload(list, [tasks: ListService.task_query()])

        conn
        |> put_status(:ok)
        |> render("show.json", list: list)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TodoopApi.ErrorView, "422.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => _list_id}) do
    case Repo.delete(conn.assigns.list) do
      {:ok, _} ->
        send_resp(conn, :no_content, "")

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TodoopApi.ErrorView, "422.json", changeset: changeset)
    end
  end

  defp load_list(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    list_id = conn.params["id"]

    case ListService.load_list(user, list_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(TodoopApi.ErrorView, "404.json")
        |> halt

      list ->
        assign(conn, :list, list)
    end
  end
end
