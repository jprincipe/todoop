defmodule TodoopData do
  @moduledoc """
  TodoopData keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def data do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      alias Ecto.Changeset
      alias Ecto.Multi
      alias TodoopData.Repo
    end
  end

  @doc "When used, dispatch to the appropriate controller/view/etc."
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  Postgrex.Types.define(TodoopData.PostgresTypes, [] ++ Ecto.Adapters.Postgres.extensions(), json: Jason)
end
