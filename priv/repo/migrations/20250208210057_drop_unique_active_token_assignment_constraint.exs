defmodule Tokenizer.Repo.Migrations.DropUniqueActiveTokenAssignmentConstraint do
  use Ecto.Migration

  def change do
    drop unique_index(:token_assignments, [:token_id], name: :unique_active_token_assignment)
  end
end
