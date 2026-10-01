# Sistema de Avaliação de Restaurantes

Projeto de banco de dados relacional desenvolvido com PostgreSQL e DBeaver.

## Tecnologias

- PostgreSQL
- DBeaver
- SQL
- Git e GitHub

## Estrutura do projeto

- `sql/01_schema.sql`: criação das tabelas, tipos, constraints e relacionamentos.
- `sql/02_inserts.sql`: inserção dos dados iniciais.
- `sql/03_consultas.sql`: consultas SQL do sistema.
- `sql/04_indices.sql`: criação de índices para otimização.
- `sql/05_transacoes.sql`: transações, savepoints, rollback e commit.
- `sql/06_explain_analyze.sql`: análise de desempenho das consultas.
- `sql/07_controle_acesso.sql`: roles, usuários, permissões, GRANT e REVOKE.

## Ordem de execução

1. `sql/01_schema.sql`
2. `sql/02_inserts.sql`
3. `sql/03_consultas.sql`
4. `sql/04_indices.sql`
5. `sql/05_transacoes.sql`
6. `sql/06_explain_analyze.sql`
7. `sql/07_controle_acesso.sql`

## Modelo de dados

- Uma categoria pode possuir vários restaurantes.
- Cada restaurante possui um endereço.
- Um restaurante pode possuir vários pratos.
- Usuários podem avaliar restaurantes.
- O sistema possui controle de acesso por roles e permissões.