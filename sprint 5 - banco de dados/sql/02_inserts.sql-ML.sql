-- =========================================================
-- 02_inserts.sql
-- Dados iniciais da RotaCerta Logística
-- 15 registros por tabela
-- =========================================================

SET search_path TO rotacerta, public;

-- =========================================================
-- 1. CATEGORIAS: 15 registros
-- =========================================================
INSERT INTO categoria_produto (nome, descricao)
VALUES
    ('Eletronicos', 'Equipamentos eletrônicos e acessórios'),
    ('Informatica', 'Computadores e periféricos'),
    ('Telefonia', 'Celulares e acessórios'),
    ('Eletrodomesticos', 'Produtos para uso doméstico'),
    ('Moveis', 'Móveis corporativos e residenciais'),
    ('Papelaria', 'Materiais de escritório'),
    ('Ferramentas', 'Ferramentas manuais e elétricas'),
    ('Automotivo', 'Peças e acessórios automotivos'),
    ('Esporte', 'Artigos esportivos'),
    ('Brinquedos', 'Brinquedos e jogos'),
    ('Livros', 'Livros e materiais didáticos'),
    ('Moda', 'Vestuário e acessórios'),
    ('Pet Shop', 'Produtos para animais'),
    ('Alimentos', 'Produtos alimentícios'),
    ('Limpeza', 'Produtos de limpeza')
ON CONFLICT (nome) DO NOTHING;

-- =========================================================
-- 2. LOJAS PARCEIRAS: 15 registros
-- =========================================================
INSERT INTO loja_parceira (
    razao_social,
    nome_fantasia,
    cnpj,
    email,
    telefone
)
VALUES
    ('Tech Distribuidora LTDA', 'Tech Distribuidora', '10000000000001', 'contato@techdist.com', '(98) 99999-1001'),
    ('Info Supply LTDA', 'Info Supply', '10000000000002', 'contato@infosupply.com', '(98) 99999-1002'),
    ('Mobile Brasil LTDA', 'Mobile Brasil', '10000000000003', 'contato@mobilebrasil.com', '(98) 99999-1003'),
    ('Casa Forte LTDA', 'Casa Forte', '10000000000004', 'contato@casaforte.com', '(98) 99999-1004'),
    ('Moveis Prime LTDA', 'Moveis Prime', '10000000000005', 'contato@moveisprime.com', '(98) 99999-1005'),
    ('Papel Mais LTDA', 'Papel Mais', '10000000000006', 'contato@papelmais.com', '(98) 99999-1006'),
    ('Ferramenta Certa LTDA', 'Ferramenta Certa', '10000000000007', 'contato@ferramentacerta.com', '(98) 99999-1007'),
    ('Auto Pecas Norte LTDA', 'Auto Pecas Norte', '10000000000008', 'contato@autopecasnorte.com', '(98) 99999-1008'),
    ('Esporte Total LTDA', 'Esporte Total', '10000000000009', 'contato@esportetotal.com', '(98) 99999-1009'),
    ('Mundo Brincar LTDA', 'Mundo Brincar', '10000000000010', 'contato@mundobrincar.com', '(98) 99999-1010'),
    ('Editora Saber LTDA', 'Editora Saber', '10000000000011', 'contato@editorasaber.com', '(98) 99999-1011'),
    ('Moda Express LTDA', 'Moda Express', '10000000000012', 'contato@modaexpress.com', '(98) 99999-1012'),
    ('Pet Feliz LTDA', 'Pet Feliz', '10000000000013', 'contato@petfeliz.com', '(98) 99999-1013'),
    ('Alimentos Bom Sabor LTDA', 'Bom Sabor', '10000000000014', 'contato@bomsabor.com', '(98) 99999-1014'),
    ('Limpa Bem LTDA', 'Limpa Bem', '10000000000015', 'contato@limpabem.com', '(98) 99999-1015')
ON CONFLICT DO NOTHING;

