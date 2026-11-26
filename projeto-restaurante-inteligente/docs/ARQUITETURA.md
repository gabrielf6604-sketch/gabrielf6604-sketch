# Arquitetura e integração

## Visão geral

```mermaid
flowchart LR
    Cliente[Cliente / QR Code] --> Web[Frontend React]
    Equipe[Funcionários] --> Web
    Gestor[Gestor] --> Web
    Web --> API[API REST Spring Boot]
    API --> DB[(MySQL)]
    Sensor[ESP32 + HX711] -->|Leituras de peso| API
    API --> Painel[Painel e relatórios]
    API --> Pedidos[Fluxo de pedidos]
    API --> Mesas[Estado das mesas]
```

## Fluxo de pedido de bebida

```mermaid
sequenceDiagram
    actor Cliente
    participant Web as Aplicação Web
    participant API as Spring Boot
    participant DB as MySQL
    participant Equipe as Funcionário
    Cliente->>Web: Lê QR Code da mesa
    Web->>API: Consulta cardápio
    API->>DB: Busca bebidas disponíveis
    DB-->>API: Lista de bebidas
    API-->>Web: Cardápio
    Cliente->>Web: Envia pedido
    Web->>API: POST /api/pedidos
    API->>DB: Registra pedido
    API-->>Equipe: Pedido disponível
    Equipe->>API: Atualiza status
    API->>DB: Persiste status
    Web-->>Cliente: Exibe andamento
```

## Ciclo de vida da mesa

```mermaid
stateDiagram-v2
    [*] --> Disponivel
    Disponivel --> Ocupada: iniciar atendimento
    Ocupada --> EmLimpeza: encerrar atendimento
    EmLimpeza --> Disponivel: concluir limpeza
    Disponivel --> Indisponivel: bloquear mesa
    Indisponivel --> Disponivel: liberar mesa
```

## Fluxo do sensor

1. O ESP32 inicializa e conecta à rede.
2. O HX711 fornece a leitura da célula de carga.
3. O dispositivo aplica calibração e filtro de estabilidade.
4. O dispositivo envia peso, equipamento e instante da leitura.
5. A API valida e armazena a leitura.
6. O serviço calcula a variação entre leituras estáveis e registra uma estimativa.
7. O painel apresenta a estimativa com indicação de que não representa consumo individual confirmado.

## Separação de responsabilidades

- **Frontend:** interface e experiência de cliente, equipe e gestor.
- **Backend:** regras de negócio, autenticação, validação e API.
- **Banco:** persistência e integridade dos dados.
- **IoT:** aquisição e envio das leituras dos sensores.

## Segurança e confiabilidade

- Autenticação e autorização por perfil.
- Senhas armazenadas com hash seguro.
- Validação de dados recebidos pela API.
- Comunicação protegida em ambiente de produção.
- Registro de alterações relevantes.
- Tratamento de falhas de rede e leituras inválidas.
