# Sistema de Avaliação de Restaurantes

## Cenário

O sistema permite que clientes avaliem restaurantes,
informando uma nota, um comentário e a data da avaliação.

## Entidades

As entidades do sistema são:

- Cliente
- Restaurante
- Avaliação

## Atributos

### Cliente

- id_cliente (PK)
- nome
- email
- telefone

### Restaurante

- id_restaurante (PK)
- nome
- endereco
- categoria
- telefone

### Avaliação

- id_avaliacao (PK)
- nota
- comentario
- data_avaliacao
- id_cliente (FK)
- id_restaurante (FK)

## Relacionamentos

- Um cliente pode fazer várias avaliações: Cliente 1:N Avaliação.
- Um restaurante pode receber várias avaliações: Restaurante 1:N Avaliação.
- Cada avaliação pertence a um cliente e a um restaurante.
- Cliente e Restaurante possuem uma relação N:N resolvida pela entidade Avaliação.