-- =========================================================
-- 3. CLIENTES: 15 registros
-- =========================================================
INSERT INTO cliente (
    nome,
    cpf,
    email,
    telefone,
    data_cadastro
)
VALUES
    ('Ana Souza', '00000000001', 'ana.souza@email.com', '(98) 98888-1001', DATE '2026-01-05'),
    ('Bruno Lima', '00000000002', 'bruno.lima@email.com', '(98) 98888-1002', DATE '2026-01-08'),
    ('Carla Mendes', '00000000003', 'carla.mendes@email.com', '(98) 98888-1003', DATE '2026-01-10'),
    ('Daniel Rocha', '00000000004', 'daniel.rocha@email.com', '(98) 98888-1004', DATE '2026-01-11'),
    ('Elisa Martins', '00000000005', 'elisa.martins@email.com', '(98) 98888-1005', DATE '2026-01-12'),
    ('Felipe Costa', '00000000006', 'felipe.costa@email.com', '(98) 98888-1006', DATE '2026-01-15'),
    ('Gabriela Alves', '00000000007', 'gabriela.alves@email.com', '(98) 98888-1007', DATE '2026-01-16'),
    ('Henrique Silva', '00000000008', 'henrique.silva@email.com', '(98) 98888-1008', DATE '2026-01-17'),
    ('Isabela Freitas', '00000000009', 'isabela.freitas@email.com', '(98) 98888-1009', DATE '2026-01-18'),
    ('Joao Pereira', '00000000010', 'joao.pereira@email.com', '(98) 98888-1010', DATE '2026-01-20'),
    ('Karina Oliveira', '00000000011', 'karina.oliveira@email.com', '(98) 98888-1011', DATE '2026-01-21'),
    ('Lucas Fernandes', '00000000012', 'lucas.fernandes@email.com', '(98) 98888-1012', DATE '2026-01-22'),
    ('Mariana Castro', '00000000013', 'mariana.castro@email.com', '(98) 98888-1013', DATE '2026-01-23'),
    ('Nicolas Araujo', '00000000014', 'nicolas.araujo@email.com', '(98) 98888-1014', DATE '2026-01-24'),
    ('Olivia Barros', '00000000015', 'olivia.barros@email.com', '(98) 98888-1015', DATE '2026-01-25')
ON CONFLICT DO NOTHING;

-- =========================================================
-- 4. ENDEREÇOS: 15 registros
-- =========================================================
INSERT INTO endereco_cliente (
    id_cliente,
    logradouro,
    numero,
    complemento,
    bairro,
    cidade,
    estado,
    cep,
    principal
)
SELECT
    c.id_cliente,
    d.logradouro,
    d.numero,
    d.complemento,
    d.bairro,
    d.cidade,
    d.estado,
    d.cep,
    TRUE
FROM (
    VALUES
        ('00000000001', 'Rua das Palmeiras', '101', 'Apto 201', 'Cohama', 'Sao Luis', 'MA', '65074100'),
        ('00000000002', 'Avenida Litoranea', '202', 'Casa', 'Calhau', 'Sao Luis', 'MA', '65071200'),
        ('00000000003', 'Rua do Sol', '303', 'Apto 12', 'Centro', 'Sao Luis', 'MA', '65020100'),
        ('00000000004', 'Rua das Acacias', '404', 'Casa', 'Renascenca', 'Sao Luis', 'MA', '65075200'),
        ('00000000005', 'Avenida dos Holandeses', '505', 'Sala 10', 'Ponta d Areia', 'Sao Luis', 'MA', '65077000'),
        ('00000000006', 'Rua Grande', '606', 'Apto 32', 'Centro', 'Sao Luis', 'MA', '65020000'),
        ('00000000007', 'Rua do Ipe', '707', 'Casa', 'Turu', 'Sao Luis', 'MA', '65066700'),
        ('00000000008', 'Avenida Principal', '808', 'Bloco B', 'Cohatrac', 'Sao Luis', 'MA', '65054100'),
        ('00000000009', 'Rua Sao Joao', '909', 'Apto 15', 'Vinhais', 'Sao Luis', 'MA', '65071100'),
        ('00000000010', 'Rua das Flores', '110', 'Casa', 'Anil', 'Sao Luis', 'MA', '65045100'),
        ('00000000011', 'Avenida Jeronimo de Albuquerque', '120', 'Apto 43', 'Cohafuma', 'Sao Luis', 'MA', '65074000'),
        ('00000000012', 'Rua do Comercio', '130', 'Loja 2', 'Forquilha', 'Sao Luis', 'MA', '65052500'),
        ('00000000013', 'Rua Nova', '140', 'Casa', 'Cidade Operaria', 'Sao Luis', 'MA', '65058300'),
        ('00000000014', 'Avenida Kennedy', '150', 'Apto 22', 'Areinha', 'Sao Luis', 'MA', '65030000'),
        ('00000000015', 'Rua da Paz', '160', 'Casa', 'Maiobao', 'Paco do Lumiar', 'MA', '65130000')
) AS d (
    cpf,
    logradouro,
    numero,
    complemento,
    bairro,
    cidade,
    estado,
    cep
)
JOIN cliente c
    ON c.cpf = d.cpf
