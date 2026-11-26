-- Modelo inicial do banco de dados - Restaurante Inteligente
-- MySQL 8+
-- Estrutura acadêmica inicial; revisar e testar antes de produção.

CREATE DATABASE IF NOT EXISTS restaurante_inteligente
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE restaurante_inteligente;

CREATE TABLE IF NOT EXISTS usuarios (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(120) NOT NULL,
  email VARCHAR(160) NOT NULL UNIQUE,
  senha_hash VARCHAR(255) NOT NULL,
  perfil ENUM('GESTOR','GARCOM','LIMPEZA') NOT NULL,
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS mesas (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  identificacao VARCHAR(30) NOT NULL UNIQUE,
  capacidade INT NOT NULL,
  status ENUM('DISPONIVEL','OCUPADA','EM_LIMPEZA','INDISPONIVEL')
    NOT NULL DEFAULT 'DISPONIVEL',
  zona VARCHAR(60),
  CHECK (capacidade > 0)
);

CREATE TABLE IF NOT EXISTS atendimentos (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  mesa_id BIGINT NOT NULL,
  garcom_id BIGINT,
  inicio_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fim_em TIMESTAMP NULL,
  status ENUM('ATIVO','ENCERRADO','CANCELADO') NOT NULL DEFAULT 'ATIVO',
  FOREIGN KEY (mesa_id) REFERENCES mesas(id),
  FOREIGN KEY (garcom_id) REFERENCES usuarios(id)
);

CREATE TABLE IF NOT EXISTS tarefas_limpeza (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  mesa_id BIGINT NOT NULL,
  funcionario_id BIGINT,
  iniciada_em TIMESTAMP NULL,
  concluida_em TIMESTAMP NULL,
  status ENUM('PENDENTE','EM_ANDAMENTO','CONCLUIDA') NOT NULL DEFAULT 'PENDENTE',
  FOREIGN KEY (mesa_id) REFERENCES mesas(id),
  FOREIGN KEY (funcionario_id) REFERENCES usuarios(id)
);

CREATE TABLE IF NOT EXISTS bebidas (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(100) NOT NULL,
  preco DECIMAL(10,2) NOT NULL,
  disponivel BOOLEAN NOT NULL DEFAULT TRUE,
  CHECK (preco >= 0)
);

CREATE TABLE IF NOT EXISTS pedidos (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  mesa_id BIGINT NOT NULL,
  atendimento_id BIGINT,
  status ENUM('RECEBIDO','EM_PREPARO','PRONTO','ENTREGUE','CANCELADO')
    NOT NULL DEFAULT 'RECEBIDO',
  observacao VARCHAR(500),
  criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (mesa_id) REFERENCES mesas(id),
  FOREIGN KEY (atendimento_id) REFERENCES atendimentos(id)
);

CREATE TABLE IF NOT EXISTS itens_pedido (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  pedido_id BIGINT NOT NULL,
  bebida_id BIGINT NOT NULL,
  quantidade INT NOT NULL,
  preco_unitario DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
  FOREIGN KEY (bebida_id) REFERENCES bebidas(id),
  CHECK (quantidade > 0),
  CHECK (preco_unitario >= 0)
);

CREATE TABLE IF NOT EXISTS ingredientes (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(120) NOT NULL,
  custo_por_kg DECIMAL(10,2) NOT NULL,
  unidade VARCHAR(20) NOT NULL DEFAULT 'g',
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  CHECK (custo_por_kg >= 0)
);

CREATE TABLE IF NOT EXISTS equipamentos_balanca (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  identificacao VARCHAR(80) NOT NULL UNIQUE,
  ingrediente_id BIGINT NOT NULL,
  fator_calibracao DECIMAL(14,6),
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  FOREIGN KEY (ingrediente_id) REFERENCES ingredientes(id)
);

CREATE TABLE IF NOT EXISTS leituras_peso (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  equipamento_id BIGINT NOT NULL,
  peso_gramas DECIMAL(12,3) NOT NULL,
  estavel BOOLEAN NOT NULL DEFAULT FALSE,
  lida_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (equipamento_id) REFERENCES equipamentos_balanca(id)
);

CREATE TABLE IF NOT EXISTS saidas_estimadas (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  ingrediente_id BIGINT NOT NULL,
  leitura_anterior_id BIGINT NOT NULL,
  leitura_atual_id BIGINT NOT NULL,
  quantidade_gramas DECIMAL(12,3) NOT NULL,
  custo_estimado DECIMAL(12,2) NOT NULL,
  observacao VARCHAR(300),
  calculada_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (ingrediente_id) REFERENCES ingredientes(id),
  FOREIGN KEY (leitura_anterior_id) REFERENCES leituras_peso(id),
  FOREIGN KEY (leitura_atual_id) REFERENCES leituras_peso(id),
  CHECK (quantidade_gramas >= 0),
  CHECK (custo_estimado >= 0)
);

CREATE TABLE IF NOT EXISTS reposicoes (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  ingrediente_id BIGINT NOT NULL,
  usuario_id BIGINT,
  quantidade_gramas DECIMAL(12,3) NOT NULL,
  registrada_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (ingrediente_id) REFERENCES ingredientes(id),
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
  CHECK (quantidade_gramas > 0)
);

-- Cadastros demonstrativos opcionais: todos os dados abaixo são fictícios.
INSERT INTO mesas (identificacao, capacidade, zona) VALUES
('M01', 2, 'SALAO'), ('M02', 4, 'SALAO'), ('M03', 4, 'JANELA');

INSERT INTO bebidas (nome, preco) VALUES
('Água sem gás', 4.00), ('Refrigerante lata', 6.50), ('Suco natural', 8.00);

INSERT INTO ingredientes (nome, custo_por_kg) VALUES
('Frango grelhado', 22.00), ('Arroz', 6.50), ('Legumes', 9.00);
