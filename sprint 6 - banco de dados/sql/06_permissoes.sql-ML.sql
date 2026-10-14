-- =========================================================
-- 06_permissoes.sql
-- Controle de acesso da RotaCerta Logística
-- Execute conectado como postgres.
-- =========================================================

-- Cria uma role de leitura caso ela ainda não exista.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_catalog.pg_roles
        WHERE rolname = 'analista_logistico'
    ) THEN
        CREATE ROLE analista_logistico NOLOGIN;
    END IF;
END
$$;

-- Cria o usuário analista caso ainda não exista.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_catalog.pg_roles
        WHERE rolname = 'usuario_analista'
    ) THEN
        CREATE ROLE usuario_analista
        LOGIN
        PASSWORD 'AnalistaLogistica2026';
    END IF;
END
$$;

-- Cria o usuário operador caso ainda não exista.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_catalog.pg_roles
        WHERE rolname = 'operador_logistico'
    ) THEN
        CREATE ROLE operador_logistico
        LOGIN
        PASSWORD 'OperadorLogistica2026';
    END IF;
END
$$;

-- Remove permissões públicas no schema correto.
REVOKE ALL
ON SCHEMA rotacerta
FROM PUBLIC;

REVOKE ALL
ON ALL TABLES IN SCHEMA rotacerta
FROM PUBLIC;

REVOKE ALL
ON ALL SEQUENCES IN SCHEMA rotacerta
FROM PUBLIC;

-- =========================================================
-- PERFIL ANALISTA
-- Apenas leitura.
-- =========================================================

GRANT USAGE
ON SCHEMA rotacerta
TO analista_logistico;

GRANT SELECT
ON ALL TABLES IN SCHEMA rotacerta
TO analista_logistico;

GRANT analista_logistico
TO usuario_analista;

-- Garante que o analista não possa alterar dados.
REVOKE INSERT, UPDATE, DELETE, TRUNCATE
ON ALL TABLES IN SCHEMA rotacerta
FROM usuario_analista;

-- =========================================================
-- PERFIL OPERADOR
-- Leitura geral e escrita nas tabelas operacionais.
-- =========================================================

GRANT USAGE
ON SCHEMA rotacerta
TO operador_logistico;

GRANT SELECT
ON ALL TABLES IN SCHEMA rotacerta
TO operador_logistico;

GRANT INSERT, UPDATE
ON
    rotacerta.pedido,
    rotacerta.item_pedido,
    rotacerta.estoque,
    rotacerta.remessa,
    rotacerta.rastreamento
TO operador_logistico;

-- Permissão para usar IDs gerados por IDENTITY.
GRANT USAGE, SELECT
ON ALL SEQUENCES IN SCHEMA rotacerta
TO operador_logistico;

-- O operador não pode apagar os dados.
REVOKE DELETE, TRUNCATE
ON ALL TABLES IN SCHEMA rotacerta
FROM operador_logistico;

-- =========================================================
-- PERMISSÕES PADRÃO PARA OBJETOS FUTUROS
-- =========================================================

ALTER DEFAULT PRIVILEGES IN SCHEMA rotacerta
GRANT SELECT
ON TABLES
TO analista_logistico;

ALTER DEFAULT PRIVILEGES IN SCHEMA rotacerta
GRANT USAGE, SELECT
ON SEQUENCES
TO operador_logistico;

-- =========================================================
-- CONFERÊNCIA
-- =========================================================

SELECT
    rolname AS role,
    rolcanlogin AS permite_login
FROM pg_catalog.pg_roles
WHERE rolname IN (
    'analista_logistico',
    'usuario_analista',
    'operador_logistico'
)
ORDER BY rolname;

SELECT
    grantee,
    table_schema,
    table_name,
    privilege_type
FROM information_schema.role_table_grants
WHERE table_schema = 'rotacerta'
  AND grantee IN (
      'analista_logistico',
      'usuario_analista',
      'operador_logistico'
  )
ORDER BY
    grantee,
    table_name,
    privilege_type;