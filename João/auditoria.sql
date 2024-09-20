CREATE TABLE auditoria (
    id SERIAL PRIMARY KEY,
    tabela_alterada VARCHAR(255) NOT NULL,
    usuario_mudanca VARCHAR(100) NOT NULL,
    operacao VARCHAR(10) NOT NULL,
    campo_modificado VARCHAR(255),
    valor_anterior TEXT,
    valor_atual TEXT,
    date_time_alteracao TIMESTAMP DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION registrar_auditoria()
RETURNS TRIGGER AS $$
BEGIN
    DECLARE
        op_type TEXT;
    BEGIN
        IF TG_OP = 'INSERT' THEN
            op_type := 'INSERT';
        ELSIF TG_OP = 'UPDATE' THEN
            op_type := 'UPDATE';
        ELSIF TG_OP = 'DELETE' THEN
            op_type := 'DELETE';
        END IF;

        IF op_type = 'UPDATE' THEN
            FOR col IN
                SELECT column_name
                FROM information_schema.columns
                WHERE table_name = TG_TABLE_NAME
            LOOP
                EXECUTE format(
                    'INSERT INTO auditoria (tabela_alterada, usuario_mudanca, operacao, campo_modificado, valor_anterior, valor_atual, date_time_alteracao)
                     VALUES ($1, $2, $3, $4, $5, $6, $7)',
                    TG_TABLE_NAME,
                    SESSION_USER,
                    op_type,
                    col.column_name,
                    OLD.(col.column_name)::TEXT,
                    NEW.(col.column_name)::TEXT,
                    NOW()
                );
            END LOOP;
        ELSE
            EXECUTE format(
                'INSERT INTO auditoria (tabela_alterada, usuario_mudanca, operacao, date_time_alteracao)
                 VALUES ($1, $2, $3, $4)',
                TG_TABLE_NAME,
                SESSION_USER,
                op_type,
                NOW()
            );
        END IF;
        RETURN NEW;
    END;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_auditoria_produto
AFTER UPDATE ON produto
FOR EACH ROW
EXECUTE FUNCTION registrar_auditoria_produto();

-- cria auditoria para todas as tabelas
DO $$
DECLARE
    table_rec RECORD;
BEGIN
    FOR table_rec IN
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'public' -- Ajuste conforme o schema desejado
          AND table_type = 'BASE TABLE'
    LOOP
        EXECUTE format(
            'CREATE TRIGGER trigger_auditoria_%I
             AFTER INSERT OR UPDATE OR DELETE ON %I
             FOR EACH ROW
             EXECUTE FUNCTION registrar_auditoria();',
            table_rec.table_name, table_rec.table_name
        );
    END LOOP;
END;
$$;