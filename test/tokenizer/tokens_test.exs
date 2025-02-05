defmodule Tokenizer.TokensTest do
  use Tokenizer.DataCase

  alias Tokenizer.Tokens

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

  describe "token_assignments" do
    alias Tokenizer.Tokens.TokenAssignment

    import Tokenizer.TokensFixtures

    @invalid_attrs %{token_id: nil, expires_at: nil}

    test "list_token_assignments/0 returns all token_assignments" do
      token_assignment = token_assignment_fixture()
      assert Tokens.list_token_assignments() == [token_assignment]
    end

    test "get_token_assignment!/1 returns the token_assignment with given id" do
      token_assignment = token_assignment_fixture()
      assert Tokens.get_token_assignment!(token_assignment.id) == token_assignment
    end

    test "create_token_assignment/1 with valid data creates a token_assignment" do
      valid_attrs = %{
        token_id: "7488a646-e31f-11e4-aace-600308960662",
        expires_at: ~N[2025-02-04 13:53:00]
      }

      assert {:ok, %TokenAssignment{} = token_assignment} =
               Tokens.create_token_assignment(valid_attrs)

      assert token_assignment.token_id == "7488a646-e31f-11e4-aace-600308960662"
      assert token_assignment.expires_at == ~N[2025-02-04 13:53:00]
    end

    test "create_token_assignment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tokens.create_token_assignment(@invalid_attrs)
    end

    test "update_token_assignment/2 with valid data updates the token_assignment" do
      token_assignment = token_assignment_fixture()

      update_attrs = %{
        token_id: "7488a646-e31f-11e4-aace-600308960668",
        expires_at: ~N[2025-02-05 13:53:00]
      }

      assert {:ok, %TokenAssignment{} = token_assignment} =
               Tokens.update_token_assignment(token_assignment, update_attrs)

      assert token_assignment.token_id == "7488a646-e31f-11e4-aace-600308960668"
      assert token_assignment.expires_at == ~N[2025-02-05 13:53:00]
    end

    test "update_token_assignment/2 with invalid data returns error changeset" do
      token_assignment = token_assignment_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Tokens.update_token_assignment(token_assignment, @invalid_attrs)

      assert token_assignment == Tokens.get_token_assignment!(token_assignment.id)
    end

    test "delete_token_assignment/1 deletes the token_assignment" do
      token_assignment = token_assignment_fixture()
      assert {:ok, %TokenAssignment{}} = Tokens.delete_token_assignment(token_assignment)

      assert_raise Ecto.NoResultsError, fn ->
        Tokens.get_token_assignment!(token_assignment.id)
      end
    end

    test "change_token_assignment/1 returns a token_assignment changeset" do
      token_assignment = token_assignment_fixture()
      assert %Ecto.Changeset{} = Tokens.change_token_assignment(token_assignment)
    end
  end

  describe "tokens_usage_history" do
    alias Tokenizer.Tokens.TokenUsageHistory

    import Tokenizer.TokensFixtures

    @invalid_attrs %{token_id: nil, expiration_reason: nil}

    test "list_tokens_usage_history/0 returns all tokens_usage_history" do
      token_usage_history = token_usage_history_fixture()
      assert Tokens.list_tokens_usage_history() == [token_usage_history]
    end

    test "get_token_usage_history!/1 returns the token_usage_history with given id" do
      token_usage_history = token_usage_history_fixture()
      assert Tokens.get_token_usage_history!(token_usage_history.id) == token_usage_history
    end

    test "create_token_usage_history/1 with valid data creates a token_usage_history" do
      valid_attrs = %{
        token_id: "7488a646-e31f-11e4-aace-600308960662",
        expiration_reason: 42
      }

      assert {:ok, %TokenUsageHistory{} = token_usage_history} =
               Tokens.create_token_usage_history(valid_attrs)

      assert token_usage_history.token_id == "7488a646-e31f-11e4-aace-600308960662"
      assert token_usage_history.expiration_reason == 42
    end

    test "create_token_usage_history/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tokens.create_token_usage_history(@invalid_attrs)
    end

    test "update_token_usage_history/2 with valid data updates the token_usage_history" do
      token_usage_history = token_usage_history_fixture()

      update_attrs = %{
        token_id: "7488a646-e31f-11e4-aace-600308960668",
        expiration_reason: 43
      }

      assert {:ok, %TokenUsageHistory{} = token_usage_history} =
               Tokens.update_token_usage_history(token_usage_history, update_attrs)

      assert token_usage_history.token_id == "7488a646-e31f-11e4-aace-600308960668"
      assert token_usage_history.expiration_reason == 43
    end

    test "update_token_usage_history/2 with invalid data returns error changeset" do
      token_usage_history = token_usage_history_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Tokens.update_token_usage_history(token_usage_history, @invalid_attrs)

      assert token_usage_history == Tokens.get_token_usage_history!(token_usage_history.id)
    end

    test "delete_token_usage_history/1 deletes the token_usage_history" do
      token_usage_history = token_usage_history_fixture()
      assert {:ok, %TokenUsageHistory{}} = Tokens.delete_token_usage_history(token_usage_history)

      assert_raise Ecto.NoResultsError, fn ->
        Tokens.get_token_usage_history!(token_usage_history.id)
      end
    end

    test "change_token_usage_history/1 returns a token_usage_history changeset" do
      token_usage_history = token_usage_history_fixture()
      assert %Ecto.Changeset{} = Tokens.change_token_usage_history(token_usage_history)
    end
  end
end
