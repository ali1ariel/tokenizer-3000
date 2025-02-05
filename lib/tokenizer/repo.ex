defmodule Tokenizer.Repo do
  use Ecto.Repo,
    otp_app: :tokenizer,
    adapter: Ecto.Adapters.Postgres
end