WHERE NOT EXISTS (
    SELECT 1
    FROM endereco_cliente e
    WHERE e.id_cliente = c.id_cliente
      AND e.logradouro = d.logradouro
      AND e.numero = d.numero
);

-- =========================================================
-- 5. CENTROS DE DISTRIBUIÇÃO: 15 registros
-- =========================================================
INSERT INTO centro_distribuicao (
    nome,
    codigo,
    cidade,
    estado,
    capacidade_maxima_kg
)
VALUES
    ('CD Sao Luis Norte', 'CD-SLN-01', 'Sao Luis', 'MA', 10000),
    ('CD Sao Luis Sul', 'CD-SLS-02', 'Sao Luis', 'MA', 9000),
    ('CD Imperatriz', 'CD-IMP-03', 'Imperatriz', 'MA', 8500),
    ('CD Teresina', 'CD-TER-04', 'Teresina', 'PI', 9000),
    ('CD Fortaleza', 'CD-FOR-05', 'Fortaleza', 'CE', 12000),
    ('CD Natal', 'CD-NAT-06', 'Natal', 'RN', 8000),
    ('CD Recife', 'CD-REC-07', 'Recife', 'PE', 11000),
    ('CD Salvador', 'CD-SAL-08', 'Salvador', 'BA', 11500),
    ('CD Belo Horizonte', 'CD-BHZ-09', 'Belo Horizonte', 'MG', 13000),
    ('CD Rio de Janeiro', 'CD-RIO-10', 'Rio de Janeiro', 'RJ', 14000),
    ('CD Sao Paulo', 'CD-SPO-11', 'Sao Paulo', 'SP', 20000),
    ('CD Curitiba', 'CD-CTB-12', 'Curitiba', 'PR', 12500),
    ('CD Florianopolis', 'CD-FLN-13', 'Florianopolis', 'SC', 10000),
    ('CD Porto Alegre', 'CD-POA-14', 'Porto Alegre', 'RS', 10500),
    ('CD Brasilia', 'CD-BSB-15', 'Brasilia', 'DF', 15000)
ON CONFLICT (codigo) DO NOTHING;

-- =========================================================
-- 6. PRODUTOS: 15 registros
-- =========================================================
INSERT INTO produto (
    id_loja,
    id_categoria,
    sku,
    nome,
    descricao,
    peso_kg,
    preco_unitario
)
SELECT
    lp.id_loja,
    cp.id_categoria,
    d.sku,
    d.nome,
    d.descricao,
    d.peso_kg,
    d.preco_unitario
