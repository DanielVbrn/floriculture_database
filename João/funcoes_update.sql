CREATE OR REPLACE FUNCTION ATUALIZAR_TUDO(
    NOME_TABELA TEXT,
    COD INT,
    CAMPOS TEXT[],
    VALORES TEXT[]
) RETURNS VOID AS $$
DECLARE
    i INT;
    primeira_coluna TEXT;
    sql TEXT;
    set_clauses TEXT := '';
BEGIN
    SELECT column_name INTO primeira_coluna
    FROM information_schema.columns
    WHERE table_name = LOWER(NOME_TABELA)
    ORDER BY ordinal_position
    LIMIT 1;

    FOR i IN 1 .. array_length(CAMPOS, 1) LOOP
        set_clauses := set_clauses || format('%I = %L', LOWER(CAMPOS[i]), VALORES[i]);
        IF i < array_length(CAMPOS, 1) THEN
            set_clauses := set_clauses || ', ';
        END IF;
    END LOOP;

    sql := FORMAT('UPDATE %I SET %s WHERE %I = %L', LOWER(NOME_TABELA), set_clauses, primeira_coluna, COD);
    
    EXECUTE sql;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ATUALIZAR_PRODUTO(
    COD INT,
    CAMPOS TEXT[],
    VALORES TEXT[]
) RETURNS VOID AS $$
DECLARE
    i INT;
    sql TEXT;
    set_clauses TEXT := '';
BEGIN
    FOR i IN 1 .. array_length(CAMPOS, 1) LOOP
        set_clauses := set_clauses || format('%I = %L', LOWER(CAMPOS[i]), VALORES[i]);
        IF i < array_length(CAMPOS, 1) THEN
            set_clauses := set_clauses || ', ';
        END IF;
    END LOOP;

    sql := FORMAT('UPDATE PRODUTO SET %s WHERE COD_PROD = %L', set_clauses, COD);
    
    EXECUTE sql;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ATUALIZAR_FUNCIONARIO(
    COD INT,
    CAMPOS TEXT[],
    VALORES TEXT[]
) RETURNS VOID AS $$
DECLARE
    i INT;
    sql TEXT;
    set_clauses TEXT := '';
BEGIN
    FOR i IN 1 .. array_length(CAMPOS, 1) LOOP
        set_clauses := set_clauses || format('%I = %L', LOWER(CAMPOS[i]), VALORES[i]);
        IF i < array_length(CAMPOS, 1) THEN
            set_clauses := set_clauses || ', ';
        END IF;
    END LOOP;

    sql := FORMAT('UPDATE FUNCIONARIO SET %s WHERE COD_FUNC = %L', set_clauses, COD);
    
    EXECUTE sql;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION ATUALIZAR_LOJA(
    COD INT,
    CAMPOS TEXT[],
    VALORES TEXT[]
) RETURNS VOID AS $$
DECLARE
    i INT;
    sql TEXT;
    set_clauses TEXT := '';
BEGIN
    FOR i IN 1 .. array_length(CAMPOS, 1) LOOP
        set_clauses := set_clauses || format('%I = %L', LOWER(CAMPOS[i]), VALORES[i]);
        IF i < array_length(CAMPOS, 1) THEN
            set_clauses := set_clauses || ', ';
        END IF;
    END LOOP;

    sql := FORMAT('UPDATE FLORICULTURA SET %s WHERE COD_LOJA = %L', set_clauses, COD);
    
    EXECUTE sql;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION ATUALIZAR_ESTOQUE(
    COD INT,
    CAMPOS TEXT[],
    VALORES TEXT[]
) RETURNS VOID AS $$
DECLARE
    i INT;
    sql TEXT;
    set_clauses TEXT := '';
BEGIN
    FOR i IN 1 .. array_length(CAMPOS, 1) LOOP
        set_clauses := set_clauses || format('%I = %L', LOWER(CAMPOS[i]), VALORES[i]);
        IF i < array_length(CAMPOS, 1) THEN
            set_clauses := set_clauses || ', ';
        END IF;
    END LOOP;

    sql := FORMAT('UPDATE ESTOQUE SET %s WHERE COD_ESTOQUE = %L', set_clauses, COD);
    
    EXECUTE sql;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ATUALIZAR_VENDA(
    COD INT,
    CAMPOS TEXT[],
    VALORES TEXT[]
) RETURNS VOID AS $$
DECLARE
    i INT;
    sql TEXT;
    set_clauses TEXT := '';
BEGIN
    FOR i IN 1 .. array_length(CAMPOS, 1) LOOP
        set_clauses := set_clauses || format('%I = %L', LOWER(CAMPOS[i]), VALORES[i]);
        IF i < array_length(CAMPOS, 1) THEN
            set_clauses := set_clauses || ', ';
        END IF;
    END LOOP;

    sql := FORMAT('UPDATE VENDA SET %s WHERE COD_VENDA = %L', set_clauses, COD);
    
    EXECUTE sql;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ATUALIZAR_COMPRA(
    COD INT,
    CAMPOS TEXT[],
    VALORES TEXT[]
) RETURNS VOID AS $$
DECLARE
    i INT;
    sql TEXT;
    set_clauses TEXT := '';
BEGIN
    FOR i IN 1 .. array_length(CAMPOS, 1) LOOP
        set_clauses := set_clauses || format('%I = %L', LOWER(CAMPOS[i]), VALORES[i]);
        IF i < array_length(CAMPOS, 1) THEN
            set_clauses := set_clauses || ', ';
        END IF;
    END LOOP;

    sql := FORMAT('UPDATE COMPRA SET %s WHERE COD_COMPRA = %L', set_clauses, COD);
    
    EXECUTE sql;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ATUALIZAR_ITEM_VENDA(
    COD INT,
    CAMPOS TEXT[],
    VALORES TEXT[]
) RETURNS VOID AS $$
DECLARE
    i INT;
    sql TEXT;
    set_clauses TEXT := '';
BEGIN
    FOR i IN 1 .. array_length(CAMPOS, 1) LOOP
        set_clauses := set_clauses || format('%I = %L', LOWER(CAMPOS[i]), VALORES[i]);
        IF i < array_length(CAMPOS, 1) THEN
            set_clauses := set_clauses || ', ';
        END IF;
    END LOOP;

    sql := FORMAT('UPDATE ITEM_VENDA SET %s WHERE COD_ITEM_VENDA = %L', set_clauses, COD);
    
    EXECUTE sql;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ATUALIZAR_ITEM_COMPRA(
    COD INT,
    CAMPOS TEXT[],
    VALORES TEXT[]
) RETURNS VOID AS $$
DECLARE
    i INT;
    sql TEXT;
    set_clauses TEXT := '';
BEGIN
    FOR i IN 1 .. array_length(CAMPOS, 1) LOOP
        set_clauses := set_clauses || format('%I = %L', LOWER(CAMPOS[i]), VALORES[i]);
        IF i < array_length(CAMPOS, 1) THEN
            set_clauses := set_clauses || ', ';
        END IF;
    END LOOP;

    sql := FORMAT('UPDATE ITEM_COMPRA SET %s WHERE COD_ITEM_COMPRA = %L', set_clauses, COD);
    
    EXECUTE sql;
END;
$$ LANGUAGE plpgsql;
