-- Restaurante Inteligente — modelo PostgreSQL alinhado à proposta técnica.
-- 13 tabelas: buffet, salão, atendimento, comandas e pedidos.
-- Dados pessoais de clientes não são armazenados neste modelo.
-- Recomendação: executar em um banco de testes antes de qualquer uso real.

CREATE TABLE ingrediente (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(120) NOT NULL UNIQUE,
  categoria VARCHAR(80),
  custo_por_kg NUMERIC(12,2) NOT NULL CHECK (custo_por_kg >= 0),
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE cuba (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  ingrediente_id BIGINT NOT NULL REFERENCES ingrediente(id),
  codigo VARCHAR(40) NOT NULL UNIQUE,
  zona_buffet VARCHAR(80),
  capacidade_gramas INTEGER NOT NULL CHECK (capacidade_gramas > 0),
  tipo_instalacao VARCHAR(20) NOT NULL
    CHECK (tipo_instalacao IN ('TRAVESSA_SOLTA', 'EMBUTIDA')),
  ativa BOOLEAN NOT NULL DEFAULT TRUE,
  criada_em TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE funcionario (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  perfil VARCHAR(20) NOT NULL CHECK (perfil IN ('GARCOM', 'LIMPEZA', 'GESTOR')),
  auth_uid UUID UNIQUE,
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE leitura_peso (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  cuba_id BIGINT NOT NULL REFERENCES cuba(id),
  peso_gramas NUMERIC(12,3) NOT NULL CHECK (peso_gramas >= 0),
  qualidade_sinal VARCHAR(20) NOT NULL DEFAULT 'VALIDA'
    CHECK (qualidade_sinal IN ('VALIDA', 'INSTAVEL', 'FALHA')),
  lida_em TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE evento_cuba (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  cuba_id BIGINT NOT NULL REFERENCES cuba(id),
  tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('RETIRADA', 'REPOSICAO', 'AJUSTE')),
  quantidade_gramas NUMERIC(12,3) NOT NULL CHECK (quantidade_gramas > 0),
  origem VARCHAR(10) NOT NULL CHECK (origem IN ('SENSOR', 'MANUAL')),
  funcionario_id BIGINT REFERENCES funcionario(id),
  ocorrido_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  observacao VARCHAR(300)
);

CREATE TABLE zona (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(80) NOT NULL UNIQUE,
  ordem_exibicao INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE mesa (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  zona_id BIGINT REFERENCES zona(id),
  codigo VARCHAR(30) NOT NULL UNIQUE,
  capacidade INTEGER NOT NULL CHECK (capacidade > 0),
  posicao_x NUMERIC(8,2),
  posicao_y NUMERIC(8,2),
  estado VARCHAR(20) NOT NULL DEFAULT 'DISPONIVEL'
    CHECK (estado IN ('DISPONIVEL', 'OCUPADA', 'EM_LIMPEZA', 'INDISPONIVEL')),
  criada_em TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE atendimento_mesa (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  mesa_id BIGINT NOT NULL REFERENCES mesa(id),
  funcionario_id BIGINT REFERENCES funcionario(id),
  quantidade_pessoas INTEGER NOT NULL CHECK (quantidade_pessoas > 0),
  inicio_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  fim_em TIMESTAMPTZ,
  CHECK (fim_em IS NULL OR fim_em >= inicio_em)
);

CREATE TABLE limpeza (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  mesa_id BIGINT NOT NULL REFERENCES mesa(id),
  funcionario_id BIGINT REFERENCES funcionario(id),
  inicio_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  fim_em TIMESTAMPTZ,
  CHECK (fim_em IS NULL OR fim_em >= inicio_em)
);

CREATE TABLE comanda (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  mesa_id BIGINT NOT NULL REFERENCES mesa(id),
  codigo_qr VARCHAR(160) NOT NULL UNIQUE,
  status VARCHAR(20) NOT NULL DEFAULT 'ABERTA'
    CHECK (status IN ('ABERTA', 'AGUARDANDO', 'ENCERRADA', 'CANCELADA')),
  prato_pronto_em TIMESTAMPTZ,
  criada_em TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE item_cardapio (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  categoria VARCHAR(60) NOT NULL,
  preco NUMERIC(10,2) NOT NULL CHECK (preco >= 0),
  disponivel BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE pedido_bebida (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  comanda_id BIGINT NOT NULL REFERENCES comanda(id),
  item_cardapio_id BIGINT NOT NULL REFERENCES item_cardapio(id),
  quantidade INTEGER NOT NULL CHECK (quantidade > 0),
  observacao VARCHAR(300),
  status VARCHAR(20) NOT NULL DEFAULT 'RECEBIDO'
    CHECK (status IN ('RECEBIDO', 'EM_PREPARO', 'ENTREGUE', 'CANCELADO')),
  pedido_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  entregue_em TIMESTAMPTZ,
  CHECK (entregue_em IS NULL OR entregue_em >= pedido_em)
);

CREATE TABLE historico_pedido (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  pedido_bebida_id BIGINT NOT NULL REFERENCES pedido_bebida(id) ON DELETE CASCADE,
  status VARCHAR(20) NOT NULL
    CHECK (status IN ('RECEBIDO', 'EM_PREPARO', 'ENTREGUE', 'CANCELADO')),
  funcionario_id BIGINT REFERENCES funcionario(id),
  alterado_em TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Índices para consultas frequentes do painel e do mapa.
CREATE INDEX idx_leitura_peso_cuba_data ON leitura_peso(cuba_id, lida_em DESC);
CREATE INDEX idx_evento_cuba_data ON evento_cuba(cuba_id, ocorrido_em DESC);
CREATE INDEX idx_mesa_estado ON mesa(estado);
CREATE INDEX idx_atendimento_mesa_inicio ON atendimento_mesa(mesa_id, inicio_em DESC);
CREATE INDEX idx_pedido_status_data ON pedido_bebida(status, pedido_em DESC);
CREATE INDEX idx_historico_pedido_data ON historico_pedido(pedido_bebida_id, alterado_em DESC);

-- Regra de negócio: a mesa somente deve voltar a DISPONIVEL após a conclusão
-- da limpeza correspondente. A aplicação deve validar essa transição (ou
-- implementar trigger após validação do fluxo operacional do restaurante).
-- Leituras INSTAVEIS/FALHA não devem gerar eventos de retirada.
-- A variação da cuba é uma estimativa de saída, não consumo individual.
