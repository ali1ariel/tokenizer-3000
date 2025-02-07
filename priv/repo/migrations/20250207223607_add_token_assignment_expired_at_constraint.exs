defmodule Tokenizer.Repo.Migrations.AddTokenAssignmentExpiredAtConstraint do
  use Ecto.Migration

  def change do
    create index(:token_assignments, [:expires_at])
  end
end
