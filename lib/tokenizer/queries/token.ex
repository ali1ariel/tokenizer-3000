defmodule Tokenizer.Queries.Token do
  @moduledoc """
    Centralização das queries de consulta mais complexas
  """
  import Ecto.Query
  alias Tokenizer.Tokens.Token
  alias Tokenizer.Tokens.TokenAssignment

  @doc """
    Busca um token disponível por meio do campo de disponibilidade do próprio token.
  """
  def search_available_token() do
    from(t in Token)
    |> where([t], t.available? == true)
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
end
