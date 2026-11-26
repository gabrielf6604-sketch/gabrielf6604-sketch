# 🍽️ Restaurante Inteligente

Plataforma integrada para apoiar a operação de restaurantes por quilo, conectando monitoramento de ingredientes, pedidos de bebidas, gestão de mesas e indicadores administrativos.

> **Status:** MVP inicial em desenvolvimento. Já existe uma primeira API de mesas com Spring Boot e uma interface React que consome essa API. Os módulos de hardware, pedidos, autenticação e relatórios ainda precisam ser implementados e testados.

## Problema

Restaurantes por quilo podem ter dificuldade para acompanhar a saída de cada ingrediente, identificar horários de maior demanda, organizar pedidos e manter a situação das mesas atualizada. Quando esses dados ficam separados ou são anotados manualmente, o gestor tem menos visibilidade para tomar decisões.

## Solução proposta

Uma plataforma dividida em cinco frentes integradas:

1. **Balanças inteligentes:** ESP32 + HX711 para monitorar variações de peso das cubas e estimar a saída por ingrediente.
2. **Comanda digital:** QR Code da mesa para solicitar bebidas e acompanhar o status do pedido.
3. **Mapa de mesas:** visualização de mesas disponíveis, ocupadas, em limpeza ou indisponíveis.
4. **Aplicativo operacional:** equipe registra atendimento, reposição e início/fim da limpeza.
5. **Painel do gestor:** indicadores de saída estimada, reposições, pedidos e ocupação.

## Tecnologias

- Frontend: React + TypeScript + Vite.
- Backend: Java 21 + Spring Boot 3 + Spring Data JPA.
- Banco de dados: MySQL 8.
- IoT planejado: ESP32 + HX711 + célula de carga.

## O que já está implementado

- API REST para listar, cadastrar e alterar o estado das mesas.
- Persistência das mesas com Spring Data JPA.
- Interface web para visualizar mesas, contadores e alterar estados.
- Modelo inicial do banco de dados.
- Documentação e diagramas de arquitetura.

## O que ainda está em desenvolvimento

- Autenticação e autorização por perfil.
- Comanda digital e fluxo de bebidas.
- Fluxo completo de atendimento e limpeza.
- Integração física com ESP32/HX711.
- Cálculo validado de saídas estimadas e painel de indicadores.
- Testes integrados e implantação.

## Estrutura do repositório

```text
projeto-restaurante-inteligente/
├── README.md
├── docs/
├── database/
├── backend/
├── frontend/
├── hardware/
├── apresentacao/
└── evidencias/
```

## Documentação

- [Detalhamento do projeto](docs/PROJETO.md)
- [Arquitetura e integração](docs/ARQUITETURA.md)
- [Script de criação do banco](database/schema.sql)
- [Instruções do backend](backend/README.md)
- [Instruções do frontend](frontend/README.md)
- [Documentação do hardware](hardware/README.md)

## Materiais para avaliação

- **Capturas de tela (máximo 5):** adicionar somente imagens reais do protótipo em [evidencias/](evidencias/README.md).
- **Vídeo (até 2 minutos):** inserir o link após gravar a demonstração prática.
- **Apresentação (até 5 slides):** adicionar o arquivo e link em [apresentacao/](apresentacao/README.md).
- **Diagramas:** estão documentados em [docs/ARQUITETURA.md](docs/ARQUITETURA.md).

## Cuidados de interpretação

A balança mede a variação de peso da cuba. Isso representa **saída estimada**, não prova quanto foi consumido, desperdiçado ou por qual cliente. Reposição, tara, oscilação e manuseio precisam ser considerados na calibração.

Dados demonstrativos devem ser identificados como fictícios. Integração com PDV depende da API do fornecedor.

---
Projeto acadêmico de Análise e Desenvolvimento de Sistemas.
