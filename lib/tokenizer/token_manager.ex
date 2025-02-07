defmodule Tokenizer.TokenManager do
  @moduledoc """
    Concentra todas as regras de gerenciamento dos tokens, como a atribuição e liberação de tokens.

    Responsabilidades:
    - Busca por tokens disponíveis
    - Atribui token a usuário
    - Libera o token para utilização
  """

  alias Ecto.NoResultsError
  alias Tokenizer.Tokens
  alias Tokenizer.Tokens.Token
  alias Tokenizer.Queries.Token, as: TokenQueries
  alias Tokenizer.Users
  alias Tokenizer.Repo

  @doc """
    Busca um token disponível para uso, retorna o primeiro que estiver com o status de disponível.
  """
  def get_available_token() do
    TokenQueries.search_available_token()
    |> Repo.one()
  end

  @doc """
    Atribui um token à um usuário, criando um relacionamento por meio da tabela TokenAssignment, e setando o campo de disponibilidade no token.
  """
  def assign_token(%{id: user_id}) do
    token = get_available_token()
    user = Users.get_user!(user_id)

    with {:ok, token_assignment} <-
           Tokens.create_token_assignment(%{token_id: token.id, user_id: user.id}) do
      set_token_active(token)

      {:ok, token_assignment |> Repo.preload([:user, :token])}
    end
  rescue
    _ in NoResultsError -> {:error, :not_found}
    _ -> {:error, :not_available}
  end

  @doc """
    Libera o token para reutilização, primeiro salva o histórico de uso, muda a disponibilidade no token e por fim exclui a associação com o usuário na tabela TokenAssignment.
  """
  def release_token(%Token{} = token, reason \\ :expired) do
    [token_assignment] =
      TokenQueries.get_token_assignment_by_token_id(token.id)
      |> Repo.all()

    with {:ok, _} <-
           Tokens.create_token_usage_history(%{
             token_id: token_assignment.token_id,
             user_id: token_assignment.user_id,
             expiration_reason: reason
           }) do
      set_token_available(token)
      Tokens.delete_token_assignment(token_assignment)
    end
  rescue
    _m in MatchError ->
      {:error, :not_found}
  end

  def list_token_history(token_id) do
    token = Tokens.get_token!(token_id)

    history =
      TokenQueries.list_token_history(token_id)
      |> Repo.all()

    current_state =
      TokenQueries.get_token_assignment_by_token_id(token_id)
      |> Repo.one()

    %{token: token, history: history, current_state: current_state}
  rescue
    _ in NoResultsError -> {:error, :not_found}
    _ -> {:error, :not_available}
  end

  def set_all_tokens_available() do
    TokenQueries.list_active_tokens()
    |> Repo.all()
    |> IO.inspect(label: "all")
    |> Stream.map(fn t -> release_token(t, :removed) end)
    |> Stream.run()
  end

  defp set_token_active(%Token{} = token) do
    token
    |> Tokens.update_token(%{available?: false})
  end

  defp set_token_available(%Token{} = token) do
    token
    |> Tokens.update_token(%{available?: true})
  end
end
