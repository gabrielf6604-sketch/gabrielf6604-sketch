# 🍽️ Restaurante Inteligente

Plataforma integrada para apoiar a operação de restaurantes por quilo, conectando monitoramento de ingredientes, pedidos de bebidas, gestão de mesas e indicadores administrativos.

> **Status:** estrutura inicial e documentação acadêmica. Os módulos de hardware e integrações externas ainda dependem de montagem, configuração e testes no estabelecimento. Não são apresentados como funcionalidades já implantadas.

## Problema

Restaurantes por quilo podem ter dificuldade para acompanhar a saída de cada ingrediente, identificar horários de maior demanda, organizar pedidos e manter a situação das mesas atualizada. Quando esses dados ficam separados ou são anotados manualmente, o gestor tem menos visibilidade para tomar decisões.

## Solução proposta

Uma plataforma dividida em cinco frentes integradas:

1. **Balanças inteligentes:** células de carga com HX711 e ESP32 monitoram a variação de peso das cubas. O sistema calcula a saída estimada por ingrediente.
2. **Comanda digital:** QR Code da mesa permite solicitar bebidas e acompanhar o status do pedido.
3. **Mapa de mesas:** painel visual apresenta mesas disponíveis, ocupadas, em limpeza ou indisponíveis.
4. **Aplicativo operacional:** equipe registra atendimento, reposição e início/fim da limpeza.
5. **Painel do gestor:** reúne indicadores de saída estimada, reposições, pedidos e ocupação.

## Arquitetura prevista

- **Frontend:** React + TypeScript.
- **Backend:** Java + Spring Boot (API REST).
- **Banco de dados:** MySQL.
- **IoT:** ESP32 + HX711 + célula de carga.
- **Comunicação:** HTTP/REST entre aplicações e API; integração IoT por endpoint autenticado ou serviço de mensageria em etapa posterior.

Consulte [arquitetura e integração](docs/ARQUITETURA.md), [detalhamento do projeto](docs/PROJETO.md) e [modelo de dados](database/schema.sql).

## Estrutura do repositório

```text
projeto-restaurante-inteligente/
├── README.md
├── docs/
│   ├── PROJETO.md
│   └── ARQUITETURA.md
├── database/
│   └── schema.sql
├── backend/
│   └── README.md
├── frontend/
│   └── README.md
├── hardware/
│   └── README.md
├── apresentacao/
│   └── README.md
└── evidencias/
    └── README.md
```

## Demonstração e materiais da avaliação

- **Capturas de tela (máximo 5):** serão adicionadas em [evidencias/](evidencias/README.md) quando as telas do protótipo estiverem disponíveis. Não são usadas imagens ilustrativas como se fossem capturas reais.
- **Vídeo (até 2 minutos):** link será inserido aqui após a gravação da demonstração prática.
- **Slides (até 5):** arquivo e link serão adicionados em [apresentacao/](apresentacao/README.md).
- **Diagramas:** disponíveis na documentação de arquitetura e integração.

## Regras importantes e limitações

- A balança mede a variação de peso da cuba. Isso representa **saída estimada**, não prova quanto foi consumido, desperdiçado ou por qual cliente.
- Reposição, retirada da cuba, tara, oscilação e manuseio precisam ser considerados na calibração.
- O custo estimado pode ser calculado por `(gramas de saída / 1000) × custo por kg`, mas margem real exige conciliação com compras, estoque, perdas e vendas.
- A comanda de bebidas pode funcionar de forma independente; integração com PDV depende da API e das condições do fornecedor.
- A mesa só deve voltar ao estado disponível depois da conclusão da limpeza.
- Dados demonstrativos devem ser identificados como fictícios.

## Plano de desenvolvimento

1. Modelar banco de dados e regras de negócio.
2. Construir API REST e autenticação/perfis.
3. Desenvolver mapa de mesas, comanda e painel web.
4. Integrar e calibrar o módulo ESP32/HX711.
5. Testar os fluxos ponta a ponta e registrar evidências.
6. Preparar vídeo e apresentação final.

## Como contribuir ou executar

Consulte os READMEs de cada módulo. As instruções específicas de instalação serão atualizadas conforme backend, frontend e hardware forem implementados e testados.

---
Projeto acadêmico de Análise e Desenvolvimento de Sistemas.
