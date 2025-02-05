# 🔐 Tokenizer 3000 - Arquitetura do Sistema
Esse documento reune informações básicas de arquitetura do projeto, como layout de tabelas, algumas decisões de implementação e outras especificidades do sistema para quem quer se aprofundar mais no funcionamento.

## Stack Tecnológico

### Backend
- **Linguagem**: Elixir
- **Framework Web**: Phoenix
- **Banco de Dados**: PostgreSQL

## Arquitetura de Dados

### Diagrama ER

```mermaid
erDiagram
    USERS {
        UUID id PK
        STRING name
        STRING email
    }
    
    TOKENS {
        UUID id PK
        BOOLEAN available?
    }
    
    TOKEN_ASSIGNMENTS {
        UUID id PK
        UUID token_id FK
        UUID user_id FK
        DATETIME assigned_at
        DATETIME expires_at
    }
    
    TOKEN_USAGE_HISTORY {
        UUID id PK
        UUID token_id FK
        UUID user_id FK
        DATETIME expired_at
        ENUM expiration_reason
    }

    USERS ||--o{ TOKEN_ASSIGNMENTS : possui
    USERS ||--o{ TOKEN_USAGE_HISTORY : utilizou
    TOKENS ||--o{ TOKEN_ASSIGNMENTS : atribuido 
    TOKENS ||--o{ TOKEN_USAGE_HISTORY : lembra
```


## Implementação (Reorganizar depois)

### Campo 'available?' em tokens
1. Foi adicionado um campo de disponibilidade no token, quando ele é atribuido, esse campo deve ser passado para false, quando expira o tempo é retornado para true através do mesmo worker que verifica essa expiração.
2. Para dupla validação, quando todos os tokens estiverem em uso, é reverificado se não existe realmente algum que não esteja em uso mas com o campo com o valor incorreto. 
3. Caso não existe, é liberado o token em uso mais antigo.

### Fluxo da liberação
1. Quando o usuário requisita um token, é atribuído.
2. Quando decorre o tempo e o token expira, é removido da tabela.'token_assignments', alterado o campo 'available?' de tokens, e adicionado na tabela token_usage_history (rever ordem desse fluxo).
<!--
TO DO: Adicionar fluxo do sistema, e outras coisas quando implementadas.
->