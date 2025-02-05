defmodule Tokenizer.Tokens.TokenAssignment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tokenizer.Tokens.Token
  alias Tokenizer.Users.User

  schema "token_assignments" do
    field :expires_at, :utc_datetime

    belongs_to :token, Token, type: :binary_id
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(token_assignment, attrs) do
    token_assignment
    |> cast(attrs, [:token_id, :user_id, :expires_at])
    |> cast_assoc(:user)
    |> cast_assoc(:token)
    |> validate_required([:token_id, :user_id])
  end
end
