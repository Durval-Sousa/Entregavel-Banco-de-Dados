# Sprint 3 — Normalização até a 3FN

Esta Sprint dá continuidade ao sistema de avaliação de restaurantes desenvolvido na Sprint 2. O modelo conceitual foi transformado em um modelo lógico relacional e implementado no PostgreSQL.

## Primeira Forma Normal — 1FN

O banco está na 1FN porque cada tabela possui uma chave primária e todos os atributos possuem valores atômicos. Não há listas ou grupos repetitivos em uma coluna.

Exemplo: os pratos são armazenados como registros separados na tabela `prato`, e não como uma lista dentro da tabela `restaurante`.

## Segunda Forma Normal — 2FN

O modelo está na 2FN porque está na 1FN e os atributos não-chave dependem integralmente da chave primária da própria tabela.

Os dados de usuários foram separados em `usuario`, os dados das categorias foram separados em `categoria`, e os dados dos restaurantes foram separados em `restaurante`.

## Terceira Forma Normal — 3FN

O modelo está na 3FN porque está na 2FN e não possui dependências transitivas relevantes.

Dependências eliminadas:
- O nome da categoria não se repete dentro de cada restaurante; fica na tabela `categoria`.
- O endereço não fica repetido nos dados do restaurante; fica na tabela `endereco`.
- O nome e o e-mail do usuário não se repetem em cada avaliação; ficam na tabela `usuario`.
- O nome do restaurante e seu telefone não se repetem em cada prato nem em cada avaliação; ficam na tabela `restaurante`.
- A tabela `avaliacao` registra apenas nota, comentário, usuário e restaurante relacionados.

## Dados e consultas

Foram inseridos três registros em cada tabela e foram criadas duas consultas usando JOIN para testar os relacionamentos entre usuários, restaurantes, categorias, pratos, endereços e avaliações.