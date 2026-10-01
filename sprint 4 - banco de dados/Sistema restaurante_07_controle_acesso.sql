-- Role de grupo para usuários que só podem consultar dados.
CREATE ROLE leitor_restaurantes NOLOGIN;

-- Usuário 1: somente leitura.
CREATE USER usuario_leitura
WITH PASSWORD 'Leitura@2026';

-- Usuário 2: responsável por registrar avaliações.
CREATE USER usuario_avaliador
WITH PASSWORD 'Avaliador@2026';

-- Remove permissões padrão do schema public.
REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC;

-- Permite que a role de leitura acesse o schema e leia tabelas.
GRANT USAGE ON SCHEMA public TO leitor_restaurantes;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO leitor_restaurantes;

-- Inclui o usuário de leitura na role.
GRANT leitor_restaurantes TO usuario_leitura;

-- Usuário avaliador pode consultar dados necessários.
GRANT USAGE ON SCHEMA public TO usuario_avaliador;
GRANT SELECT ON categoria, restaurante, endereco, prato TO usuario_avaliador;

-- Usuário avaliador pode inserir e consultar avaliações.
GRANT SELECT, INSERT ON avaliacao TO usuario_avaliador;

-- Necessário para usar IDs automáticos, caso o avaliador
-- faça INSERT em tabelas com identity/sequence.
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO usuario_avaliador;

-- Remove explicitamente permissões que o avaliador não deve ter.
REVOKE UPDATE, DELETE, TRUNCATE ON ALL TABLES IN SCHEMA public
FROM usuario_avaliador;