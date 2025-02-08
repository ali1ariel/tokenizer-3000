defmodule TokenizerSimulator.TesteLoop do
  alias Ecto.Changeset
  alias Tokenizer.{Users, Tokens, TokenManager, Repo}

  def iniciar do
    Enum.each(1..5, fn _ -> criar_token() end)

    Enum.each(1..10, fn _ ->
      criar_usuario()
    end)

    executar_loop()
  end

  defp executar_loop do
    usuario = Repo.all(Users.User) |> Enum.random()

    case TokenManager.assign_token(usuario) do
      {:error, _} ->
        IO.inspect("Erro ao atribuir token para #{usuario.name}")

      response ->
        print_assign_response(response)
    end

    3000..7000
    |> Enum.random()
    |> Process.sleep()

    executar_loop()
  end

  def criar_usuario() do
    {:ok, user} = Users.create_user(%{name: Faker.Person.name(), email: Faker.Internet.email()})

    IO.inspect("O usuário #{user.name} foi criado com sucesso!")
    user
  end

  def criar_token() do
    case Tokens.create_token() do
      {:ok, token} ->
        IO.inspect("O token #{token.name} foi criado com sucesso!")
        nil

      {:error, %Changeset{} = changeset} ->
        IO.inspect("O token não pode ser criado, motivo: #{inspect(changeset.errors)}")
        nil
    end
  end

  defp print_assign_response({:ok, assignment}) do
    "token: #{assignment.token.name} - #{assignment.token.id}, usuário: #{assignment.user.name}, agora: #{Timex.now()}, liberação: #{assignment.expires_at}"
    |> IO.inspect()
  end
end
