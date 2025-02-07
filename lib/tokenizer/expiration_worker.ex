defmodule Tokenizer.ExpirationWorker do
  use GenServer
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
  end
end
