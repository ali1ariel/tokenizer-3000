defmodule Tokenizer.Tokens do
  @moduledoc """
  The Tokens context.
  """

  import Ecto.Query, warn: false
  alias Tokenizer.Repo

  alias Tokenizer.Tokens.Token

  @doc """
  Returns the list of tokens.

  ## Examples

      iex> list_tokens()
      [%Token{}, ...]

  """
  def list_tokens do
    Repo.all(Token)
  end

  @doc """
  Gets a single token.

  Raises `Ecto.NoResultsError` if the Token does not exist.

  ## Examples

      iex> get_token!(123)
      %Token{}

      iex> get_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_token!(id), do: Repo.get!(Token, id)

  @doc """
  Creates a token.

  ## Examples

      iex> create_token(%{field: value})
      {:ok, %Token{}}

      iex> create_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_token(attrs \\ %{}) do
    %Token{}
    |> Token.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a token.

  ## Examples

      iex> update_token(token, %{field: new_value})
      {:ok, %Token{}}

      iex> update_token(token, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_token(%Token{} = token, attrs) do
    token
    |> Token.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a token.

  ## Examples

      iex> delete_token(token)
      {:ok, %Token{}}

      iex> delete_token(token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_token(%Token{} = token) do
    Repo.delete(token)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking token changes.

  ## Examples

      iex> change_token(token)
      %Ecto.Changeset{data: %Token{}}

  """
  def change_token(%Token{} = token, attrs \\ %{}) do
    Token.changeset(token, attrs)
  end

  alias Tokenizer.Tokens.TokenAssignment

  @doc """
  Returns the list of token_assignments.

  ## Examples

      iex> list_token_assignments()
      [%TokenAssignment{}, ...]

  """
  def list_token_assignments do
    Repo.all(TokenAssignment)
  end

  @doc """
  Gets a single token_assignment.

  Raises `Ecto.NoResultsError` if the Token assignment does not exist.

  ## Examples

      iex> get_token_assignment!(123)
      %TokenAssignment{}

      iex> get_token_assignment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_token_assignment!(id),
    do:
      Repo.get!(TokenAssignment, id)
      |> Repo.preload([:token, :user])

  @doc """
  Creates a token_assignment.

  ## Examples

      iex> create_token_assignment(%{field: value})
      {:ok, %TokenAssignment{}}

      iex> create_token_assignment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_token_assignment(attrs \\ %{}) do
    %TokenAssignment{}
    |> TokenAssignment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a token_assignment.

  ## Examples

      iex> update_token_assignment(token_assignment, %{field: new_value})
      {:ok, %TokenAssignment{}}

      iex> update_token_assignment(token_assignment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_token_assignment(%TokenAssignment{} = token_assignment, attrs) do
    token_assignment
    |> TokenAssignment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a token_assignment.

  ## Examples

      iex> delete_token_assignment(token_assignment)
      {:ok, %TokenAssignment{}}

      iex> delete_token_assignment(token_assignment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_token_assignment(%TokenAssignment{} = token_assignment) do
    Repo.delete(token_assignment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking token_assignment changes.

  ## Examples

      iex> change_token_assignment(token_assignment)
      %Ecto.Changeset{data: %TokenAssignment{}}

  """
  def change_token_assignment(%TokenAssignment{} = token_assignment, attrs \\ %{}) do
    TokenAssignment.changeset(token_assignment, attrs)
  end

  alias Tokenizer.Tokens.TokenUsageHistory

  @doc """
  Returns the list of tokens_usage_history.

  ## Examples

      iex> list_tokens_usage_history()
      [%TokenUsageHistory{}, ...]

  """
  def list_tokens_usage_history do
    Repo.all(TokenUsageHistory)
  end

  @doc """
  Gets a single token_usage_history.

  Raises `Ecto.NoResultsError` if the Token usage history does not exist.

  ## Examples

      iex> get_token_usage_history!(123)
      %TokenUsageHistory{}

      iex> get_token_usage_history!(456)
      ** (Ecto.NoResultsError)

  """
  def get_token_usage_history!(id),
    do:
      Repo.get!(TokenUsageHistory, id)
      |> Repo.preload([:token, :user])

  @doc """
  Creates a token_usage_history.

  ## Examples

      iex> create_token_usage_history(%{field: value})
      {:ok, %TokenUsageHistory{}}

      iex> create_token_usage_history(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_token_usage_history(attrs \\ %{}) do
    %TokenUsageHistory{}
    |> TokenUsageHistory.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a token_usage_history.

  ## Examples

      iex> update_token_usage_history(token_usage_history, %{field: new_value})
      {:ok, %TokenUsageHistory{}}

      iex> update_token_usage_history(token_usage_history, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_token_usage_history(%TokenUsageHistory{} = token_usage_history, attrs) do
    token_usage_history
    |> TokenUsageHistory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a token_usage_history.

  ## Examples

      iex> delete_token_usage_history(token_usage_history)
      {:ok, %TokenUsageHistory{}}

      iex> delete_token_usage_history(token_usage_history)
      {:error, %Ecto.Changeset{}}

  """
  def delete_token_usage_history(%TokenUsageHistory{} = token_usage_history) do
    Repo.delete(token_usage_history)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking token_usage_history changes.

  ## Examples

      iex> change_token_usage_history(token_usage_history)
      %Ecto.Changeset{data: %TokenUsageHistory{}}

  """
  def change_token_usage_history(%TokenUsageHistory{} = token_usage_history, attrs \\ %{}) do
    TokenUsageHistory.changeset(token_usage_history, attrs)
  end
end
