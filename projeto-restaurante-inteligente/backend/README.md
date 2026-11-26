# Backend — Java + Spring Boot

Este diretório está reservado à API REST do projeto. A implementação do backend deve seguir a arquitetura documentada em ../docs/ARQUITETURA.md.

## Responsabilidades previstas

- Autenticação e autorização por perfil.
- CRUD de mesas, bebidas e ingredientes.
- Criação e atualização de pedidos.
- Fluxo de atendimento e limpeza.
- Recebimento e validação de leituras ESP32.
- Consulta de indicadores e saídas estimadas.

## Endpoints planejados

| Método | Rota | Finalidade |
|---|---|---|
| GET | /api/mesas | Listar mesas e estados |
| PATCH | /api/mesas/{id}/status | Atualizar estado permitido |
| GET | /api/bebidas | Listar bebidas disponíveis |
| POST | /api/pedidos | Criar pedido |
| PATCH | /api/pedidos/{id}/status | Atualizar andamento |
| POST | /api/leituras | Receber leitura de balança |
| GET | /api/indicadores/saidas | Consultar saídas estimadas |

## Próxima etapa

Criar o projeto Spring Boot com Spring Web, Spring Data JPA, Validation, Spring Security e driver MySQL. Configurações e credenciais devem ficar em variáveis de ambiente; nunca versionar senhas ou tokens.
