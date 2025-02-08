defmodule Tokenizer.TokensTest do
  use Tokenizer.DataCase

  alias Tokenizer.Tokens

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(Tokenizer.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Tokenizer.Repo, {:shared, self()})

    # Obtém o PID do Worker e permite que ele acesse o banco
    worker_pid = start_supervised!(Tokenizer.ExpirationWorker)
    Ecto.Adapters.SQL.Sandbox.allow(Tokenizer.Repo, self(), worker_pid)

    {:ok, worker_pid: worker_pid}
  end

  describe "tokens" do
    alias Tokenizer.Tokens.Token

    import Tokenizer.TokensFixtures

    @invalid_attrs %{available?: nil}

    test "list_tokens/0 returns all tokens" do
      token = token_fixture()
      assert Tokens.list_tokens() == [token]
    end

    test "get_token!/1 returns the token with given id" do
      token = token_fixture()
      assert Tokens.get_token!(token.id) == token
    end

    test "create_token/1 with valid data creates a token" do
      valid_attrs = %{available?: true}

      assert {:ok, %Token{} = token} = Tokens.create_token(valid_attrs)
      assert token.available? == true
    end

    test "create_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tokens.create_token(@invalid_attrs)
    end

    test "update_token/2 with valid data updates the token" do
      token = token_fixture()
      update_attrs = %{available?: false}

      assert {:ok, %Token{} = token} = Tokens.update_token(token, update_attrs)
      assert token.available? == false
    end

    test "update_token/2 with invalid data returns error changeset" do
      token = token_fixture()
      assert {:error, %Ecto.Changeset{}} = Tokens.update_token(token, @invalid_attrs)
      assert token == Tokens.get_token!(token.id)
    end

    test "delete_token/1 deletes the token" do
      token = token_fixture()
      assert {:ok, %Token{}} = Tokens.delete_token(token)
      assert_raise Ecto.NoResultsError, fn -> Tokens.get_token!(token.id) end
    end

    test "change_token/1 returns a token changeset" do
      token = token_fixture()
      assert %Ecto.Changeset{} = Tokens.change_token(token)
    end
  end
end
