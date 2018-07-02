defmodule TodoopApi.UserViewTest do
  use TodoopApi.ConnCase, async: true

  import Phoenix.View

  alias TodoopData.User

  test "renders user.json" do
    user = %User{id: 1, email: "foo@bar.com"}
    jwt = "abcdefg"
    assert render(TodoopApi.UserView, "user.json", %{user: user, jwt: jwt}) == %{id: user.id, email: user.email, jwt: jwt}
  end
end
