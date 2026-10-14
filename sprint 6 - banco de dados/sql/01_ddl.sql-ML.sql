-- =========================================================
-- 01_ddl.sql
-- Projeto: RotaCerta Logística
-- Grupo 2 - Sistema Logístico
-- PostgreSQL / DBeaver
-- =========================================================

DROP SCHEMA IF EXISTS rotacerta CASCADE;

CREATE SCHEMA rotacerta;

SET search_path TO rotacerta, public;

-- =========================================================
-- 1. LOJAS PARCEIRAS
-- Empresas que contratam armazenagem e entregas.
-- =========================================================
CREATE TABLE loja_parceira (
    id_loja BIGINT GENERATED ALWAYS AS IDENTITY,
    razao_social VARCHAR(180) NOT NULL,
    nome_fantasia VARCHAR(150) NOT NULL,
    cnpj CHAR(14) NOT NULL,
    email VARCHAR(160) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_loja_parceira PRIMARY KEY (id_loja),
    CONSTRAINT uq_loja_parceira_cnpj UNIQUE (cnpj),
    CONSTRAINT uq_loja_parceira_email UNIQUE (email),
    CONSTRAINT ck_loja_parceira_cnpj CHECK (cnpj ~ '^[0-9]{14}$')
);

-- =========================================================
-- 2. CATEGORIAS DE PRODUTOS
-- =========================================================
CREATE TABLE categoria_produto (
    id_categoria BIGINT GENERATED ALWAYS AS IDENTITY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),

    CONSTRAINT pk_categoria_produto PRIMARY KEY (id_categoria),
    CONSTRAINT uq_categoria_produto_nome UNIQUE (nome)
);

-- =========================================================
-- 3. PRODUTOS DAS LOJAS PARCEIRAS
-- =========================================================
CREATE TABLE produto (
    id_produto BIGINT GENERATED ALWAYS AS IDENTITY,
    id_loja BIGINT NOT NULL,
    id_categoria BIGINT NOT NULL,
    sku VARCHAR(30) NOT NULL,
    nome VARCHAR(160) NOT NULL,
    descricao VARCHAR(255),
    peso_kg NUMERIC(10,3) NOT NULL,
    preco_unitario NUMERIC(12,2) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT pk_produto PRIMARY KEY (id_produto),
    CONSTRAINT uq_produto_sku UNIQUE (sku),

    CONSTRAINT fk_produto_loja
        FOREIGN KEY (id_loja)
        REFERENCES loja_parceira (id_loja)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_produto_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES categoria_produto (id_categoria)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT ck_produto_peso CHECK (peso_kg > 0),
    CONSTRAINT ck_produto_preco CHECK (preco_unitario >= 0)
);

-- =========================================================
-- 4. CENTROS DE DISTRIBUIÇÃO
-- =========================================================
CREATE TABLE centro_distribuicao (
    id_centro BIGINT GENERATED ALWAYS AS IDENTITY,
    nome VARCHAR(150) NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL,
    capacidade_maxima_kg NUMERIC(14,2) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT pk_centro_distribuicao PRIMARY KEY (id_centro),
    CONSTRAINT uq_centro_distribuicao_codigo UNIQUE (codigo),
    CONSTRAINT ck_centro_distribuicao_estado CHECK (estado ~ '^[A-Z]{2}$'),
    CONSTRAINT ck_centro_distribuicao_capacidade CHECK (capacidade_maxima_kg > 0)
);

