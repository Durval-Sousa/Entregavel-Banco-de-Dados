-- =========================================================
-- 04_consultas.sql
-- Consultas da RotaCerta Logística
-- =========================================================

SET search_path TO rotacerta, public;

-- =========================================================
-- 1. Pedidos com cliente e endereço de entrega.
-- =========================================================
SELECT
    p.numero_pedido,
    c.nome AS cliente,
    e.logradouro,
    e.numero,
    e.complemento,
    e.bairro,
    e.cidade,
    e.estado,
    p.status,
    p.valor_total,
    p.data_pedido
FROM pedido p
JOIN cliente c
    ON c.id_cliente = p.id_cliente
JOIN endereco_cliente e
    ON e.id_endereco = p.id_endereco_entrega
ORDER BY p.data_pedido DESC;

-- =========================================================
-- 2. Produtos com categoria e loja parceira.
-- =========================================================
SELECT
    p.sku,
    p.nome AS produto,
    cp.nome AS categoria,
    lp.nome_fantasia AS loja_parceira,
    p.peso_kg,
    p.preco_unitario
FROM produto p
JOIN categoria_produto cp
    ON cp.id_categoria = p.id_categoria
JOIN loja_parceira lp
    ON lp.id_loja = p.id_loja
ORDER BY lp.nome_fantasia, p.nome;

-- =========================================================
-- 3. Estoque por centro de distribuição.
-- =========================================================
SELECT
    cd.codigo AS codigo_centro,
    cd.nome AS centro_distribuicao,
    p.sku,
    p.nome AS produto,
    e.quantidade_disponivel,
    e.quantidade_reservada,
    e.ponto_reposicao,
    e.atualizado_em
FROM estoque e
JOIN centro_distribuicao cd
    ON cd.id_centro = e.id_centro
JOIN produto p
    ON p.id_produto = e.id_produto
ORDER BY cd.codigo, p.sku;

-- =========================================================
-- 4. Produtos em ponto de reposição.
-- =========================================================
SELECT
    cd.codigo AS centro,
    p.sku,
    p.nome AS produto,
    e.quantidade_disponivel,
    e.ponto_reposicao
FROM estoque e
JOIN centro_distribuicao cd
    ON cd.id_centro = e.id_centro
JOIN produto p
    ON p.id_produto = e.id_produto
WHERE e.quantidade_disponivel <= e.ponto_reposicao
ORDER BY e.quantidade_disponivel ASC, p.nome;

-- =========================================================
-- 5. Faturamento por status de pedido.
-- =========================================================
SELECT
    p.status,
    COUNT(*) AS quantidade_pedidos,
    SUM(p.valor_total) AS faturamento_total,
    ROUND(AVG(p.valor_total), 2) AS ticket_medio
FROM pedido p
GROUP BY p.status
ORDER BY faturamento_total DESC;

-- =========================================================
-- 6. Histórico e total gasto por cliente.
-- =========================================================
SELECT
    c.nome AS cliente,
    c.email,
    COUNT(p.id_pedido) AS total_pedidos,
    COALESCE(SUM(p.valor_total), 0) AS valor_gasto
FROM cliente c
LEFT JOIN pedido p
    ON p.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome, c.email
ORDER BY valor_gasto DESC, c.nome;

-- =========================================================
-- 7. Produtos vendidos e faturamento por produto.
-- =========================================================
SELECT
    pr.sku,
    pr.nome AS produto,
    SUM(ip.quantidade) AS quantidade_vendida,
    SUM(ip.quantidade * ip.preco_unitario - ip.desconto) AS faturamento
FROM item_pedido ip
JOIN produto pr
    ON pr.id_produto = ip.id_produto
GROUP BY pr.id_produto, pr.sku, pr.nome
ORDER BY quantidade_vendida DESC, faturamento DESC;

-- =========================================================
-- 8. Remessas em trânsito ou postadas.
-- =========================================================
SELECT
    r.codigo_rastreio,
    p.numero_pedido,
    c.nome AS cliente,
    m.nome AS motorista,
    v.placa,
    v.tipo AS tipo_veiculo,
    r.data_postagem,
    r.previsao_entrega,
    r.status,
    r.custo_frete
FROM remessa r
JOIN pedido p
    ON p.id_pedido = r.id_pedido
JOIN cliente c
    ON c.id_cliente = p.id_cliente
