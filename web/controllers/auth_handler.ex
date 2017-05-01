defmodule Book.AuthHandler do
  use Book.Web, :controller

  def unauthenticated(conn) do
    conn
    |> unauthenticated({})
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:unauthorized)
    |> render(Book.ErrorView, "unauthenticated.json")
  end
end
