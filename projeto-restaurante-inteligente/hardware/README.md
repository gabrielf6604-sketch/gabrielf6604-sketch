# Hardware — balança inteligente

## Componentes previstos

- ESP32.
- Módulo amplificador/conversor HX711.
- Célula de carga compatível com a capacidade da cuba e suporte mecânico.
- Fonte de alimentação e conexões adequadas.

## Funcionamento esperado

1. A célula de carga detecta a força aplicada.
2. O HX711 condiciona e digitaliza o sinal.
3. O ESP32 realiza a leitura e aplica o fator de calibração.
4. Leituras estáveis são enviadas à API com identificação do equipamento e horário.

## Cuidados de validação

- Calibrar com pesos de referência.
- Fazer tara com a cuba e seus acessórios.
- Testar estabilidade, repetibilidade e deriva.
- Identificar reposições separadamente.
- Não interpretar automaticamente qualquer redução como consumo.
- Começar com duas ou três cubas e comparar os dados com pesagens manuais.

**Status:** documentação de integração. O hardware físico ainda precisa ser montado e testado.
