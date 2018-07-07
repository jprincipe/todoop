defmodule TodoopApi.UserSocket do
  use Phoenix.Socket
  import Guardian.Phoenix.Socket

  ## Channels
  channel("board:*", TodoopApi.BoardChannel)
  channel("task:*", TodoopApi.TaskChannel)

  ## Transports
  transport(:websocket, Phoenix.Transports.WebSocket)
  transport(:longpoll, Phoenix.Transports.LongPoll)

  def connect(%{"token" => token}, socket) do
    case authenticate(socket, TodoopApi.Guardian, token) do
      {:ok, authed_socket} ->
        {:ok, authed_socket}

      {:error, _} ->
        :error
    end
  end

  def connect(_params, _socket) do
    :error
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     TodoopApi.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(socket), do: "user_socket:#{socket.assigns.user_id}"
end
