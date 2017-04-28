defmodule Book.PageController do
  use Book.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
