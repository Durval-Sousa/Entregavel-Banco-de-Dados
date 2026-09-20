INSERT INTO categoria (nome)
VALUES
    ('Hamburgueria'),
    ('Culinária Japonesa'),
    ('Pizzaria');

INSERT INTO usuario (nome, email, senha)
VALUES
    ('João Silva', 'joao.silva@email.com', 'senha_joao'),
    ('Maria Santos', 'maria.santos@email.com', 'senha_maria'),
    ('Pedro Oliveira', 'pedro.oliveira@email.com', 'senha_pedro');

INSERT INTO restaurante (
    nome,
    telefone,
    id_categoria
)
VALUES
    (
        'Burger São Luís',
        '(98) 99999-1111',
        1
    ),
    (
        'Sushi Maranhão',
        '(98) 99999-2222',
        2
    ),
    (
        'Pizza Central',
        '(98) 99999-3333',
        3
    );

INSERT INTO endereco (
    rua,
    numero,
    bairro,
    cidade,
    estado,
    id_restaurante
)
VALUES
    (
        'Avenida dos Holandeses',
        '100',
        'Ponta d Areia',
        'São Luís',
        'MA',
        1
    ),
    (
        'Rua das Flores',
        '200',
        'Renascença',
        'São Luís',
        'MA',
        2
    ),
    (
        'Avenida Colares Moreira',
        '300',
        'Renascença',
        'São Luís',
        'MA',
        3
    );

INSERT INTO prato (
    nome,
    preco,
    id_restaurante
)
VALUES
    (
        'Hambúrguer Clássico',
        29.90,
        1
    ),
    (
        'Combo Sushi',
        59.90,
        2
    ),
    (
        'Pizza Calabresa',
        45.00,
        3
    );

INSERT INTO avaliacao (
    nota,
    comentario,
    id_usuario,
    id_restaurante
)
VALUES
    (
        5,
        'Ótimo atendimento e hambúrguer muito saboroso.',
        1,
        1
    ),
    (
        4,
        'Comida muito boa e ambiente agradável.',
        2,
        2
    ),
    (
        5,
        'Pizza excelente e atendimento rápido.',
        3,
        3
    );