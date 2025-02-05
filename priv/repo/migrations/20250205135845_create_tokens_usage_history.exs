defmodule Tokenizer.Repo.Migrations.CreateTokensUsageHistory do
  use Ecto.Migration

  def change do
    create table(:tokens_usage_history) do
      add :token_id, :uuid
      add :expiration_reason, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:tokens_usage_history, [:user_id])
  end
end
