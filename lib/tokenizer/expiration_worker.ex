defmodule Tokenizer.ExpirationWorker do
  use GenServer
  alias Tokenizer.TokenManager

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    schedule_cleanup()
    {:ok, state}
  end

  def handle_info(:cleanup, state) do
    cleanup_expired_tokens()
    schedule_cleanup()
    {:noreply, state}
  end

  defp schedule_cleanup do
    Process.send_after(self(), :cleanup, 1_000)
  end

  # Rastreia o tokens expirados, então envia pra função de liberar.
  defp cleanup_expired_tokens do
    TokenManager.list_expired_assignments()
    |> Task.async_stream(&TokenManager.release_token(&1.token),
      max_concurrency: 5
    )
    |> Stream.run()
  end
end
