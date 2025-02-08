defmodule Tokenizer.Queries.Token do
  @moduledoc """
    Centralização das queries de consulta mais complexas
  """
  import Ecto.Query
  alias Tokenizer.Tokens.Token
  alias Tokenizer.Tokens.TokenAssignment
  alias Tokenizer.Tokens.TokenUsageHistory

  @doc """
    Lista todos os tokens ativos por meio do campo de disponibilidade do próprio token.
  """
  def list_active_tokens() do
    from(t in Token)
    |> where([t], t.available? == false)
  end

  @doc """
    Lista todos os tokens disponíveis por meio do campo de disponibilidade do próprio token.
  """
  def list_available_tokens() do
    from(t in Token)
    |> where([t], t.available? == true)
  end

  @doc """
    Busca um token disponível por meio do campo de disponibilidade do próprio token.
  """
  def search_available_token() do
    list_available_tokens()
    |> limit(1)
  end

  @doc """
  Busca um token disponível verificando diretamente nas atribuições ativas.
  Retorna um token que não possui atribuição ativa ou expirada.
  """
  def deep_search_available_token do
    from t in Token,
      left_join: ta in TokenAssignment,
      on: ta.token_id == t.id and ta.expires_at > fragment("CURRENT_TIMESTAMP"),
      where: is_nil(ta.id),
      limit: 1
  end

  @doc """
    Retorna a atribuição que já existe pro token citado.
  """
  def get_token_assignment_by_token_id(token_id) do
    from(t in TokenAssignment)
    |> where([t], t.token_id == ^token_id)
    |> preload([:token, :user])
  end

  @doc """
    Seleciona o token mais antigo ainda não expirado.
  """
  def oldest_active do
    from(ta in TokenAssignment,
      where: ta.expires_at > fragment("NOW()"),
      order_by: [asc: ta.inserted_at],
      limit: 1
    )
  end

  @doc """
    Busca um token disponível por meio do campo de disponibilidade do próprio token.
  """
  def list_token_history(t_id) do
    from(tus in TokenUsageHistory)
    |> where([tus], tus.token_id == ^t_id)
    |> preload([:token, :user])
  end

  def find_token_by_pokemon_name(pokemon) do
    Token
    |> where(name: ^pokemon)
  end
end
