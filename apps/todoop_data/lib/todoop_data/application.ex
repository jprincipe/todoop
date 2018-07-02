defmodule TodoopData.Application do
  @moduledoc """
  The TodoopData Application Service.

  The todoop_data system business domain lives in this application.

  Exposes API to clients such as the `TodoopDataWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link(
      [
        supervisor(TodoopData.Repo, [])
      ],
      strategy: :one_for_one,
      name: TodoopData.Supervisor
    )
  end
end
