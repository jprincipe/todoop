defmodule TodoopApi.UserViewTest do
  use TodoopApi.ConnCase, async: true

  import Phoenix.View

  test "renders user.json" do
    user = insert(:user)
    assert render(TodoopApi.UserView, "user.json", %{user: user}) == %{id: user.id, email: user.email}
  end
end