-- =========================================================
-- 5. ESTOQUE POR CENTRO E PRODUTO
-- =========================================================
CREATE TABLE estoque (
    id_estoque BIGINT GENERATED ALWAYS AS IDENTITY,
    id_centro BIGINT NOT NULL,
    id_produto BIGINT NOT NULL,
    quantidade_disponivel INTEGER NOT NULL DEFAULT 0,
    quantidade_reservada INTEGER NOT NULL DEFAULT 0,
    ponto_reposicao INTEGER NOT NULL DEFAULT 10,
    atualizado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_estoque PRIMARY KEY (id_estoque),
    CONSTRAINT uq_estoque_centro_produto UNIQUE (id_centro, id_produto),

    CONSTRAINT fk_estoque_centro
        FOREIGN KEY (id_centro)
        REFERENCES centro_distribuicao (id_centro)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_estoque_produto
        FOREIGN KEY (id_produto)
        REFERENCES produto (id_produto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT ck_estoque_disponivel CHECK (quantidade_disponivel >= 0),
    CONSTRAINT ck_estoque_reservada CHECK (quantidade_reservada >= 0),
    CONSTRAINT ck_estoque_ponto_reposicao CHECK (ponto_reposicao >= 0)
);

-- =========================================================
-- 6. CLIENTES FINAIS
-- =========================================================
CREATE TABLE cliente (
    id_cliente BIGINT GENERATED ALWAYS AS IDENTITY,
    nome VARCHAR(150) NOT NULL,
    cpf CHAR(11) NOT NULL,
    email VARCHAR(160) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    data_cadastro DATE NOT NULL DEFAULT CURRENT_DATE,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT pk_cliente PRIMARY KEY (id_cliente),
    CONSTRAINT uq_cliente_cpf UNIQUE (cpf),
    CONSTRAINT uq_cliente_email UNIQUE (email),
    CONSTRAINT ck_cliente_cpf CHECK (cpf ~ '^[0-9]{11}$')
);

-- =========================================================
-- 7. ENDEREÇOS DOS CLIENTES
-- =========================================================
CREATE TABLE endereco_cliente (
    id_endereco BIGINT GENERATED ALWAYS AS IDENTITY,
    id_cliente BIGINT NOT NULL,
    logradouro VARCHAR(150) NOT NULL,
    numero VARCHAR(20) NOT NULL,
    complemento VARCHAR(100) NOT NULL DEFAULT 'SEM COMPLEMENTO',
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL,
    cep CHAR(8) NOT NULL,
    principal BOOLEAN NOT NULL DEFAULT FALSE,

    CONSTRAINT pk_endereco_cliente PRIMARY KEY (id_endereco),

    CONSTRAINT fk_endereco_cliente_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT ck_endereco_cliente_estado CHECK (estado ~ '^[A-Z]{2}$'),
    CONSTRAINT ck_endereco_cliente_cep CHECK (cep ~ '^[0-9]{8}$')
);

-- =========================================================
-- 8. PEDIDOS
-- =========================================================
CREATE TABLE pedido (
    id_pedido BIGINT GENERATED ALWAYS AS IDENTITY,
    id_cliente BIGINT NOT NULL,
    id_endereco_entrega BIGINT NOT NULL,
    numero_pedido VARCHAR(30) NOT NULL,
    data_pedido TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'CRIADO',
    valor_total NUMERIC(12,2) NOT NULL DEFAULT 0,
    observacao VARCHAR(255),

    CONSTRAINT pk_pedido PRIMARY KEY (id_pedido),
    CONSTRAINT uq_pedido_numero UNIQUE (numero_pedido),

    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_pedido_endereco
        FOREIGN KEY (id_endereco_entrega)
        REFERENCES endereco_cliente (id_endereco)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT ck_pedido_status CHECK (
        status IN ('CRIADO', 'PAGO', 'SEPARACAO', 'EM_ROTA', 'ENTREGUE', 'CANCELADO')
    ),

    CONSTRAINT ck_pedido_valor_total CHECK (valor_total >= 0)
);

-- =========================================================
-- 9. ITENS DE PEDIDO
-- =========================================================
CREATE TABLE item_pedido (
    id_item_pedido BIGINT GENERATED ALWAYS AS IDENTITY,
    id_pedido BIGINT NOT NULL,
    id_produto BIGINT NOT NULL,
    quantidade INTEGER NOT NULL,
    preco_unitario NUMERIC(12,2) NOT NULL,
    desconto NUMERIC(12,2) NOT NULL DEFAULT 0,

    CONSTRAINT pk_item_pedido PRIMARY KEY (id_item_pedido),
    CONSTRAINT uq_item_pedido_pedido_produto UNIQUE (id_pedido, id_produto),

    CONSTRAINT fk_item_pedido_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES pedido (id_pedido)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_item_pedido_produto
        FOREIGN KEY (id_produto)
        REFERENCES produto (id_produto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT ck_item_pedido_quantidade CHECK (quantidade > 0),
    CONSTRAINT ck_item_pedido_preco CHECK (preco_unitario >= 0),
    CONSTRAINT ck_item_pedido_desconto CHECK (
        desconto >= 0
        AND desconto <= preco_unitario * quantidade
    )
);

-- =========================================================
-- 10. VEÍCULOS
-- =========================================================
CREATE TABLE veiculo (
    id_veiculo BIGINT GENERATED ALWAYS AS IDENTITY,
    placa CHAR(7) NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    capacidade_kg NUMERIC(12,2) NOT NULL,
    ano_fabricacao SMALLINT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'DISPONIVEL',

    CONSTRAINT pk_veiculo PRIMARY KEY (id_veiculo),
    CONSTRAINT uq_veiculo_placa UNIQUE (placa),
    CONSTRAINT ck_veiculo_placa CHECK (placa ~ '^[A-Z0-9]{7}$'),
    CONSTRAINT ck_veiculo_capacidade CHECK (capacidade_kg > 0),
    CONSTRAINT ck_veiculo_ano CHECK (ano_fabricacao BETWEEN 2000 AND 2100),
    CONSTRAINT ck_veiculo_status CHECK (
        status IN ('DISPONIVEL', 'EM_ROTA', 'MANUTENCAO', 'INATIVO')
    )
);

-- =========================================================
-- 11. MOTORISTAS
-- =========================================================
CREATE TABLE motorista (
    id_motorista BIGINT GENERATED ALWAYS AS IDENTITY,
    nome VARCHAR(150) NOT NULL,
    cpf CHAR(11) NOT NULL,
    cnh VARCHAR(20) NOT NULL,
    categoria_cnh CHAR(2) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT pk_motorista PRIMARY KEY (id_motorista),
    CONSTRAINT uq_motorista_cpf UNIQUE (cpf),
    CONSTRAINT uq_motorista_cnh UNIQUE (cnh),
    CONSTRAINT ck_motorista_cpf CHECK (cpf ~ '^[0-9]{11}$'),
    CONSTRAINT ck_motorista_categoria CHECK (
        categoria_cnh IN ('A', 'B', 'C', 'D', 'E', 'AB', 'AC', 'AD', 'AE')
    )
);

-- =========================================================
-- 12. REMESSAS
-- =========================================================
CREATE TABLE remessa (
    id_remessa BIGINT GENERATED ALWAYS AS IDENTITY,
    id_pedido BIGINT NOT NULL,
    id_centro_origem BIGINT NOT NULL,
    id_veiculo BIGINT NOT NULL,
    id_motorista BIGINT NOT NULL,
    codigo_rastreio VARCHAR(40) NOT NULL,
    data_postagem TIMESTAMP NOT NULL,
    previsao_entrega DATE NOT NULL,
    data_entrega TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'POSTADO',
    custo_frete NUMERIC(12,2) NOT NULL DEFAULT 0,

    CONSTRAINT pk_remessa PRIMARY KEY (id_remessa),
    CONSTRAINT uq_remessa_codigo_rastreio UNIQUE (codigo_rastreio),

    CONSTRAINT fk_remessa_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES pedido (id_pedido)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_remessa_centro
        FOREIGN KEY (id_centro_origem)
        REFERENCES centro_distribuicao (id_centro)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_remessa_veiculo
        FOREIGN KEY (id_veiculo)
        REFERENCES veiculo (id_veiculo)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_remessa_motorista
        FOREIGN KEY (id_motorista)
        REFERENCES motorista (id_motorista)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT ck_remessa_status CHECK (
        status IN ('POSTADO', 'EM_TRANSITO', 'ENTREGUE', 'DEVOLVIDO', 'CANCELADO')
    ),

    CONSTRAINT ck_remessa_previsao CHECK (
        previsao_entrega >= data_postagem::DATE
    ),

    CONSTRAINT ck_remessa_custo_frete CHECK (custo_frete >= 0)
);

-- =========================================================
-- 13. EVENTOS DE RASTREAMENTO
-- =========================================================
CREATE TABLE rastreamento (
    id_rastreamento BIGINT GENERATED ALWAYS AS IDENTITY,
    id_remessa BIGINT NOT NULL,
    data_evento TIMESTAMP NOT NULL,
    status VARCHAR(30) NOT NULL,
    localizacao VARCHAR(180) NOT NULL,
    descricao VARCHAR(255),

    CONSTRAINT pk_rastreamento PRIMARY KEY (id_rastreamento),

    CONSTRAINT fk_rastreamento_remessa
        FOREIGN KEY (id_remessa)
        REFERENCES remessa (id_remessa)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT ck_rastreamento_status CHECK (
        status IN (
            'COLETADO',
            'EM_TRANSFERENCIA',
            'EM_ROTA',
            'SAIU_PARA_ENTREGA',
            'ENTREGUE',
            'OCORRENCIA'
        )
    )
);