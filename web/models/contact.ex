defmodule Book.Contact do
  use Book.Web, :model

  schema "contacts" do
    field :name, :string
    field :phone_number, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :phone_number])
    |> validate_required([:name, :phone_number])
    |> validate_length(:name, min: 1)
    |> validate_length(:phone_number, min: 10)
  end
end
