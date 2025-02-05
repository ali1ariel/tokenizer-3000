defmodule Tokenizer.Repo.Migrations.CreateTokenAssignments do
  use Ecto.Migration

  def change do
    create table(:token_assignments) do
      add :token_id, references(:tokens, type: :binary_id, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :nothing)
      add :expires_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create index(:token_assignments, [:user_id])
  end
end