FROM (
    VALUES
        ('Tech Distribuidora', 'Eletronicos', 'SKU-001', 'Fone Bluetooth', 'Fone sem fio', 0.250::numeric, 199.90::numeric),
        ('Info Supply', 'Informatica', 'SKU-002', 'Teclado Mecanico', 'Teclado RGB', 0.900::numeric, 349.90::numeric),
        ('Mobile Brasil', 'Telefonia', 'SKU-003', 'Carregador USB C', 'Carregador rapido', 0.180::numeric, 89.90::numeric),
        ('Casa Forte', 'Eletrodomesticos', 'SKU-004', 'Liquidificador', 'Liquidificador 900W', 2.500::numeric, 229.90::numeric),
        ('Moveis Prime', 'Moveis', 'SKU-005', 'Cadeira Escritorio', 'Cadeira ergonomica', 12.000::numeric, 799.90::numeric),
        ('Papel Mais', 'Papelaria', 'SKU-006', 'Papel A4', 'Resma de papel A4', 2.500::numeric, 32.90::numeric),
        ('Ferramenta Certa', 'Ferramentas', 'SKU-007', 'Furadeira', 'Furadeira eletrica', 2.100::numeric, 459.90::numeric),
        ('Auto Pecas Norte', 'Automotivo', 'SKU-008', 'Oleo Motor', 'Oleo 5W30', 1.000::numeric, 49.90::numeric),
        ('Esporte Total', 'Esporte', 'SKU-009', 'Bola de Futebol', 'Bola oficial', 0.450::numeric, 129.90::numeric),
        ('Mundo Brincar', 'Brinquedos', 'SKU-010', 'Jogo Educativo', 'Jogo de montar', 0.700::numeric, 99.90::numeric),
        ('Editora Saber', 'Livros', 'SKU-011', 'Livro SQL', 'Livro de banco de dados', 0.650::numeric, 119.90::numeric),
        ('Moda Express', 'Moda', 'SKU-012', 'Mochila Urbana', 'Mochila para notebook', 0.800::numeric, 189.90::numeric),
        ('Pet Feliz', 'Pet Shop', 'SKU-013', 'Racao Canina', 'Racao premium 10kg', 10.000::numeric, 179.90::numeric),
        ('Bom Sabor', 'Alimentos', 'SKU-014', 'Cafe Torrado', 'Pacote de cafe 500g', 0.500::numeric, 24.90::numeric),
        ('Limpa Bem', 'Limpeza', 'SKU-015', 'Detergente', 'Detergente 500ml', 0.600::numeric, 7.90::numeric)
) AS d (
    nome_loja,
    nome_categoria,
    sku,
    nome,
    descricao,
    peso_kg,
    preco_unitario
)
JOIN loja_parceira lp
    ON lp.nome_fantasia = d.nome_loja
JOIN categoria_produto cp
    ON cp.nome = d.nome_categoria
ON CONFLICT (sku) DO NOTHING;

-- =========================================================
-- 7. ESTOQUES: 15 registros
-- =========================================================
INSERT INTO estoque (
    id_centro,
    id_produto,
    quantidade_disponivel,
    quantidade_reservada,
    ponto_reposicao
)
SELECT
    cd.id_centro,
    p.id_produto,
    d.quantidade_disponivel,
    d.quantidade_reservada,
    d.ponto_reposicao
FROM (
    VALUES
        ('CD-SLN-01', 'SKU-001', 50, 5, 10),
        ('CD-SLS-02', 'SKU-002', 40, 4, 10),
        ('CD-IMP-03', 'SKU-003', 70, 8, 15),
        ('CD-TER-04', 'SKU-004', 30, 3, 8),
        ('CD-FOR-05', 'SKU-005', 18, 2, 5),
        ('CD-NAT-06', 'SKU-006', 100, 10, 20),
        ('CD-REC-07', 'SKU-007', 25, 4, 8),
        ('CD-SAL-08', 'SKU-008', 80, 6, 15),
        ('CD-BHZ-09', 'SKU-009', 60, 5, 12),
        ('CD-RIO-10', 'SKU-010', 45, 5, 10),
        ('CD-SPO-11', 'SKU-011', 90, 10, 20),
        ('CD-CTB-12', 'SKU-012', 55, 6, 12),
        ('CD-FLN-13', 'SKU-013', 35, 3, 10),
        ('CD-POA-14', 'SKU-014', 120, 12, 25),
        ('CD-BSB-15', 'SKU-015', 150, 15, 30)
) AS d (
    codigo_centro,
    sku,
    quantidade_disponivel,
    quantidade_reservada,
    ponto_reposicao
)
JOIN centro_distribuicao cd
    ON cd.codigo = d.codigo_centro
JOIN produto p
    ON p.sku = d.sku
ON CONFLICT (id_centro, id_produto) DO NOTHING;

