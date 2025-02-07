defmodule TokenizerWeb.UserController do
  use TokenizerWeb, :controller

  alias Tokenizer.Users
  alias Tokenizer.Users.User

  @doc "Lista todos os usuários"
  def index(conn, _params) do
    users = Users.list_users()
    render(conn, :index, users: users)
  end

  @doc "Retorna um usuário específico pelo ID"
  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, :show, user: user)
  end

  @doc "Cria um novo usuário"
  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  @doc "Atualiza um usuário existente"
  def update(conn, %{"id" => id, "user" => user_params}) do
    with %User{} = user <- Users.get_user!(id),
         {:ok, %User{} = updated_user} <- Users.update_user(user, user_params) do
      render(conn, "show.json", user: updated_user)
    else
      nil ->
        send_resp(conn, :not_found, "User not found")

      {:error, changeset} ->
        conn |> put_status(:unprocessable_entity) |> render("error.json", changeset: changeset)
    end
  end

  @doc "Deleta um usuário"
  def delete(conn, %{"id" => id}) do
    with %User{} = user <- Users.get_user!(id),
         {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    else
      nil -> send_resp(conn, :not_found, "User not found")
    end
  end
end
