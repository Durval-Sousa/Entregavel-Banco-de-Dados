-- Índice para acelerar JOINs e filtros por categoria de restaurante.
CREATE INDEX IF NOT EXISTS idx_restaurante_categoria
    ON restaurante (id_categoria);

-- Índice para acelerar JOINs entre restaurante e prato.
CREATE INDEX IF NOT EXISTS idx_prato_restaurante
    ON prato (id_restaurante);

-- Índice para acelerar consultas de avaliações por restaurante.
CREATE INDEX IF NOT EXISTS idx_avaliacao_restaurante
    ON avaliacao (id_restaurante);

-- Índice para acelerar consultas de avaliações feitas por usuário.
CREATE INDEX IF NOT EXISTS idx_avaliacao_usuario
    ON avaliacao (id_usuario);

-- Índice composto para listar avaliações de um restaurante ordenadas
-- da mais recente para a mais antiga.
CREATE INDEX IF NOT EXISTS idx_avaliacao_restaurante_data
    ON avaliacao (id_restaurante, data_avaliacao DESC);

-- Índice para buscas de pratos por restaurante e disponibilidade.
CREATE INDEX IF NOT EXISTS idx_prato_restaurante_disponivel
    ON prato (id_restaurante, disponivel);
