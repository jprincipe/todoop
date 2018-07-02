defmodule TodoopApi.UserView do
  use TodoopApi, :view

  def render("user.json", %{user: user}) do
    %{id: user.id, email: user.email}
  end

  def render("token.json", %{token: token}) do
    %{token: token}
  end
end
