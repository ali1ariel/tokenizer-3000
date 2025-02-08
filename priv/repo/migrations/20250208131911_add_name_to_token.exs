defmodule Tokenizer.Repo.Migrations.AddNameToToken do
  use Ecto.Migration

  def change do
    alter table(:tokens) do
      add :name, :string
    end
  end
end
