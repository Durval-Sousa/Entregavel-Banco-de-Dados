SELECT
    a.id_avaliacao,
    u.nome AS usuario,
    r.nome AS restaurante,
    a.nota,
    a.comentario
FROM avaliacao a
JOIN usuario u
    ON u.id_usuario = a.id_usuario
JOIN restaurante r
    ON r.id_restaurante = a.id_restaurante
ORDER BY a.nota DESC;


SELECT
    r.nome AS restaurante,
    c.nome AS categoria,
    p.nome AS prato,
    p.preco,
    e.logradouro,
    e.numero,
    e.bairro,
    e.cidade,
    e.estado
FROM restaurante r
JOIN categoria c
    ON c.id_categoria = r.id_categoria
JOIN prato p
    ON p.id_restaurante = r.id_restaurante
JOIN endereco e
    ON e.id_restaurante = r.id_restaurante
ORDER BY r.nome;