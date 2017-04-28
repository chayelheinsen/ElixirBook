defmodule Book.ContactView do
  use Book.Web, :view

  def render("index.json", %{contacts: contacts}) do
    render_many(contacts, Book.ContactView, "contact.json")
  end

  def render("show.json", %{contact: contact}) do
    render_one(contact, Book.ContactView, "contact.json")
  end

  def render("contact.json", %{contact: contact}) do
    %{id: contact.id,
      name: contact.name,
      phone_number: contact.phone_number}
  end
end
