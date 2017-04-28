defmodule Book.Repo.Migrations.AddIsActiveToContacts do
  use Ecto.Migration

  def change do
    alter table(:contacts) do
      add :is_active, :boolean, default: true
    end
  end
end
