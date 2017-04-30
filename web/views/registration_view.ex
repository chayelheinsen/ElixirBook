defmodule Book.RegistrationView do
  use Book.Web, :view

  def render("user.json", %{user: user, jwt: jwt, expiration: exp}) do
    %{id: user.id,
      username: user.username,
      jwt: %{
        token: jwt,
        expiration: exp
      }}
  end

  def render("invalid_user.json", _params) do
    %{error: "username or password is incorrect."}
  end

  def render("logout_error.json", _params) do
    %{error: "could not log out."}
  end
end
