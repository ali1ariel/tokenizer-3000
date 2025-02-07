defmodule TokenizerWeb.TokenController do
  alias Tokenizer.TokenManager
  alias Tokenizer.Tokens
  use TokenizerWeb, :controller

  @doc """
  lista todos os tokens cadastrados no sistema.
  """
  def index(conn, _) do
    tokens = Tokens.list_tokens()

    conn
    |> render(:index, tokens: tokens)
  end

  @doc """
  Busca um token específico no sistema.
  """
  def show(conn, %{"id" => id}) do
    token = Tokens.get_token!(id)

    conn
    |> render(:show, token: token)
  end

  @doc """
  Busca todo o histórico de uso de um token no sistema, e seus usuários que já foram vinculados à ele.
  """
  def history(conn, %{"id" => id}) do
    history =
      TokenManager.list_token_history(id)

    conn
    |> render(:history, history_data: history)
  end

  @doc """
  Vincula um token a um usuário fornecido.
  """
  def use_token(conn, %{"user_id" => user_id}) do
    case TokenManager.assign_token(%{user_id: user_id}) do
      {:ok, token} ->
        conn
        |> render(:use_token, token_assignment: token)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Usuário não encontrado"})

      {:error, :not_available} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Não há tokens disponíveis no momento"})
    end
  end

  @doc """
  libera todos os tokens indisponíveis, criando o respectivo histórico dessa execução.
  """
  def clear_active(conn, _) do
    TokenManager.set_all_tokens_available()

    conn
    |> json(%{message: "Todos os tokens ativos foram liberados"})
  end
end
