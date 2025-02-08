defmodule Tokenizer.TokensFixtures do
  @moduledoc """
  Helpers para criar entidades de teste via contexto Tokenizer.Tokens.
  """

  alias Tokenizer.Tokens

  @doc """
  Gera um token para testes.
  """
  def token_fixture(attrs \\ %{}) do
    {:ok, token} =
      attrs
      |> Enum.into(%{
        available?: true
      })
      |> Tokens.create_token()

    token
  end

  @doc """
  Gera um token_assignment para testes.

  Requer um token e um usuário, criando-os se não fornecidos.
  """
  def token_assignment_fixture(attrs \\ %{}) do
    # Cria um usuário se não fornecido
    user =
      attrs[:user] ||
        Tokenizer.UsersFixtures.user_fixture()

    # Cria um token se não fornecido
    token =
      attrs[:token] ||
        token_fixture()

    {:ok, token_assignment} =
      attrs
      |> Enum.into(%{
        token_id: token.id,
        user_id: user.id,
        expires_at: DateTime.utc_now() |> DateTime.add(120, :second)
      })
      |> Tokens.create_token_assignment()

    # Atualiza o status do token
    Tokens.update_token(token, %{available?: false})

    # Retorna assignment com as associações carregadas
    %{token_assignment | token: token, user: user}
  end

  @doc """
  Gera um registro de histórico de uso de token para testes.

  Requer um token e um usuário, criando-os se não fornecidos.
  """
  def token_usage_history_fixture(attrs \\ %{}) do
    # Cria um usuário se não fornecido
    user =
      attrs[:user] ||
        Tokenizer.UsersFixtures.user_fixture()

    # Cria um token se não fornecido
    token =
      attrs[:token] ||
        token_fixture()

    {:ok, token_usage_history} =
      attrs
      |> Enum.into(%{
        token_id: token.id,
        user_id: user.id,
        expiration_reason: :expired
      })
      |> Tokens.create_token_usage_history()

    # Retorna histórico com as associações carregadas
    %{token_usage_history | token: token, user: user}
  end

  @doc """
  Helper para criar um cenário completo de teste com token usado e expirado.
  """
  def create_used_token_scenario do
    user = Tokenizer.UsersFixtures.user_fixture()
    token = token_fixture()

    # Cria atribuição
    assignment =
      token_assignment_fixture(%{
        user: user,
        token: token
      })

    # Cria histórico
    history =
      token_usage_history_fixture(%{
        user: user,
        token: token
      })

    %{
      user: user,
      token: token,
      assignment: assignment,
      history: history
    }
  end
end
