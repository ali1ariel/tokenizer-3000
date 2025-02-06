defmodule Tokenizer.AssignmentRules do
  @moduledoc """
    Concentra todas as regras de gerenciamento dos tokens, como a atribuição e liberação de tokens.

    Responsabilidades:
    - Busca por tokens disponíveis
    - Atribui token a usuário
    - Libera o token para utilização
  """

  alias Tokenizer.Tokens.TokenAssignment
  alias Tokenizer.Tokens
  alias Tokenizer.Tokens.Token
  alias Tokenizer.Queries.Token, as: TokenQuery
  alias Tokenizer.Users
  alias Tokenizer.Repo

  @doc """
    Busca um token disponível para uso, retorna o primeiro que estiver com o status de disponível.
  """
  def get_available_token() do
    TokenQuery.search_available_token()
    |> Repo.all()
    |> then(fn [token] -> token end)
  end

  @doc """
    Atribui um token à um usuário, criando um relacionamento por meio da tabela TokenAssignment, e setando o campo de disponibilidade no token.
  """
  def assign_token(%{user_id: user_id}) do
    token = get_available_token()
    user = Users.get_user!(user_id)

    with {:ok, token_assignment} <-
           IO.inspect(Tokens.create_token_assignment(%{token_id: token.id, user_id: user.id}),
             label: "assignment"
           ) do
      set_token_unavailable(token)
      |> IO.inspect(label: "token unavailable")

      {:ok, token_assignment}
    end
  end

  @doc """
    Libera o token para reutilização, primeiro salva o histórico de uso, muda a disponibilidade no token e por fim exclui a associação com o usuário na tabela TokenAssignment.
  """
  def release_token(%Token{} = token) do
    [token_assignment] =
      TokenQuery.get_token_assignment_by_token_id(token.id)
      |> Repo.all()

    with {:ok, _} <-
           Tokens.create_token_usage_history(%{
             token_id: token_assignment.token_id,
             user_id: token_assignment.user_id
           }) do
      set_token_available(token)
      Tokens.delete_token_assignment(token_assignment)
    end
  end

  defp set_token_unavailable(%Token{} = token) do
    token
    |> Tokens.update_token(%{available?: false})
  end

  defp set_token_available(%Token{} = token) do
    token
    |> Tokens.update_token(%{available?: true})
  end
end
