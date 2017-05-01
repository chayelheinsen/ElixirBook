require IEx
defmodule Book.ContactController do
  use Book.Web, :controller
  use Guardian.Phoenix.Controller

  alias Book.Contact

  plug Guardian.Plug.EnsureAuthenticated, [handler: Book.AuthHandler]

  def index(conn, %{"is_active" => active}, user, _claims) do
    contacts = Contact
    |> Contact.active_from_user(user.id, active == "true")
    |> Repo.all
    render(conn, "index.json", contacts: contacts)
  end

  def index(conn, %{"user_id" => user_id}, user, _claims) do
    cond do
      user.id == String.to_integer(user_id) ->
        contacts = Contact
        |> Contact.from_user(user_id)
        |> Repo.all
        render(conn, "index.json", contacts: contacts)
      true ->
        conn |> Book.AuthHandler.unauthenticated
    end
  end

  def index(conn, _params, _user, _claims), do: conn |> Book.AuthHandler.unauthenticated

  def create(conn, %{"contact" => contact_params}, user, _claims) do
    changeset = Contact.changeset(%Contact{}, contact_params)

    cond do
      user.id == changeset.changes.user_id ->
        case Repo.insert(changeset) do
          {:ok, contact} ->
            conn
            |> put_status(:created)
            |> put_resp_header("location", contact_path(conn, :show, contact))
            |> render("contact.json", contact: contact)
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(Book.ChangesetView, "error.json", changeset: changeset)
        end
      true ->
        conn |> Book.AuthHandler.unauthenticated
    end
  end

  def show(conn, %{"id" => id}, user, _claims) do
    contact = Repo.get!(Contact, id)

    cond do
      user.id == contact.user_id ->
        render(conn, "contact.json", contact: contact)
      true ->
        conn |> Book.AuthHandler.unauthenticated
    end
  end

  def update(conn, %{"id" => id, "contact" => contact_params}, user, _claims) do
    contact = Repo.get!(Contact, id)

    cond do
      user.id == contact.user_id ->
        changeset = Contact.changeset(contact, contact_params)

        case Repo.update(changeset) do
          {:ok, contact} ->
            render(conn, "contact.json", contact: contact)
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(Book.ChangesetView, "error.json", changeset: changeset)
        end
      true ->
        conn |> Book.AuthHandler.unauthenticated
    end
  end

  def delete(conn, %{"id" => id}, user, _claims) do
    contact = Repo.get!(Contact, id)

    cond do
      user.id == contact.user_id ->
        # Here we use delete! (with a bang) because we expect
        # it to always work (and if it does not, it will raise).
        Repo.delete!(contact)
        send_resp(conn, :no_content, "")
      true ->
        conn |> Book.AuthHandler.unauthenticated
    end
  end
end
