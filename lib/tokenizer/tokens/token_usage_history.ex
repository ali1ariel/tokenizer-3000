defmodule Tokenizer.Tokens.TokenUsageHistory do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tokenizer.Tokens.Token
  alias Tokenizer.Users.User

  schema "tokens_usage_history" do
    field :expiration_reason, Ecto.Enum, values: [expired: 1, replaced: 2, removed: 3]
    belongs_to :token, Token, type: :binary_id
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(token_usage_history, attrs) do
    token_usage_history
    |> cast(attrs, [:token_id, :user_id, :expiration_reason])
    |> cast_assoc(:user)
    |> cast_assoc(:token)
    |> validate_required([:token_id, :user_id, :expiration_reason])
  end
end
