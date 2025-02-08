defmodule Tokenizer.ExpirationWorker do
  use GenServer
  alias Ecto.NoResultsError
  alias Tokenizer.Tokens
  alias Tokenizer.TokenManager

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_info({:expire_token, token_id}, state) do
    token = Tokens.get_token!(token_id)
    TokenManager.release_token(token)
    {:noreply, state}
  rescue
    _e in NoResultsError ->
      IO.inspect(
        "O token #{token_id} não foi encontrado, provavelmente esse é um ambiente de testes."
      )

      {:noreply, state}
  end
end
