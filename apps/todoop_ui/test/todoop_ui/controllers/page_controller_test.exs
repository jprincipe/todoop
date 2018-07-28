defmodule TodoopUi.PageControllerTest do
  use TodoopUi.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Todoop"
  end
end
