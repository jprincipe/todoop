defmodule TodoopUi.HomeController do
  use TodoopUi, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
