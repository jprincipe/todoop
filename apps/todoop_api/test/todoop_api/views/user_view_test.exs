defmodule TodoopApi.UserViewTest do
  use TodoopApi.ConnCase, async: true

  import Phoenix.View

  alias TodoopData.User

  test "renders user.json" do
    user = %User{id: 1, email: "foo@bar.com"}
    assert render(TodoopApi.UserView, "user.json", %{user: user}) == %{id: user.id, email: user.email}
  end
end
