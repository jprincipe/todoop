defmodule TodoopApi.UserView do
  use TodoopApi, :view

  def render("user.json", %{user: user, jwt: jwt}) do
    %{id: user.id, email: user.email, jwt: jwt}
  end
end
