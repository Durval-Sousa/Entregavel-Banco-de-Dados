# RotaCerta Logística — Grupo 2

## Modelo de negócio

A RotaCerta Logística é uma empresa fictícia de fulfillment e distribuição
voltada para pequenas e médias lojas virtuais. O negócio oferece serviços de
armazenagem, controle de estoque, separação de pedidos, despacho, transporte
e rastreamento de entregas.

As lojas parceiras enviam seus produtos para os centros de distribuição da
RotaCerta. Quando um cliente final realiza uma compra, o sistema registra o
pedido, verifica a disponibilidade no estoque, separa os itens, cria uma
remessa, define motorista e veículo e acompanha a entrega por eventos de
rastreamento até a confirmação de recebimento.

## Problema resolvido

Pequenas lojas virtuais frequentemente não possuem estrutura própria para
armazenar produtos, controlar estoque e realizar entregas. A RotaCerta
centraliza essas atividades e oferece visibilidade sobre pedidos, estoque,
remessas, atrasos e entregas concluídas.

## Público-alvo

- Pequenas e médias lojas virtuais
- Vendedores de marketplace
- Empresas que precisam terceirizar armazenamento e entregas
- Clientes finais que acompanham seus pedidos

## Processo operacional

1. O fornecedor ou loja parceira cadastra seus produtos.
2. Os produtos são enviados e armazenados em um centro de distribuição.
3. O estoque é registrado por produto e centro de distribuição.
4. O cliente realiza um pedido.
5. O sistema cria os itens do pedido e reserva o estoque.
6. A operação logística separa e despacha a mercadoria.
7. Uma remessa é criada com veículo, motorista e código de rastreio.
8. Eventos de rastreamento acompanham o deslocamento.
9. A entrega é confirmada ou registrada como ocorrência/cancelamento.

## Implementação MongoDB — Sprint 6

Foi criado o banco `rotacerta_sprint6` no MongoDB, utilizando o MongoDB
Compass na conexão local `localhost:27017`.

A implementação contempla duas collections relacionadas ao domínio
logístico:

| Collection | Descrição | Quantidade de documentos |
|---|---|---:|
| `clientes` | Cadastro dos clientes | 10 |
| `remessas` | Registro das remessas | 10 |

### Modelagem dos documentos

Foi utilizado embedding nos campos de endereço do cliente, destino e
itens da remessa. Essas informações ficam embutidas porque são acessadas
junto com o documento principal. O destino armazenado na remessa
representa o endereço registrado para aquela entrega.

Foi utilizado referencing no campo `cliente_id` das remessas, que
referencia o `_id` do cliente. Essa abordagem permite associar várias
remessas a um mesmo cliente sem repetir seu cadastro em cada documento.

A flexibilidade de esquema foi demonstrada por campos opcionais, como
preferências e contato comercial nos clientes, além de informações de
temperatura controlada e comprovante de recebimento nas remessas.

### Consultas e índices

Foram realizadas consultas com filtro por status, ordenação por data
de criação e projeção de campos.

Foram criados dois índices adicionais:

- `idx_cliente_email`: índice simples e único sobre o campo `email`.
- `idx_remessa_status_data`: índice composto sobre os campos `status`
  e `criado_em`.

A consulta de remessas foi analisada com `explain()`, considerando o
plano de execução e as estatísticas de documentos e entradas de índice
examinados.

### Evidências

Foram realizadas quatro capturas de tela no MongoDB Compass para
documentar a implementação.