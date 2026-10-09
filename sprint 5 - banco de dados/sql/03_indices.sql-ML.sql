-- =========================================================
-- 03_indices.sql
-- Índices da RotaCerta Logística
-- Execute depois de 01_ddl.sql e 02_inserts.sql
-- =========================================================

SET search_path TO rotacerta, public;

-- Painel operacional:
-- filtra pedidos por status e ordena pela data.
CREATE INDEX IF NOT EXISTS idx_pedido_status_data
    ON pedido (status, data_pedido DESC);

-- Histórico de pedidos de cada cliente.
CREATE INDEX IF NOT EXISTS idx_pedido_cliente
    ON pedido (id_cliente);

-- Produtos de cada loja parceira.
CREATE INDEX IF NOT EXISTS idx_produto_loja
    ON produto (id_loja);

-- Produtos por categoria.
CREATE INDEX IF NOT EXISTS idx_produto_categoria
    ON produto (id_categoria);

-- Consulta de estoque de um produto.
CREATE INDEX IF NOT EXISTS idx_estoque_produto
    ON estoque (id_produto);

-- Apoia consulta de produtos próximos ao ponto de reposição.
CREATE INDEX IF NOT EXISTS idx_estoque_quantidade_reposicao
    ON estoque (quantidade_disponivel, ponto_reposicao);

-- Entregas abertas, atrasadas ou próximas da data prevista.
CREATE INDEX IF NOT EXISTS idx_remessa_status_previsao
    ON remessa (status, previsao_entrega);

-- Relatório de remessas feitas por motorista.
CREATE INDEX IF NOT EXISTS idx_remessa_motorista
    ON remessa (id_motorista);

-- Busca do último evento de cada rastreio.
CREATE INDEX IF NOT EXISTS idx_rastreamento_remessa_data
    ON rastreamento (id_remessa, data_evento DESC);

-- Relatório dos produtos vendidos.
CREATE INDEX IF NOT EXISTS idx_item_pedido_produto
    ON item_pedido (id_produto);

-- Atualiza as estatísticas para o planejador de consultas.
ANALYZE;