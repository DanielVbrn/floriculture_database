CREATE TABLE auditoria (
    id SERIAL PRIMARY KEY,
    tabela_alterada VARCHAR(255) NOT NULL,
    usuario_mudanca VARCHAR(100) NOT NULL,
    operacao VARCHAR(10) NOT NULL,
    campo_modificado VARCHAR(255),
    valor_anterior TEXT,
    valor_atual TEXT,
    date_time_operacao TIMESTAMP DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION registrar_auditoria()
RETURNS TRIGGER AS $$
DECLARE
    op_type TEXT;
    col RECORD;
    old_value TEXT;
    new_value TEXT;
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
                'SELECT $1, $2 FROM (VALUES (OLD.%I), (NEW.%I)) AS v(a, b)',
                col.column_name, col.column_name
            ) INTO old_value, new_value;

            EXECUTE format(
                'INSERT INTO auditoria (tabela_alterada, usuario_mudanca, operacao, campo_modificado, valor_anterior, valor_atual, date_time_alteracao)
                 VALUES (%L, %L, %L, %L, %L, %L, NOW())',
                TG_TABLE_NAME,
                SESSION_USER,
                op_type,
                col.column_name,
                old_value,
                new_value
            );
        END LOOP;
    ELSE
        EXECUTE format(
            'INSERT INTO auditoria (tabela_alterada, usuario_mudanca, operacao, date_time_alteracao)
             VALUES (%L, %L, %L, NOW())',
            TG_TABLE_NAME,
            SESSION_USER,
            op_type
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- cria auditoria para todas as tabelas
DO $$
DECLARE
    table_rec RECORD;
BEGIN
    FOR table_rec IN
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'public'
          AND table_type = 'BASE TABLE'
          AND table_name != 'auditoria'
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

drop trigger trigger_auditoria_auditoria on auditoria