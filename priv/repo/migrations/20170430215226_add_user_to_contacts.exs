defmodule Book.Repo.Migrations.AddUserToContacts do
  use Ecto.Migration

  def change do
    alter table(:contacts) do
      add :user_id, references(:users)
    end
  end
end
