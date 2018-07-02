defmodule TodoopApi.UserView do
  use TodoopApi, :view

  def render("show.json", %{user: user}) do
    %{data: render_one(user, TodoopApi.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, email: user.email}
  end
end
