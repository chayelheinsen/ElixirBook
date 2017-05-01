defmodule Book.Contact do
  use Book.Web, :model

  schema "contacts" do
    field :name, :string
    field :phone_number, :string
    field :is_active, :boolean, default: true
    belongs_to :user, Book.User

    timestamps()
  end

  @required_fields ~w(name phone_number user_id)
  @optional_fields ~w(is_active)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required([:name, :phone_number, :user_id])
    |> validate_length(:name, min: 1)
    |> validate_length(:phone_number, min: 10)
    |> foreign_key_constraint(:user_id, name: :contacts_user_id_fkey, message: "does not exist")
  end

  def active(query, is_active) do
    from c in query,
    where: c.is_active == ^is_active,
    select: c
  end

  def from_user(query, user_id) do
    from c in query,
    where: c.user_id == ^user_id,
    select: c
  end

  def active_from_user(query, user_id, is_active) do
    from c in query,
    where: c.is_active == ^is_active,
    where: c.user_id == ^user_id,
    select: c
  end
end
