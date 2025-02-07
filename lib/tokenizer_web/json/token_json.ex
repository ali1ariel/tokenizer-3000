defmodule TokenizerWeb.TokenJSON do
  alias Tokenizer.Tokens.TokenUsageHistory
  alias Tokenizer.Users.User
  alias Tokenizer.Tokens.TokenAssignment
  alias Tokenizer.Tokens.Token

  @doc """
  Renderiza uma lista de tokens.
  """
  def index(%{tokens: tokens}) do
    %{data: for(token <- tokens, do: token(token))}
  end

  @doc """
  Renderiza um único usuário.
  """
  def show(%{token: token}) do
    %{data: token(token)}
  end

  @doc """
  Renderiza os dados de histórico do token, com o uso atual e todo o histórico anterior.
  """
  def history(%{history_data: %{token: token, history: history, current_state: assignment}}) do
    %{
      data: %{
        token: token(token),
        history: Enum.map(history, &token_usage_history/1),
        assignment: token_assignment(assignment)
      }
    }
  end

  @doc """
  Renderiza a utilização atual do token, com dados do token e do usuário que está com a posse.
  """
  def use_token(%{token_assignment: token_assignment}) do
    %{
      data: %{
        token_assignment: token_assignment(token_assignment)
      }
    }
  end

  @doc """
    Renderiza e possibilita a reutilização dos dados de token
  """
  def token(nil), do: nil

  def token(%Token{} = token) do
    %{
      id: token.id,
      inserted_at: token.inserted_at,
      updated_at: token.updated_at
    }
  end

  @doc """
    Renderiza e possibilita a reutilização dos dados de uso atual do token, com os dados de usuário e token pré-carregados.
  """
  def token_assignment(nil), do: nil

  def token_assignment(%TokenAssignment{} = token_assignment) do
    %{
      id: token_assignment.id,
      user: user(token_assignment.user),
      token: token(token_assignment.token),
      expires_at: token_assignment.expires_at,
      inserted_at: token_assignment.inserted_at,
      updated_at: token_assignment.updated_at
    }
  end

  @doc """
    Renderiza e possibilita a reutilização dos dados de histórico do token, com os dados de usuário e token pré-carregados em cada uma dos usos de token.
  """
  def token_usage_history(nil), do: nil

  def token_usage_history(%TokenUsageHistory{} = token_usage_history) do
    %{
      id: token_usage_history.id,
      user: user(token_usage_history.user),
      token: token(token_usage_history.token),
      expiration_reason: token_usage_history.expiration_reason,
      inserted_at: token_usage_history.inserted_at,
      updated_at: token_usage_history.updated_at
    }
  end

  @doc """
    Renderiza e possibilita a reutilização dos dados de usuário.
  """
  def user(nil), do: nil

  def user(%User{} = user) do
    %{
      id: user.id,
      nome: user.name,
      email: user.email,
      inserted_at: user.inserted_at,
      updated_at: user.updated_at
    }
  end
end
