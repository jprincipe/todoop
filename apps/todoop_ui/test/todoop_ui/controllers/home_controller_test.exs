defmodule TodoopUi.HomeControllerTest do
  use TodoopUi.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Hello TodoopUi!"
  end
end
