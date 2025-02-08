defmodule TokenizerWeb.TokenControllerTest do
  use TokenizerWeb.ConnCase

  alias Tokenizer.{Tokens, Users}
  import Tokenizer.TokensFixtures
  import Tokenizer.UsersFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lista todos os tokens", %{conn: conn} do
      token = token_fixture()

      conn = get(conn, ~p"/api/tokens")

      assert %{
               "data" => [
                 %{
                   "id" => id,
                   "inserted_at" => _,
                   "updated_at" => _
                 }
               ]
             } = json_response(conn, 200)

      assert id == token.id
    end

    test "retorna lista vazia quando não há tokens", %{conn: conn} do
      conn = get(conn, ~p"/api/tokens")
      assert %{"data" => []} = json_response(conn, 200)
    end
  end

  describe "show" do
    test "mostra token quando ID existe", %{conn: conn} do
      token = token_fixture()

      conn = get(conn, ~p"/api/tokens/#{token.id}")

      assert %{
               "data" => %{
                 "id" => id,
                 "inserted_at" => _,
                 "updated_at" => _
               }
             } = json_response(conn, 200)

      assert id == token.id
    end

    test "retorna erro quando ID não existe", %{conn: conn} do
      assert_error_sent 404, fn ->
        get(conn, ~p"/api/tokens/#{Ecto.UUID.generate()}")
      end
    end
  end

  describe "history" do
    test "mostra histórico do token quando ID existe", %{conn: conn} do
      %{token: token, history: history} = create_used_token_scenario()

      conn = get(conn, ~p"/api/tokens/#{token.id}/history")

      assert %{
               "data" => %{
                 "token" => %{"id" => token_id},
                 "history" => [%{"id" => history_id}]
               }
             } = json_response(conn, 200)

      assert token_id == token.id
      assert history_id == history.id
    end

    test "retorna erro quando token não existe", %{conn: conn} do
      conn = get(conn, ~p"/api/tokens/#{Ecto.UUID.generate()}/history")
      assert %{"error" => "Dados não encontrados"} = json_response(conn, 404)
    end
  end

  describe "use_token" do
    setup [:create_user]

    test "atribui token quando usuário existe", %{conn: conn, user: user} do
      token_fixture()

      conn = post(conn, ~p"/api/tokens/use", user_id: user.id)

      assert %{
               "data" => %{
                 "token_assignment" => %{
                   "user" => %{"id" => user_id},
                   "token" => %{"id" => _},
                   "expires_at" => _
                 }
               }
             } = json_response(conn, 200)

      assert user_id == user.id
    end

    test "retorna erro quando usuário não existe", %{conn: conn} do
      token_fixture()

      conn = post(conn, ~p"/api/tokens/use", user_id: -1)
      assert %{"error" => "Usuário não encontrado"} = json_response(conn, 404)
    end

    test "retorna erro quando não há tokens disponíveis", %{conn: conn, user: user} do
      conn = post(conn, ~p"/api/tokens/use", user_id: user.id)
      assert %{"error" => "Não há tokens disponíveis no momento"} = json_response(conn, 422)
    end
  end

  describe "clear_active" do
    test "libera todos os tokens ativos", %{conn: conn} do
      user = user_fixture()
      token = token_fixture()
      {:ok, _} = Tokenizer.TokenManager.assign_token(user)

      conn = delete(conn, ~p"/api/tokens/active")
      assert %{"message" => "Todos os tokens ativos foram liberados"} = json_response(conn, 200)

      updated_token = Tokens.get_token!(token.id)
      assert updated_token.available? == true
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