-- =========================================================
-- 8. VEÍCULOS: 15 registros
-- =========================================================
INSERT INTO veiculo (
    placa,
    tipo,
    capacidade_kg,
    ano_fabricacao,
    status
)
VALUES
    ('ABC1D01', 'VAN', 1500.00, 2022, 'DISPONIVEL'),
    ('ABC1D02', 'VAN', 1500.00, 2023, 'DISPONIVEL'),
    ('ABC1D03', 'CAMINHAO', 8000.00, 2021, 'DISPONIVEL'),
    ('ABC1D04', 'CAMINHAO', 10000.00, 2022, 'DISPONIVEL'),
    ('ABC1D05', 'MOTO', 80.00, 2024, 'DISPONIVEL'),
    ('ABC1D06', 'VAN', 1800.00, 2023, 'DISPONIVEL'),
    ('ABC1D07', 'CAMINHAO', 6000.00, 2020, 'MANUTENCAO'),
    ('ABC1D08', 'MOTO', 90.00, 2024, 'DISPONIVEL'),
    ('ABC1D09', 'VAN', 1500.00, 2021, 'DISPONIVEL'),
    ('ABC1D10', 'CAMINHAO', 12000.00, 2023, 'DISPONIVEL'),
    ('ABC1D11', 'VAN', 1700.00, 2022, 'DISPONIVEL'),
    ('ABC1D12', 'MOTO', 75.00, 2023, 'DISPONIVEL'),
    ('ABC1D13', 'CAMINHAO', 9000.00, 2024, 'DISPONIVEL'),
    ('ABC1D14', 'VAN', 1600.00, 2020, 'DISPONIVEL'),
    ('ABC1D15', 'MOTO', 85.00, 2022, 'DISPONIVEL')
ON CONFLICT (placa) DO NOTHING;

-- =========================================================
-- 9. MOTORISTAS: 15 registros
-- =========================================================
INSERT INTO motorista (
    nome,
    cpf,
    cnh,
    categoria_cnh,
    telefone
)
VALUES
    ('Andre Santos', '11111111101', 'CNH000000001', 'B', '(98) 97777-1001'),
    ('Beatriz Lima', '11111111102', 'CNH000000002', 'B', '(98) 97777-1002'),
    ('Carlos Silva', '11111111103', 'CNH000000003', 'C', '(98) 97777-1003'),
    ('Debora Costa', '11111111104', 'CNH000000004', 'C', '(98) 97777-1004'),
    ('Eduardo Alves', '11111111105', 'CNH000000005', 'A', '(98) 97777-1005'),
    ('Fernanda Rocha', '11111111106', 'CNH000000006', 'B', '(98) 97777-1006'),
    ('Gustavo Mendes', '11111111107', 'CNH000000007', 'D', '(98) 97777-1007'),
    ('Helena Martins', '11111111108', 'CNH000000008', 'A', '(98) 97777-1008'),
    ('Igor Pereira', '11111111109', 'CNH000000009', 'B', '(98) 97777-1009'),
    ('Juliana Freitas', '11111111110', 'CNH000000010', 'D', '(98) 97777-1010'),
    ('Kleber Oliveira', '11111111111', 'CNH000000011', 'B', '(98) 97777-1011'),
    ('Larissa Castro', '11111111112', 'CNH000000012', 'A', '(98) 97777-1012'),
    ('Marcelo Araujo', '11111111113', 'CNH000000013', 'C', '(98) 97777-1013'),
    ('Natalia Barros', '11111111114', 'CNH000000014', 'B', '(98) 97777-1014'),
    ('Otavio Ribeiro', '11111111115', 'CNH000000015', 'A', '(98) 97777-1015')
ON CONFLICT DO NOTHING;

-- =========================================================
-- 10. PEDIDOS: 15 registros
-- Datas tipadas explicitamente como TIMESTAMP.
-- =========================================================
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
    d.numero_pedido,
    d.data_pedido,
    d.status,
    d.valor_total,
    d.observacao
