# Sistema de Gerenciamento de Tokens - Tokenizer 3000

Seu melhor amigo no gerenciamento de tokens chegou! Esse projeto implementa um sistema para gerenciar tokens com tempo de expiração automática. Aprecie e implemente já na sua empresa!

## Como rodar o projeto

Antes de começar, você vai precisar ter instalado:
- Elixir > 1.14
- PostgreSQL

Siga esses passos:

1. Clone o projeto
2. Configure o banco no `config/dev.exs`
3. Instale as dependências:
```bash
mix deps.get
```

4. Prepare o banco:
```bash
mix ecto.setup
```

5. Rode o servidor:
```bash
mix phx.server
```

O servidor vai estar rodando em `localhost:4000`

## API
### Tokens
- `GET /api/tokens` → Lista todos os tokens.
- `GET /api/tokens/:id` → Dados de um token específico.
- `GET /api/tokens/:id/history` → Histórico de uso.
- `POST /api/tokens/use` → Usar um token.  
  **Body (JSON):**
  ```json
  {
    "user_id": "string"
  }
- `DELETE /api/tokens/active` -> Libera todos os tokens ativos

### Usuários
- `GET /api/users` -> Lista os usuários
- `POST /api/users` -> Cria usuário
  **Body (JSON):**
  ```json
  {
    "name": "string",
    "email": "string"
  }
- `GET /api/users/:id` -> Dados do usuário

## Testes

Rode os testes com:
```bash
mix test
```

Se quiser testar o sistema em uso contínuo, pode usar o simulador:
```elixir
# No console do IEx
TokenizerSimulator.TesteLoop.iniciar()
```
ou (já está nos alias do .iex.exs)
```elixir
# No console do IEx
Simulator.iniciar_loop()
```

## O que o sistema faz

- Mantém até 100 tokens ativos.
- Cada token é único (ID e nome).
- Cada token tem um nome interno para acompanhamento que o usuário não tem acesso.
- Tokens expiram em 2 minutos, mas podendo ser alterado por variável de ambiente.
- Quando precisa de um novo token e já tem 100 em uso, libera o mais antigo
- Guarda todo o histórico de uso
- Identifica quem está usando cada token

## Um dia implementarei

- Paginação para o histórico de utilização dos tokens.
- Redocumentar o contexto de Users e o Controller de user.

----

Para entender melhor a arquitetura e as decisões técnicas, não se acanhe, dê uma olhada no `architecture.md`.