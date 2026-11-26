# Backend — Java + Spring Boot

API inicial do projeto, usando Java 21, Spring Boot 3, Spring Web, Spring Data JPA e MySQL.

## Implementado nesta primeira etapa

- Inicialização da aplicação Spring Boot.
- Entidade e enumeração de mesas.
- Repositório JPA de mesas.
- Endpoints para listar, cadastrar e alterar o estado de mesas.
- Validação básica de cadastro e identificação duplicada.

## Endpoints disponíveis

| Método | Rota | Finalidade |
|---|---|---|
| GET | /api/mesas | Listar mesas |
| POST | /api/mesas | Cadastrar mesa |
| PATCH | /api/mesas/{id}/status | Alterar estado |

Exemplo de cadastro:

```json
{
  "identificacao": "M04",
  "capacidade": 4,
  "zona": "JANELA"
}
```

Exemplo de alteração:

```json
{ "status": "OCUPADA" }
```

Estados aceitos: `DISPONIVEL`, `OCUPADA`, `EM_LIMPEZA`, `INDISPONIVEL`.

## Como executar

1. Instale JDK 21, Maven e MySQL 8.
2. Execute o script `../database/schema.sql` no MySQL.
3. Copie `src/main/resources/application.properties.example` para `application.properties`.
4. Configure `DB_USERNAME` e `DB_PASSWORD` como variáveis de ambiente.
5. Na pasta `backend`, execute:

```bash
mvn spring-boot:run
```

A API ficará disponível em `http://localhost:8080`.

> Este é um MVP inicial: pedidos, autenticação, limpeza, leituras IoT e indicadores ainda precisam ser implementados. A API de mesas deve receber regras adicionais de transição e autorização antes de uso real.