FROM (
    VALUES
        ('00000000001', 'PED-2026-0001', TIMESTAMP '2026-02-01 08:00:00', 'ENTREGUE', 199.90::numeric, 'Entregar em horario comercial'),
        ('00000000002', 'PED-2026-0002', TIMESTAMP '2026-02-02 09:00:00', 'EM_ROTA', 349.90::numeric, NULL::varchar),
        ('00000000003', 'PED-2026-0003', TIMESTAMP '2026-02-03 10:00:00', 'PAGO', 89.90::numeric, NULL::varchar),
        ('00000000004', 'PED-2026-0004', TIMESTAMP '2026-02-04 11:00:00', 'SEPARACAO', 229.90::numeric, NULL::varchar),
        ('00000000005', 'PED-2026-0005', TIMESTAMP '2026-02-05 12:00:00', 'CRIADO', 799.90::numeric, 'Tocar interfone'),
        ('00000000006', 'PED-2026-0006', TIMESTAMP '2026-02-06 13:00:00', 'ENTREGUE', 32.90::numeric, NULL::varchar),
        ('00000000007', 'PED-2026-0007', TIMESTAMP '2026-02-07 14:00:00', 'EM_ROTA', 459.90::numeric, NULL::varchar),
        ('00000000008', 'PED-2026-0008', TIMESTAMP '2026-02-08 15:00:00', 'PAGO', 49.90::numeric, NULL::varchar),
        ('00000000009', 'PED-2026-0009', TIMESTAMP '2026-02-09 16:00:00', 'ENTREGUE', 129.90::numeric, NULL::varchar),
        ('00000000010', 'PED-2026-0010', TIMESTAMP '2026-02-10 17:00:00', 'SEPARACAO', 99.90::numeric, NULL::varchar),
        ('00000000011', 'PED-2026-0011', TIMESTAMP '2026-02-11 18:00:00', 'CRIADO', 119.90::numeric, NULL::varchar),
        ('00000000012', 'PED-2026-0012', TIMESTAMP '2026-02-12 09:30:00', 'PAGO', 189.90::numeric, NULL::varchar),
        ('00000000013', 'PED-2026-0013', TIMESTAMP '2026-02-13 10:30:00', 'EM_ROTA', 179.90::numeric, NULL::varchar),
        ('00000000014', 'PED-2026-0014', TIMESTAMP '2026-02-14 11:30:00', 'ENTREGUE', 24.90::numeric, NULL::varchar),
        ('00000000015', 'PED-2026-0015', TIMESTAMP '2026-02-15 12:30:00', 'CANCELADO', 7.90::numeric, 'Cliente solicitou cancelamento')
) AS d (
    cpf,
    numero_pedido,
    data_pedido,
    status,
    valor_total,
    observacao
)
JOIN cliente c
    ON c.cpf = d.cpf
JOIN endereco_cliente e
    ON e.id_cliente = c.id_cliente
   AND e.principal = TRUE
ON CONFLICT (numero_pedido) DO NOTHING;

-- =========================================================
-- 11. ITENS DE PEDIDOS: 15 registros
-- =========================================================
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
    1,
    pr.preco_unitario,
    0.00::numeric
FROM (
    VALUES
        ('PED-2026-0001', 'SKU-001'),
        ('PED-2026-0002', 'SKU-002'),
        ('PED-2026-0003', 'SKU-003'),
        ('PED-2026-0004', 'SKU-004'),
        ('PED-2026-0005', 'SKU-005'),
        ('PED-2026-0006', 'SKU-006'),
        ('PED-2026-0007', 'SKU-007'),
        ('PED-2026-0008', 'SKU-008'),
        ('PED-2026-0009', 'SKU-009'),
        ('PED-2026-0010', 'SKU-010'),
        ('PED-2026-0011', 'SKU-011'),
        ('PED-2026-0012', 'SKU-012'),
        ('PED-2026-0013', 'SKU-013'),
        ('PED-2026-0014', 'SKU-014'),
        ('PED-2026-0015', 'SKU-015')
) AS d (
    numero_pedido,
    sku
)
JOIN pedido p
    ON p.numero_pedido = d.numero_pedido
JOIN produto pr
    ON pr.sku = d.sku
ON CONFLICT (id_pedido, id_produto) DO NOTHING;

-- =========================================================
-- 12. REMESSAS: 15 registros
-- Datas tipadas como TIMESTAMP e DATE.
-- =========================================================
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
    d.codigo_rastreio,
    d.data_postagem,
    d.previsao_entrega,
    d.data_entrega,
    d.status,
    d.custo_frete
