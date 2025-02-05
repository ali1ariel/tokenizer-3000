defmodule Tokenizer.TokensFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Tokenizer.Tokens` context.
  """

  @doc """
  Generate a token.
  """
  def token_fixture(attrs \\ %{}) do
    {:ok, token} =
      attrs
      |> Enum.into(%{
        available?: true
      })
      |> Tokenizer.Tokens.create_token()

    token
  end

  @doc """
  Generate a token_assignment.
  """
  def token_assignment_fixture(attrs \\ %{}) do
    {:ok, token_assignment} =
      attrs
      |> Enum.into(%{
        expires_at: ~N[2025-02-04 13:53:00],
        token_id: "7488a646-e31f-11e4-aace-600308960662"
      })
      |> Tokenizer.Tokens.create_token_assignment()

    token_assignment
  end

  @doc """
  Generate a token_usage_history.
  """
  def token_usage_history_fixture(attrs \\ %{}) do
    {:ok, token_usage_history} =
      attrs
      |> Enum.into(%{
        expiration_reason: 42,
        token_id: "7488a646-e31f-11e4-aace-600308960662"
      })
      |> Tokenizer.Tokens.create_token_usage_history()

    token_usage_history
  end
end