JOIN motorista m
    ON m.id_motorista = r.id_motorista
JOIN veiculo v
    ON v.id_veiculo = r.id_veiculo
WHERE r.status IN ('POSTADO', 'EM_TRANSITO')
ORDER BY r.previsao_entrega, r.codigo_rastreio;

-- =========================================================
-- 9. Último evento de rastreamento de cada remessa.
-- =========================================================
SELECT
    r.codigo_rastreio,
    ultimo.data_evento,
    ultimo.status,
    ultimo.localizacao,
    ultimo.descricao
FROM remessa r
JOIN LATERAL (
    SELECT
        rt.data_evento,
        rt.status,
        rt.localizacao,
        rt.descricao
    FROM rastreamento rt
    WHERE rt.id_remessa = r.id_remessa
    ORDER BY rt.data_evento DESC, rt.id_rastreamento DESC
    LIMIT 1
) AS ultimo ON TRUE
ORDER BY ultimo.data_evento DESC;

-- =========================================================
-- 10. Pedidos acima da média de pedidos não cancelados.
-- =========================================================
SELECT
    p.numero_pedido,
    c.nome AS cliente,
    p.valor_total,
    p.status
FROM pedido p
JOIN cliente c
    ON c.id_cliente = p.id_cliente
WHERE p.valor_total > (
    SELECT AVG(valor_total)
    FROM pedido
    WHERE status <> 'CANCELADO'
)
ORDER BY p.valor_total DESC;

-- =========================================================
-- 11. Centros com capacidade maior que a média.
-- =========================================================
SELECT
    cd.nome,
    cd.codigo,
    cd.cidade,
    cd.estado,
    cd.capacidade_maxima_kg
FROM centro_distribuicao cd
WHERE cd.capacidade_maxima_kg > (
    SELECT AVG(capacidade_maxima_kg)
    FROM centro_distribuicao
)
ORDER BY cd.capacidade_maxima_kg DESC;

-- =========================================================
-- 12. Quantidade de remessas por motorista.
-- =========================================================
SELECT
    m.nome AS motorista,
    COUNT(r.id_remessa) AS total_remessas,
    COUNT(*) FILTER (
        WHERE r.status = 'ENTREGUE'
    ) AS entregas_concluidas,
    COUNT(*) FILTER (
        WHERE r.status IN ('POSTADO', 'EM_TRANSITO')
    ) AS entregas_abertas
FROM motorista m
LEFT JOIN remessa r
    ON r.id_motorista = m.id_motorista
GROUP BY m.id_motorista, m.nome
ORDER BY total_remessas DESC, m.nome;

-- =========================================================
-- 13. Clientes sem pedidos.
-- =========================================================
SELECT
    c.id_cliente,
    c.nome,
    c.email,
    c.telefone
FROM cliente c
WHERE NOT EXISTS (
    SELECT 1
    FROM pedido p
    WHERE p.id_cliente = c.id_cliente
)
ORDER BY c.nome;

-- =========================================================
-- 14. Remessas em atraso.
-- Uma remessa está atrasada se ainda não foi entregue
-- e sua data prevista é anterior à data atual.
-- =========================================================
SELECT
    r.codigo_rastreio,
    p.numero_pedido,
    c.nome AS cliente,
    r.previsao_entrega,
    r.status
FROM remessa r
JOIN pedido p
    ON p.id_pedido = r.id_pedido
JOIN cliente c
    ON c.id_cliente = p.id_cliente
WHERE r.status IN ('POSTADO', 'EM_TRANSITO')
  AND r.previsao_entrega < CURRENT_DATE
ORDER BY r.previsao_entrega;

-- =========================================================
-- 15. CTE: resumo do estoque por centro.
-- =========================================================
WITH resumo_estoque AS (
    SELECT
        cd.id_centro,
        cd.nome AS centro_distribuicao,
        COALESCE(SUM(e.quantidade_disponivel), 0) AS total_disponivel,
        COALESCE(SUM(e.quantidade_reservada), 0) AS total_reservado
    FROM centro_distribuicao cd
    LEFT JOIN estoque e
        ON e.id_centro = cd.id_centro
    GROUP BY cd.id_centro, cd.nome
)
SELECT
    centro_distribuicao,
    total_disponivel,
    total_reservado
FROM resumo_estoque
ORDER BY total_disponivel DESC;