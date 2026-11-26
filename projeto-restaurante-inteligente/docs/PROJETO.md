# Detalhamento do projeto

## 1. Objetivo geral

Desenvolver uma plataforma integrada para apoiar o controle operacional e gerencial de um restaurante por quilo, centralizando informações de ingredientes, pedidos e mesas.

## 2. Objetivos específicos

- Monitorar a variação de peso de ingredientes selecionados.
- Estimar a saída por ingrediente e relacioná-la ao custo cadastrado por quilograma.
- Permitir pedidos de bebidas por QR Code associado à mesa.
- Exibir a situação das mesas em um mapa visual.
- Registrar atendimento, reposição e limpeza.
- Apresentar indicadores operacionais ao gestor.

## 3. Público envolvido

- **Cliente:** consulta o cardápio e solicita bebidas.
- **Garçom:** acompanha mesas e pedidos.
- **Equipe de limpeza:** atualiza o estado de limpeza.
- **Gestor:** cadastra dados e acompanha indicadores.

## 4. Módulos e funcionamento

### 4.1 Monitoramento de ingredientes

Uma célula de carga conectada ao módulo HX711 e ao ESP32 coleta leituras de peso. O sistema registra as leituras com data e hora, identifica reduções e aumentos e calcula a diferença entre leituras estáveis.

Fórmula de estimativa:

`Saída estimada (g) = peso anterior (g) - peso atual (g)`

`Custo estimado = (saída estimada em g / 1000) × custo por kg`

O cálculo precisa considerar tara, reposições, oscilações e calibração. A leitura não identifica o cliente nem comprova consumo individual.

### 4.2 Comanda digital

Cada mesa possui um QR Code que abre a comanda correspondente. No escopo inicial, o cliente seleciona bebidas e envia o pedido. A equipe recebe o pedido e atualiza seu status: recebido, em preparo, pronto e entregue.

A pré-montagem de prato pode ser estudada futuramente, mas não deve ser tratada como consumo confirmado.

### 4.3 Mapa de mesas

O mapa representa a disposição aproximada das mesas e apresenta estados:
- Disponível;
- Ocupada;
- Em limpeza;
- Indisponível.

A equipe atualiza os estados durante a operação. Uma mesa em limpeza só retorna a disponível após a conclusão da tarefa.

### 4.4 Aplicativo operacional

Interface responsiva para funcionários, com acesso conforme o perfil. Garçons atualizam atendimento e pedidos; limpeza inicia e conclui tarefas; gestores consultam e administram os dados.

### 4.5 Painel do gestor

Apresenta saída estimada por ingrediente, custos estimados, reposições, pedidos de bebidas, ocupação e tempos de mesa. Indicadores devem ser interpretados com contexto e não usados isoladamente para avaliar funcionários.

## 5. Regras de negócio

1. Toda mesa possui identificador único e capacidade cadastrada.
2. Uma mesa ocupada não pode ser atribuída a outro atendimento ativo.
3. Ao encerrar atendimento, a mesa passa para em limpeza.
4. A mesa só fica disponível após a conclusão da limpeza.
5. Pedidos pertencem a uma mesa/comanda e possuem histórico de status.
6. Cada leitura de balança pertence a um equipamento e ingrediente.
7. Reposição deve ser registrada separadamente de retirada.
8. O sistema identifica os valores de saída como estimativas.
9. Acesso às funções depende do perfil do usuário.

## 6. Viabilidade e riscos

- **Precisão do sensor:** começar com poucas cubas e calibrar antes de expandir.
- **Interferência física:** pegadores, contato com a bancada e reposições podem gerar leituras incorretas.
- **Conectividade:** prever reconexão e registro local temporário no dispositivo.
- **Adoção pela equipe:** interface simples e treinamento.
- **Integração com PDV:** depende da documentação e autorização do fornecedor.
- **Privacidade:** coletar apenas os dados necessários e não implementar reconhecimento facial.

## 7. Escopo recomendado do MVP

Priorizar mapa de mesas, pedido de bebidas e painel básico. Em paralelo, validar a leitura de peso em duas ou três cubas selecionadas. Integração com PDV, câmeras e análises avançadas ficam para etapas futuras.

## 8. Critérios de validação

- O pedido de bebida aparece para a equipe e pode ter status atualizado.
- Alterações de estado de mesa aparecem no mapa.
- A mesa não fica disponível antes do fim da limpeza.
- Leituras do sensor são comparadas com pesagens de referência.
- O painel diferencia dados reais, estimativas e dados fictícios.
