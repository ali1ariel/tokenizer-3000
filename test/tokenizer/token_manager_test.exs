defmodule Tokenizer.TokenManagerTest do
  use Tokenizer.DataCase

  alias Tokenizer.{TokenManager, Users, Tokens}
  alias Tokenizer.Tokens.{Token, TokenAssignment}

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(Tokenizer.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Tokenizer.Repo, {:shared, self()})

    worker_pid = start_supervised!(Tokenizer.ExpirationWorker)
    Ecto.Adapters.SQL.Sandbox.allow(Tokenizer.Repo, self(), worker_pid)

    {:ok, worker_pid: worker_pid}
  end

  describe "get_available_token/0" do
    test "verifica se o tempo de execução dos testes de liberação está em 2 segundos" do
      assert Application.get_env(:tokenizer, :release_timer) == 2
    end

    test "retorna um token disponível" do
      {:ok, token} = Tokens.create_token()

      available_token = TokenManager.get_available_token()
      assert available_token.id == token.id
      assert available_token.available? == true
    end

    test "não retorna token indisponível" do
      {:ok, _token} = Tokens.create_token(%{available?: false})

      assert TokenManager.get_available_token() == nil
    end
  end

  describe "assign_token/1" do
    setup do
      {:ok, user} = Users.create_user(%{name: "Teste", email: "teste@teste.com"})
      {:ok, token} = Tokens.create_token()

      %{user: user, token: token}
    end

    test "atribui token para usuário com sucesso, verifica se o token se torna indisponível", %{
      user: user,
      token: token
    } do
      {:ok, assignment} = TokenManager.assign_token(user)

      assert assignment.user_id == user.id
      assert assignment.token_id == token.id
      assert not is_nil(assignment.expires_at)

      updated_token = Tokens.get_token!(token.id)
      assert updated_token.available? == false
    end

    test "falha ao atribuir token quando usuário não existe" do
      result = TokenManager.assign_token(%{id: -1})
      assert result == {:error, :not_found}
    end
  end

  describe "release_token/2" do
    setup do
      {:ok, user} = Users.create_user(%{name: "Teste", email: "teste@teste.com"})
      {:ok, token} = Tokens.create_token()
      {:ok, assignment} = TokenManager.assign_token(user)
      token = Tokens.get_token!(token.id)

      %{user: user, token: token, assignment: assignment}
    end

    test "libera token com sucesso", %{token: token} do
      TokenManager.release_token(token)

      # Verifica se o token está disponível novamente
      updated_token = Tokens.get_token!(token.id)
      assert updated_token.available? == true

      # Verifica se a atribuição foi removida
      assert Repo.all(TokenAssignment) == []

      # Verifica se foi criado histórico
      [history] = Repo.all(Tokenizer.Tokens.TokenUsageHistory)
      assert history.token_id == token.id
      assert history.expiration_reason == :expired
    end

    test "retorna erro quando token não existe" do
      non_existent_token = %Token{id: Ecto.UUID.generate()}

      assert {:error, :not_found} = TokenManager.release_token(non_existent_token)
    end
  end

  describe "list_token_history/1" do
    setup do
      {:ok, user} = Users.create_user(%{name: "Teste", email: "teste@teste.com"})
      {:ok, token} = Tokens.create_token()
      {:ok, _assignment} = TokenManager.assign_token(user)
      TokenManager.release_token(token)

      %{user: user, token: token}
    end

    test "retorna histórico do token", %{token: token} do
      result = TokenManager.list_token_history(token.id)

      assert %{token: _, history: [history], current_state: nil} = result
      assert history.token_id == token.id
      assert history.expiration_reason == :expired
    end

    test "retorna erro para token inexistente" do
      result = TokenManager.list_token_history(Ecto.UUID.generate())
      assert result == {:error, :not_found}
    end
  end

  describe "set_all_tokens_available/0" do
    setup do
      {:ok, user} = Users.create_user(%{name: "Teste", email: "teste@teste.com"})
      {:ok, token1} = Tokens.create_token()
      {:ok, token2} = Tokens.create_token()

      {:ok, _} = TokenManager.assign_token(user)

      %{user: user, tokens: [token1, token2]}
    end

    test "libera todos os tokens ativos" do
      TokenManager.set_all_tokens_available()

      tokens = Tokens.list_tokens()
      assert Enum.all?(tokens, & &1.available?)
      assert Repo.all(TokenAssignment) == []
    end
  end

  describe "expiração automática" do
    @tag :integration
    test "token é liberado automaticamente após 2 segundos (tempo para testes)" do
      {:ok, user} = Users.create_user(%{name: "Teste", email: "teste@teste.com"})
      {:ok, token} = Tokens.create_token()

      {:ok, _assignment} =
        TokenManager.assign_token(user)

      updated_token = Tokens.get_token!(token.id)
      assert updated_token.available? == false

      # Aguarda 3 segundos, pois o tempo de liberação do token em testes, é 2.
      Process.sleep(3_000)

      # Verifica se o token foi liberado
      updated_token = Tokens.get_token!(token.id)
      assert updated_token.available? == true

      # Verifica se a atribuição foi removida
      assert Repo.all(TokenAssignment) == []

      # Verifica se foi criado histórico
      [history] = Repo.all(Tokenizer.Tokens.TokenUsageHistory)
      assert history.token_id == token.id
      assert history.expiration_reason == :expired
    end
  end
end