FROM (
    VALUES
        ('PED-2026-0001', 'CD-SLN-01', 'ABC1D01', '11111111101', 'BRLOG000001', TIMESTAMP '2026-02-01 09:00:00', DATE '2026-02-03', TIMESTAMP '2026-02-02 15:00:00', 'ENTREGUE', 18.00::numeric),
        ('PED-2026-0002', 'CD-SLS-02', 'ABC1D02', '11111111102', 'BRLOG000002', TIMESTAMP '2026-02-02 10:00:00', DATE '2026-02-04', NULL::timestamp, 'EM_TRANSITO', 20.00::numeric),
        ('PED-2026-0003', 'CD-IMP-03', 'ABC1D03', '11111111103', 'BRLOG000003', TIMESTAMP '2026-02-03 11:00:00', DATE '2026-02-06', NULL::timestamp, 'POSTADO', 25.00::numeric),
        ('PED-2026-0004', 'CD-TER-04', 'ABC1D04', '11111111104', 'BRLOG000004', TIMESTAMP '2026-02-04 12:00:00', DATE '2026-02-07', NULL::timestamp, 'POSTADO', 30.00::numeric),
        ('PED-2026-0005', 'CD-FOR-05', 'ABC1D05', '11111111105', 'BRLOG000005', TIMESTAMP '2026-02-05 13:00:00', DATE '2026-02-08', NULL::timestamp, 'POSTADO', 35.00::numeric),
        ('PED-2026-0006', 'CD-NAT-06', 'ABC1D06', '11111111106', 'BRLOG000006', TIMESTAMP '2026-02-06 14:00:00', DATE '2026-02-08', TIMESTAMP '2026-02-07 18:00:00', 'ENTREGUE', 16.00::numeric),
        ('PED-2026-0007', 'CD-REC-07', 'ABC1D07', '11111111107', 'BRLOG000007', TIMESTAMP '2026-02-07 15:00:00', DATE '2026-02-10', NULL::timestamp, 'EM_TRANSITO', 40.00::numeric),
        ('PED-2026-0008', 'CD-SAL-08', 'ABC1D08', '11111111108', 'BRLOG000008', TIMESTAMP '2026-02-08 16:00:00', DATE '2026-02-11', NULL::timestamp, 'POSTADO', 28.00::numeric),
        ('PED-2026-0009', 'CD-BHZ-09', 'ABC1D09', '11111111109', 'BRLOG000009', TIMESTAMP '2026-02-09 17:00:00', DATE '2026-02-12', TIMESTAMP '2026-02-11 14:00:00', 'ENTREGUE', 32.00::numeric),
        ('PED-2026-0010', 'CD-RIO-10', 'ABC1D10', '11111111110', 'BRLOG000010', TIMESTAMP '2026-02-10 18:00:00', DATE '2026-02-13', NULL::timestamp, 'POSTADO', 38.00::numeric),
        ('PED-2026-0011', 'CD-SPO-11', 'ABC1D11', '11111111111', 'BRLOG000011', TIMESTAMP '2026-02-11 19:00:00', DATE '2026-02-14', NULL::timestamp, 'POSTADO', 22.00::numeric),
        ('PED-2026-0012', 'CD-CTB-12', 'ABC1D12', '11111111112', 'BRLOG000012', TIMESTAMP '2026-02-12 10:00:00', DATE '2026-02-15', NULL::timestamp, 'POSTADO', 24.00::numeric),
        ('PED-2026-0013', 'CD-FLN-13', 'ABC1D13', '11111111113', 'BRLOG000013', TIMESTAMP '2026-02-13 11:00:00', DATE '2026-02-16', NULL::timestamp, 'EM_TRANSITO', 42.00::numeric),
        ('PED-2026-0014', 'CD-POA-14', 'ABC1D14', '11111111114', 'BRLOG000014', TIMESTAMP '2026-02-14 12:00:00', DATE '2026-02-17', TIMESTAMP '2026-02-16 10:00:00', 'ENTREGUE', 26.00::numeric),
        ('PED-2026-0015', 'CD-BSB-15', 'ABC1D15', '11111111115', 'BRLOG000015', TIMESTAMP '2026-02-15 13:00:00', DATE '2026-02-18', NULL::timestamp, 'CANCELADO', 12.00::numeric)
) AS d (
    numero_pedido,
    codigo_centro,
    placa,
    cpf_motorista,
    codigo_rastreio,
    data_postagem,
    previsao_entrega,
    data_entrega,
    status,
    custo_frete
)
JOIN pedido p
    ON p.numero_pedido = d.numero_pedido
