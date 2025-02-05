defmodule Tokenizer.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :available?, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
