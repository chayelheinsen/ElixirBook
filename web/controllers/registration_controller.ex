defmodule Book.RegistrationController do
  use Book.Web, :controller

  alias Book.Password

  plug Guardian.Plug.EnsureAuthenticated, [handler: Book.AuthHandler] when action in [:logout]
  plug :scrub_params, "user" when action in [:create, :login]

  def index(conn, _params) do
    users = User
    |> User.without_password
    |> Repo.all
    render(conn, "users.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)

    if changeset.valid? do
      case Password.generate_password_and_store_user(changeset) do
        {:ok, user} ->
          {new_conn, jwt, exp} = User.create_token(conn, user)
          new_conn
          |> put_status(:created)
          |> put_resp_header("authorization", "Bearer #{jwt}")
          |> put_resp_header("x-expires", "#{exp}")
          |> render("user.json", user: user, jwt: jwt, expiration: exp)

        {:error, changeset} ->
          conn
          |> render_error(changeset)
      end
    else
      conn
      |> render_error(changeset)
    end
  end

  def login(conn, %{"user" => user_params}) do
    user = if is_nil(user_params["username"]) do
      nil
    else
      Repo.get_by(User, username: user_params["username"])
    end

    user
    |> sign_in(user_params["password"], conn)
  end

  defp sign_in(user, _password, conn) when is_nil(user) do
    conn
    |> put_status(:unprocessable_entity)
    |> render("invalid_user.json")
  end

  defp sign_in(user, password, conn) when is_map(user) do
    cond do
      Comeonin.Bcrypt.checkpw(password, user.encrypted_password) ->
        {new_conn, jwt, exp} = User.create_token(conn, user)
        new_conn
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> put_resp_header("x-expires", "#{exp}")
        |> render("user.json", user: user, jwt: jwt, expiration: exp)
      true ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("invalid_user.json")
    end
  end

  @doc """
  Currently doesn't do anything useful. This sets up the required logic for logging out
  by calling Guardian.revoke!. View https://github.com/ueberauth/guardian#hooks
  to add a hook or GuardianDB to track/revoke tokens if this ever becoms needed.
  """
  def logout(conn, _params) do
    jwt = Guardian.Plug.current_token(conn)
    case Guardian.Plug.claims(conn) do
      {:ok, claims} ->
        Guardian.revoke!(jwt, claims)
        send_resp(conn, :no_content, "")
      {:error, _} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("logout_error.json")
    end
  end

  defp render_error(conn, changeset) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(Book.ChangesetView, "error.json", changeset: changeset)
  end
end
