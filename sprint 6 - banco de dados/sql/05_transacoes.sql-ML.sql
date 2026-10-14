-- =========================================================
-- 05_transacoes.sql
-- Projeto: RotaCerta Logistica
-- Sprint 5 - Transacoes
-- PostgreSQL / DBeaver
-- =========================================================

SET search_path TO rotacerta, public;


-- =========================================================
-- TRANSACAO 1
-- Cria um pedido de teste, adiciona item, reserva estoque
-- e gera uma remessa. Tudo e confirmado com COMMIT.
-- =========================================================

BEGIN;

-- Cria o pedido de teste.
-- ON CONFLICT evita duplicidade se voce executar novamente.
INSERT INTO pedido (
    id_cliente,
    id_endereco_entrega,
    numero_pedido,
    data_pedido,
    status,
    valor_total,
    observacao
)
SELECT
    c.id_cliente,
    e.id_endereco,
    'PED-TRANS-0001',
    CURRENT_TIMESTAMP,
    'PAGO',
    399.80,
    'Pedido criado na transacao 1'
FROM cliente c
JOIN endereco_cliente e
    ON e.id_cliente = c.id_cliente
   AND e.principal = TRUE
WHERE c.cpf = '00000000001'
ON CONFLICT (numero_pedido) DO NOTHING;

-- Inclui dois fones Bluetooth no pedido.
INSERT INTO item_pedido (
    id_pedido,
    id_produto,
    quantidade,
    preco_unitario,
    desconto
)
SELECT
    p.id_pedido,
    pr.id_produto,
    2,
    pr.preco_unitario,
    0.00
FROM pedido p
JOIN produto pr
    ON pr.sku = 'SKU-001'
WHERE p.numero_pedido = 'PED-TRANS-0001'
ON CONFLICT (id_pedido, id_produto) DO NOTHING;

-- Reserva duas unidades apenas uma vez.
-- A condicao NOT EXISTS impede reduzir o estoque se a
-- remessa de teste ja tiver sido criada antes.
UPDATE estoque e
SET
    quantidade_disponivel = e.quantidade_disponivel - 2,
    quantidade_reservada = e.quantidade_reservada + 2,
    atualizado_em = CURRENT_TIMESTAMP
WHERE e.id_centro = (
    SELECT id_centro
    FROM centro_distribuicao
    WHERE codigo = 'CD-SLN-01'
)
AND e.id_produto = (
    SELECT id_produto
    FROM produto
    WHERE sku = 'SKU-001'
)
AND e.quantidade_disponivel >= 2
AND NOT EXISTS (
    SELECT 1
    FROM remessa r
    WHERE r.codigo_rastreio = 'BRLOG-TRANS-0001'
);

-- Cria a remessa de teste.
INSERT INTO remessa (
    id_pedido,
    id_centro_origem,
    id_veiculo,
    id_motorista,
    codigo_rastreio,
    data_postagem,
    previsao_entrega,
    data_entrega,
    status,
    custo_frete
)
SELECT
    p.id_pedido,
    cd.id_centro,
    v.id_veiculo,
    m.id_motorista,
    'BRLOG-TRANS-0001',
    CURRENT_TIMESTAMP,
    CURRENT_DATE + 3,
    NULL,
    'POSTADO',
    18.00
FROM pedido p
JOIN centro_distribuicao cd
    ON cd.codigo = 'CD-SLN-01'
JOIN veiculo v
    ON v.placa = 'ABC1D01'
JOIN motorista m
    ON m.cpf = '11111111101'
WHERE p.numero_pedido = 'PED-TRANS-0001'
ON CONFLICT (codigo_rastreio) DO NOTHING;

COMMIT;


-- =========================================================
-- CONSULTA DE CONFERENCIA DA TRANSACAO 1
-- =========================================================

SELECT
    p.numero_pedido,
    p.status AS status_pedido,
    p.valor_total,
    pr.nome AS produto,
    ip.quantidade,
    r.codigo_rastreio,
    r.status AS status_remessa
FROM pedido p
JOIN item_pedido ip
    ON ip.id_pedido = p.id_pedido
JOIN produto pr
    ON pr.id_produto = ip.id_produto
LEFT JOIN remessa r
    ON r.id_pedido = p.id_pedido
WHERE p.numero_pedido = 'PED-TRANS-0001';


-- =========================================================
-- TRANSACAO 2
-- Demonstra SAVEPOINT e ROLLBACK TO SAVEPOINT.
--
-- Primeiro, faz uma reserva temporaria VALIDA de 1 unidade.
-- Depois, desfaz SOMENTE essa reserva.
-- Por fim, faz uma atualizacao valida no horario do estoque.
-- =========================================================

BEGIN;

SAVEPOINT reserva_temporaria;

-- Alteracao temporaria valida:
-- 1 sai do disponivel e 1 entra no reservado.
UPDATE estoque e
SET
    quantidade_disponivel = e.quantidade_disponivel - 1,
    quantidade_reservada = e.quantidade_reservada + 1,
    atualizado_em = CURRENT_TIMESTAMP
WHERE e.id_centro = (
    SELECT id_centro
    FROM centro_distribuicao
    WHERE codigo = 'CD-SLN-01'
)
AND e.id_produto = (
    SELECT id_produto
    FROM produto
    WHERE sku = 'SKU-001'
)
AND e.quantidade_disponivel >= 1;

-- Desfaz apenas a reserva temporaria de uma unidade.
ROLLBACK TO SAVEPOINT reserva_temporaria;

-- Alteracao valida que sera mantida:
-- atualiza somente o horario da conferencia do estoque.
UPDATE estoque e
SET atualizado_em = CURRENT_TIMESTAMP
WHERE e.id_centro = (
    SELECT id_centro
    FROM centro_distribuicao
    WHERE codigo = 'CD-SLN-01'
)
AND e.id_produto = (
    SELECT id_produto
    FROM produto
    WHERE sku = 'SKU-001'
);

COMMIT;


-- =========================================================
-- CONSULTA DE CONFERENCIA DA TRANSACAO 2
-- A quantidade fica igual ao resultado da transacao 1,
-- porque a reserva temporaria foi desfeita pelo rollback.
-- =========================================================

SELECT
    cd.codigo AS centro,
    pr.sku,
    pr.nome AS produto,
    e.quantidade_disponivel,
    e.quantidade_reservada,
    e.ponto_reposicao,
    e.atualizado_em
FROM estoque e
JOIN centro_distribuicao cd
    ON cd.id_centro = e.id_centro
JOIN produto pr
    ON pr.id_produto = e.id_produto
WHERE cd.codigo = 'CD-SLN-01'
  AND pr.sku = 'SKU-001';