defmodule TodoopApi.UserViewTest do
  use TodoopApi.ConnCase, async: true

  import Phoenix.View

  alias TodoopData.User

  test "renders show.json" do
    user = %User{id: 1, email: "foo@bar.com"}
    assert render(TodoopApi.UserView, "show.json", %{user: user}) == %{data: %{id: 1, email: "foo@bar.com"}}
  end

  test "renders user.json" do
    user = %User{id: 1, email: "foo@bar.com"}
    assert render(TodoopApi.UserView, "user.json", %{user: user}) == %{id: 1, email: "foo@bar.com"}
  end
end