JOIN centro_distribuicao cd
    ON cd.codigo = d.codigo_centro
JOIN veiculo v
    ON v.placa = d.placa
JOIN motorista m
    ON m.cpf = d.cpf_motorista
ON CONFLICT (codigo_rastreio) DO NOTHING;

-- =========================================================
-- 13. RASTREAMENTOS: 15 registros
-- Datas tipadas como TIMESTAMP.
-- =========================================================
INSERT INTO rastreamento (
    id_remessa,
    data_evento,
    status,
    localizacao,
    descricao
)
SELECT
    r.id_remessa,
    d.data_evento,
    d.status,
    d.localizacao,
    d.descricao
FROM (
    VALUES
        ('BRLOG000001', TIMESTAMP '2026-02-01 09:00:00', 'COLETADO', 'CD Sao Luis Norte', 'Remessa coletada no centro de distribuicao'),
        ('BRLOG000002', TIMESTAMP '2026-02-02 11:00:00', 'EM_TRANSFERENCIA', 'Sao Luis MA', 'Remessa em transferencia'),
        ('BRLOG000003', TIMESTAMP '2026-02-03 12:00:00', 'COLETADO', 'CD Imperatriz', 'Remessa postada'),
        ('BRLOG000004', TIMESTAMP '2026-02-04 13:00:00', 'COLETADO', 'CD Teresina', 'Remessa postada'),
        ('BRLOG000005', TIMESTAMP '2026-02-05 14:00:00', 'COLETADO', 'CD Fortaleza', 'Remessa postada'),
        ('BRLOG000006', TIMESTAMP '2026-02-06 15:00:00', 'ENTREGUE', 'Natal RN', 'Entrega realizada ao destinatario'),
        ('BRLOG000007', TIMESTAMP '2026-02-07 16:00:00', 'EM_ROTA', 'Recife PE', 'Veiculo em rota de entrega'),
        ('BRLOG000008', TIMESTAMP '2026-02-08 17:00:00', 'COLETADO', 'CD Salvador', 'Remessa postada'),
        ('BRLOG000009', TIMESTAMP '2026-02-10 09:00:00', 'ENTREGUE', 'Belo Horizonte MG', 'Entrega concluida'),
        ('BRLOG000010', TIMESTAMP '2026-02-10 19:00:00', 'COLETADO', 'CD Rio de Janeiro', 'Remessa postada'),
        ('BRLOG000011', TIMESTAMP '2026-02-11 20:00:00', 'COLETADO', 'CD Sao Paulo', 'Remessa postada'),
        ('BRLOG000012', TIMESTAMP '2026-02-12 11:00:00', 'COLETADO', 'CD Curitiba', 'Remessa postada'),
        ('BRLOG000013', TIMESTAMP '2026-02-13 12:00:00', 'EM_TRANSFERENCIA', 'Florianopolis SC', 'Remessa em transferencia'),
        ('BRLOG000014', TIMESTAMP '2026-02-15 09:00:00', 'ENTREGUE', 'Porto Alegre RS', 'Entrega concluida'),
        ('BRLOG000015', TIMESTAMP '2026-02-15 14:00:00', 'OCORRENCIA', 'Brasilia DF', 'Pedido cancelado antes da entrega')
) AS d (
    codigo_rastreio,
    data_evento,
    status,
    localizacao,
    descricao
)
JOIN remessa r
    ON r.codigo_rastreio = d.codigo_rastreio
WHERE NOT EXISTS (
    SELECT 1
    FROM rastreamento rt
    WHERE rt.id_remessa = r.id_remessa
      AND rt.data_evento = d.data_evento
      AND rt.status = d.status
);