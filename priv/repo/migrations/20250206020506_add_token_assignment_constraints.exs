defmodule Tokenizer.Repo.Migrations.AddTokenAssignmentConstraints do
  use Ecto.Migration

  def change do
    create unique_index(:token_assignments, [:token_id], name: :unique_active_token_assignment)

    create unique_index(:token_assignments, [:user_id], name: :unique_active_user_assignment)
  end
end
