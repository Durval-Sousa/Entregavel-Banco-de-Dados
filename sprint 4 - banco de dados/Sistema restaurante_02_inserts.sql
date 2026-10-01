INSERT INTO public.categoria (nome)
VALUES
    ('Hamburgueria'),
    ('Culinária Japonesa'),
    ('Pizzaria')
ON CONFLICT (nome) DO NOTHING;

INSERT INTO public.usuario (
    nome,
    email,
    senha
)
VALUES
    (
        'João Silva',
        'joao.silva@email.com',
        'senha_joao'
    ),
    (
        'Maria Santos',
        'maria.santos@email.com',
        'senha_maria'
    ),
    (
        'Pedro Oliveira',
        'pedro.oliveira@email.com',
        'senha_pedro'
    )
ON CONFLICT (email) DO NOTHING;

INSERT INTO public.restaurante (
    nome,
    telefone,
    id_categoria
)
SELECT
    dados.nome,
    dados.telefone,
    c.id_categoria
FROM (
    VALUES
        (
            'Burger São Luís',
            '(98) 99999-1111',
            'Hamburgueria'
        ),
        (
            'Sushi Maranhão',
            '(98) 99999-2222',
            'Culinária Japonesa'
        ),
        (
            'Pizza Central',
            '(98) 99999-3333',
            'Pizzaria'
        )
) AS dados (
    nome,
    telefone,
    nome_categoria
)
JOIN public.categoria AS c
    ON c.nome = dados.nome_categoria
WHERE NOT EXISTS (
    SELECT 1
    FROM public.restaurante AS r
    WHERE r.nome = dados.nome
)
RETURNING id_restaurante, nome, telefone, id_categoria;

INSERT INTO public.endereco (
    logradouro,
    numero,
    complemento,
    bairro,
    cidade,
    estado,
    cep,
    id_restaurante
)
VALUES
    (
        'Avenida dos Holandeses',
        '100',
        'Loja 1',
        'Ponta d''Areia',
        'São Luís',
        'MA',
        '65077000',
        1
    ),
    (
        'Rua das Flores',
        '200',
        'Loja 2',
        'Renascença',
        'São Luís',
        'MA',
        '65075180',
        2
    ),
    (
        'Avenida Colares Moreira',
        '300',
        'Loja 3',
        'Renascença',
        'São Luís',
        'MA',
        '65075441',
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