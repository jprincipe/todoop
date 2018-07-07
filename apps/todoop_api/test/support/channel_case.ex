defmodule TodoopApi.ChannelCase do
  @moduledoc """
  This module defines the test case to be used by
  channel tests.

  Such tests rely on `Phoenix.ChannelTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with channels
      use Phoenix.ChannelTest

      import Ecto.Query
      import TodoopData.Factory

      alias TodoopData.Repo

      def authed_socket(socket, user) do
        {:ok, token, _claims} = TodoopApi.Guardian.encode_and_sign(user)
        {:ok, authed_socket} = Guardian.Phoenix.Socket.authenticate(socket, TodoopApi.Guardian, token)

        authed_socket
      end

      # The default endpoint for testing
      @endpoint TodoopApi.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TodoopData.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(TodoopData.Repo, {:shared, self()})
    end

    :ok
  end
end
