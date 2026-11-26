# 🍽️ Restaurante Inteligente

**Plataforma de controle de consumo e atendimento para restaurante por quilo.**

Projeto acadêmico que propõe integrar o monitoramento de ingredientes, pedidos de bebidas por QR Code, mapa de mesas, rotina da equipe e indicadores gerenciais.

> **Status real do projeto:** protótipo acadêmico em desenvolvimento. A interface de mapa de mesas e uma API inicial estão no repositório. O banco PostgreSQL de referência, os fluxos de comanda, o painel completo e a integração física com ESP32/HX711 ainda precisam de implementação e validação. Não apresentamos módulos planejados como se já estivessem concluídos.

## Problema

O restaurante tradicionalmente acompanha o peso total do prato, mas não sabe com precisão quanto saiu de cada ingrediente da cuba. Isso dificulta estimar custos do mix servido, planejar reposições e entender horários de maior demanda. Também pode haver demora na fila do buffet, no pedido de bebidas e na liberação de mesas após a limpeza.

## Solução proposta

Uma plataforma com cinco módulos integrados:

| Módulo | O que resolve |
|---|---|
| Balança por cuba | Registra variações estáveis de peso de ingredientes selecionados e estima a saída por ingrediente |
| Comanda por QR Code | Permite solicitar bebidas vinculadas à mesa e acompanhar o status |
| Mapa de mesas | Exibe mesas disponíveis, ocupadas, em limpeza ou indisponíveis |
| Aplicativo da equipe | Registra atendimento, limpeza, pedidos e reposições |
| Painel do gestor | Consolida saída estimada, custos, reposições, pedidos, ocupação e tempos |

## Como funciona a pesagem

A proposta técnica utiliza célula de carga, módulo HX711 e ESP32. O firmware faz leituras, aplica calibração e aguarda estabilidade antes de enviar eventos ao servidor.

**Estimativa de custo:**

`custo estimado = (quantidade em gramas / 1000) × custo do ingrediente por kg`

A balança mede o que saiu da cuba, não o que chegou ao prato. Descarte, queda, pegador apoiado, contato do cliente e reposição podem interferir. Por isso, os valores devem ser tratados como estimativas e validados em piloto.

## Tecnologias

- **Proposta técnica:** Next.js, React, TypeScript, Tailwind CSS, shadcn/ui, PostgreSQL/Supabase, Supabase Realtime ou WebSocket; NestJS pode ser incorporado para regras de negócio mais complexas.
- **Protótipo atualmente versionado:** React + TypeScript + Vite no frontend e Java + Spring Boot no backend inicial.
- **Hardware proposto:** ESP32 + HX711 + célula de carga.
- **Banco de referência da proposta:** PostgreSQL, com 13 tabelas descritas no documento técnico.

A diferença entre arquitetura proposta e tecnologias do protótipo está documentada para evitar confusão durante a avaliação.

## Estrutura do repositório

```text
projeto-restaurante-inteligente/
├── README.md
├── apresentacao/       # apresentação de até 5 slides
├── backend/            # API inicial
├── database/           # modelos SQL
├── docs/                # problema, regras e arquitetura
├── evidencias/          # até 5 capturas reais da solução
├── frontend/            # interface web
└── hardware/            # proposta e especificação IoT
```

## Executar o protótipo web

Consulte os passos e pré-requisitos em [frontend/README.md](frontend/README.md). O frontend atual depende da API de mesas; ele não representa ainda os cinco módulos completos.

## Banco de dados

- [Modelo MySQL usado no protótipo inicial](database/schema.sql)
- [Modelo PostgreSQL de referência com as 13 tabelas da proposta](database/schema_postgresql.sql)

## Documentação

- [Detalhamento do projeto](docs/PROJETO.md)
- [Arquitetura e integração](docs/ARQUITETURA.md)
- [Roteiro do vídeo de demonstração](docs/ROTEIRO_VIDEO.md)
- [Hardware e balança por cuba](hardware/README.md)
- [Evidências e capturas de tela](evidencias/README.md)

## Materiais para avaliação

- **Apresentação (até 5 slides):** [abrir arquivo PPTX](apresentacao/Apresentacao_Restaurante_Inteligente_Gabriel_Ferreira.pptx)
- **Vídeo (até 2 minutos):** link ainda não publicado. Inserir o endereço real após gravar e publicar a demonstração.
- **Capturas de tela (máximo 5):** adicionar imagens reais em `evidencias/`; não usar imagens ilustrativas como evidência de funcionalidades executando.
- **Diagramas:** disponíveis em [docs/ARQUITETURA.md](docs/ARQUITETURA.md).

## Regras de negócio essenciais

1. Cada cuba ativa está associada a um ingrediente e a uma calibração válida.
2. Reposição é registrada separadamente da retirada.
3. Leituras instáveis não geram evento de retirada.
4. Todo pedido de bebida possui status e histórico.
5. A mesa só volta a disponível após a limpeza ser concluída.
6. Somente perfis autorizados alteram custos, bloqueiam mesas ou cadastram equipamentos.

## Plano de implantação

1. Observar a operação e mapear cubas, mesas, rede e sistema de caixa.
2. Criar protótipo com dados fictícios identificados.
3. Validar duas ou três cubas comparando o sensor com pesagem manual.
4. Testar comanda e aplicativo da equipe em poucas mesas.
5. Comparar resultados antes/depois e registrar limitações.
6. Expandir somente os módulos validados.

## Indicadores

Saída estimada por ingrediente e turno, custo estimado, diferença entre balança e pesagem manual, tempo de entrega de bebidas, tempo de mesa parada após atendimento, ocupação por faixa horária e quantidade de reposições.

---

**Projeto acadêmico — Análise e Desenvolvimento de Sistemas.**
