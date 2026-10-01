-- =====================================================
-- EXPLAIN ANALYZE 1
-- Avaliações de um restaurante específico.
-- Deve poder usar idx_avaliacao_restaurante.
-- =====================================================

EXPLAIN ANALYZE
SELECT
    a.id_avaliacao,
    u.nome AS usuario,
    a.nota,
    a.comentario
FROM avaliacao a
JOIN usuario u
    ON u.id_usuario = a.id_usuario
WHERE a.id_restaurante = 1
ORDER BY a.id_avaliacao;


-- =====================================================
-- EXPLAIN ANALYZE 2
-- Pratos disponíveis de um restaurante.
-- Deve poder usar idx_prato_restaurante_disponivel.
-- =====================================================

EXPLAIN ANALYZE
SELECT
    p.id_prato,
    p.nome,
    p.preco
FROM prato p
WHERE p.id_restaurante = 1
  AND p.disponivel = TRUE
ORDER BY p.preco;