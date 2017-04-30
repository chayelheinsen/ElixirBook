defmodule Book.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias Book.Repo
  alias Book.User

  def for_token(user = %User{}), do: { :ok, user.id }
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token(id), do: { :ok, Repo.get(User, id) }
  # def from_token(_), do: { :error, "Unknown resource type" }
end
