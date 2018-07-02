defmodule TodoopApi.ErrorView do
  use TodoopApi, :view

  def render("401.json", _assigns) do
    %{errors: %{detail: "unauthorized"}}
  end

  def render("404.json", _assigns) do
    %{errors: %{detail: "not found"}}
  end

  def render("422.json", %{changeset: changeset}) do
    %{errors: errors(changeset)}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: "internal server error"}}
  end

  def template_not_found(_template, assigns) do
    render("500.json", assigns)
  end

  defp errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn
      {msg, opts} -> String.replace(msg, "%{count}", to_string(opts[:count]))
      msg -> msg
    end)
  end
end
