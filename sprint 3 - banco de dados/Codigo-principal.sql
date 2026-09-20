DROP TABLE IF EXISTS avaliacao CASCADE;
DROP TABLE IF EXISTS prato CASCADE;
DROP TABLE IF EXISTS endereco CASCADE;
DROP TABLE IF EXISTS restaurante CASCADE;
DROP TABLE IF EXISTS categoria CASCADE;
DROP TABLE IF EXISTS usuario CASCADE;

CREATE TABLE usuario (
    id_usuario BIGINT GENERATED ALWAYS AS IDENTITY,
    nome VARCHAR(120) NOT NULL,
    email VARCHAR(160) NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    data_cadastro DATE NOT NULL DEFAULT CURRENT_DATE,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_usuario PRIMARY KEY (id_usuario),
    CONSTRAINT uq_usuario_email UNIQUE (email),
    CONSTRAINT ck_usuario_email CHECK (POSITION('@' IN email) > 1)
);

CREATE TABLE categoria (
    id_categoria BIGINT GENERATED ALWAYS AS IDENTITY,
    nome VARCHAR(80) NOT NULL,
    descricao VARCHAR(255),
    CONSTRAINT pk_categoria PRIMARY KEY (id_categoria),
    CONSTRAINT uq_categoria_nome UNIQUE (nome)
);

CREATE TABLE restaurante (
    id_restaurante BIGINT GENERATED ALWAYS AS IDENTITY,
    id_categoria BIGINT NOT NULL,
    nome VARCHAR(140) NOT NULL,
    cnpj CHAR(14),
    telefone VARCHAR(20),
    email VARCHAR(160),
    descricao TEXT,
    horario_funcionamento VARCHAR(150),
    status VARCHAR(20) NOT NULL DEFAULT 'ATIVO',
    CONSTRAINT pk_restaurante PRIMARY KEY (id_restaurante),
    CONSTRAINT fk_restaurante_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES categoria (id_categoria)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT uq_restaurante_cnpj UNIQUE (cnpj),
    CONSTRAINT ck_restaurante_status
        CHECK (status IN ('ATIVO', 'INATIVO'))
);

CREATE TABLE endereco (
    id_endereco BIGINT GENERATED ALWAYS AS IDENTITY,
    id_restaurante BIGINT NOT NULL,
    logradouro VARCHAR(150) NOT NULL,
    numero VARCHAR(20) NOT NULL,
    complemento VARCHAR(80),
    bairro VARCHAR(80) NOT NULL,
    cidade VARCHAR(80) NOT NULL,
    estado CHAR(2) NOT NULL,
    cep CHAR(8) NOT NULL,
    CONSTRAINT pk_endereco PRIMARY KEY (id_endereco),
    CONSTRAINT fk_endereco_restaurante
        FOREIGN KEY (id_restaurante)
        REFERENCES restaurante (id_restaurante)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT uq_endereco_restaurante UNIQUE (id_restaurante),
    CONSTRAINT ck_endereco_estado CHECK (estado ~ '^[A-Z]{2}$'),
    CONSTRAINT ck_endereco_cep CHECK (cep ~ '^[0-9]{8}$')
);

CREATE TABLE prato (
    id_prato BIGINT GENERATED ALWAYS AS IDENTITY,
    id_restaurante BIGINT NOT NULL,
    nome VARCHAR(120) NOT NULL,
    descricao TEXT,
    preco NUMERIC(10,2) NOT NULL,
    disponivel BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_prato PRIMARY KEY (id_prato),
    CONSTRAINT fk_prato_restaurante
        FOREIGN KEY (id_restaurante)
        REFERENCES restaurante (id_restaurante)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT ck_prato_preco CHECK (preco >= 0),
    CONSTRAINT uq_prato_restaurante_nome UNIQUE (id_restaurante, nome)
);

CREATE TABLE avaliacao (
    id_avaliacao BIGINT GENERATED ALWAYS AS IDENTITY,
    id_usuario BIGINT NOT NULL,
    id_restaurante BIGINT NOT NULL,
    nota SMALLINT NOT NULL,
    comentario TEXT,
    data_avaliacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'PUBLICADA',
    CONSTRAINT pk_avaliacao PRIMARY KEY (id_avaliacao),
    CONSTRAINT fk_avaliacao_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_avaliacao_restaurante
        FOREIGN KEY (id_restaurante)
        REFERENCES restaurante (id_restaurante)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT ck_avaliacao_nota CHECK (nota BETWEEN 1 AND 5),
    CONSTRAINT ck_avaliacao_status
        CHECK (status IN ('PUBLICADA', 'OCULTA', 'EXCLUIDA')),
    CONSTRAINT uq_avaliacao_usuario_restaurante
        UNIQUE (id_usuario, id_restaurante)
);

CREATE INDEX idx_restaurante_categoria
    ON restaurante (id_categoria);

CREATE INDEX idx_prato_restaurante
    ON prato (id_restaurante);

CREATE INDEX idx_avaliacao_restaurante
    ON avaliacao (id_restaurante);

CREATE INDEX idx_avaliacao_usuario
    ON avaliacao (id_usuario);