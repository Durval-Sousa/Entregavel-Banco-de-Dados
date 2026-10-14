-- =========================================================
-- 07_explain.sql
-- RotaCerta Logistica
-- Analise de desempenho com EXPLAIN ANALYZE
-- =========================================================

SET search_path TO rotacerta, public;

-- Atualiza as estatisticas utilizadas pelo PostgreSQL
-- para escolher o plano de execucao.
ANALYZE;

-- =========================================================
-- 1. Pedidos por status e data
-- Indice relacionado: idx_pedido_status_data
-- =========================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    numero_pedido,
    data_pedido,
    status,
    valor_total
FROM pedido
WHERE status IN ('PAGO', 'SEPARACAO', 'EM_ROTA')
ORDER BY data_pedido DESC;

-- =========================================================
-- 2. Rastreamento de uma remessa especifica
-- Indice relacionado: idx_rastreamento_remessa_data
-- =========================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    r.codigo_rastreio,
    rt.data_evento,
    rt.status,
    rt.localizacao
FROM remessa r
JOIN rastreamento rt
    ON rt.id_remessa = r.id_remessa
WHERE r.codigo_rastreio = 'BRLOG000002'
ORDER BY rt.data_evento DESC;

-- =========================================================
-- 3. Produtos por categoria
-- Indice relacionado: idx_produto_categoria
-- =========================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    p.sku,
    p.nome,
    p.preco_unitario
FROM produto p
JOIN categoria_produto cp
    ON cp.id_categoria = p.id_categoria
WHERE cp.nome = 'Informatica';

-- =========================================================
-- 4. Remessas abertas por previsao de entrega
-- Indice relacionado: idx_remessa_status_previsao
-- =========================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    codigo_rastreio,
    previsao_entrega,
    status,
    custo_frete
FROM remessa
WHERE status IN ('POSTADO', 'EM_TRANSITO')
ORDER BY previsao_entrega;

-- =========================================================
-- 5. Itens associados a um produto
-- Indice relacionado: idx_item_pedido_produto
-- =========================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    p.sku,
    p.nome AS produto,
    ip.quantidade,
    ip.preco_unitario,
    ip.desconto
FROM item_pedido ip
JOIN produto p
    ON p.id_produto = ip.id_produto
WHERE p.sku = 'SKU-001';