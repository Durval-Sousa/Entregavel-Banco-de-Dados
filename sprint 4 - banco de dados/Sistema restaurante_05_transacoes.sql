BEGIN;

-- 1. Criar ou localizar a categoria
INSERT INTO public.categoria (
    nome
)
VALUES (
    'Cafeteria'
)
ON CONFLICT (nome) DO NOTHING;

-- 2. Criar o restaurante usando a categoria correta
INSERT INTO public.restaurante (
    nome,
    telefone,
    id_categoria
)
SELECT
    'Café Central',
    '(98) 98888-4444',
    c.id_categoria
FROM public.categoria AS c
WHERE c.nome = 'Cafeteria'
  AND NOT EXISTS (
      SELECT 1
      FROM public.restaurante AS r
      WHERE r.nome = 'Café Central'
  );

-- 3. Criar o endereço do restaurante
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
SELECT
    'Avenida Principal',
    '450',
    'Sala 2',
    'Bequimão',
    'São Luís',
    'MA',
    '65062000',
    r.id_restaurante
FROM public.restaurante AS r
WHERE r.nome = 'Café Central'
  AND NOT EXISTS (
      SELECT 1
      FROM public.endereco AS e
      WHERE e.id_restaurante = r.id_restaurante
  );

-- 4. Criar um prato para o restaurante
INSERT INTO public.prato (
    nome,
    preco,
    id_restaurante
)
SELECT
    'Café Expresso',
    8.00,
    r.id_restaurante
FROM public.restaurante AS r
WHERE r.nome = 'Café Central'
  AND NOT EXISTS (
      SELECT 1
      FROM public.prato AS p
      WHERE p.nome = 'Café Expresso'
        AND p.id_restaurante = r.id_restaurante
  );

COMMIT;