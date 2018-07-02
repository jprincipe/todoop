defmodule TodoopApi.ErrorViewTest do
  use TodoopApi.ConnCase, async: true

  import Phoenix.View

  alias TodoopData.User

  test "renders 404.json" do
    assert render(TodoopApi.ErrorView, "404.json", []) == %{errors: %{detail: "not found"}}
  end

  test "renders 422.json" do
    changeset = User.registration_changeset(%User{})

    assert render(TodoopApi.ErrorView, "422.json", %{changeset: changeset}) == %{errors: %{email: ["can't be blank"]}}
  end

  test "render 500.json" do
    assert render(TodoopApi.ErrorView, "500.json", []) == %{errors: %{detail: "internal server error"}}
  end

  test "render any other" do
    assert render(TodoopApi.ErrorView, "505.json", []) == %{errors: %{detail: "internal server error"}}
  end
end
