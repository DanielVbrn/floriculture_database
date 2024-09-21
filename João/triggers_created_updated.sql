-- Funções
CREATE OR REPLACE FUNCTION atualiza_updated_at()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = CURRENT_TIMESTAMP;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION criacao_sem_alteracao()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.criado_em <> OLD.criado_em THEN
        RAISE EXCEPTION 'O campo criado_em não pode ser alterado.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DO $$ 
DECLARE 
    nome_tabela TEXT;

	
-- Criar triggers para todas as tabelas para que o updated seja atualizado toda vez que haja alteração em determinada tabela
BEGIN
    FOR nome_tabela IN
        SELECT table_name 
        FROM information_schema.columns 
        WHERE column_name = 'updated_at'
        AND table_schema = 'public'
    LOOP
        EXECUTE format('
            CREATE TRIGGER trg_%I_updated_at
            BEFORE UPDATE ON %I
            FOR EACH ROW
            EXECUTE FUNCTION atualiza_updated_at();',
            nome_tabela, nome_tabela
        );
    END LOOP;

END $$;


-- Criar trigger de não alteração de created_at
DO $$ 
DECLARE 
    nome_tabela TEXT;

BEGIN
    FOR nome_tabela IN
        SELECT table_name 
        FROM information_schema.columns 
        WHERE column_name = 'updated_at'
        AND table_schema = 'public'
    LOOP
        EXECUTE format('
            CREATE TRIGGER trg_%I_criacao_sem_alteracao
			BEFORE UPDATE ON %I
			FOR EACH ROW
			EXECUTE FUNCTION criacao_sem_alteracao();',
            nome_tabela, nome_tabela
        );
    END LOOP;

END $$;


CREATE OR REPLACE FUNCTION relatorio_salario_funcionario(
    p_cod_func INT DEFAULT NULL,
    p_mes INT DEFAULT NULL,
    p_ano INT DEFAULT NULL
)
RETURNS TABLE (
    cod_func INT,
    nome_func VARCHAR,
    salario_base NUMERIC(10,2),
    comissao NUMERIC(4,2),
    total_vendas NUMERIC(10,2),
    salario_final NUMERIC(10,2)
) AS $$
BEGIN
    IF p_cod_func IS NULL THEN
        RETURN QUERY
        SELECT 
            f.cod_func,
            f.nome_func,
            f.salario_base,
            f.comissao,
            COALESCE(SUM(p.valor_prod * iv.qtd_itens_venda), 0) AS total_vendas,
            f.salario_base + (COALESCE(SUM(p.valor_prod * iv.qtd_itens_venda), 0) * f.comissao / 100) AS salario_final
        FROM funcionario f
        LEFT JOIN venda v ON f.cod_func = v.cod_func
        LEFT JOIN item_venda iv ON v.cod_venda = iv.cod_venda
        LEFT JOIN estoque e ON iv.cod_estoque = e.cod_estoque
        LEFT JOIN produto p ON e.cod_prod = p.cod_prod
        GROUP BY f.cod_func, f.nome_func, f.salario_base, f.comissao;

    ELSIF p_mes IS NULL OR p_ano IS NULL THEN
        RETURN QUERY
        SELECT 
            f.cod_func,
            f.nome_func,
            f.salario_base,
            f.comissao,
            COALESCE(SUM(p.valor_prod * iv.qtd_itens_venda), 0) AS total_vendas,
            f.salario_base + (COALESCE(SUM(p.valor_prod * iv.qtd_itens_venda), 0) * f.comissao / 100) AS salario_final
        FROM funcionario f
        LEFT JOIN venda v ON f.cod_func = v.cod_func
        LEFT JOIN item_venda iv ON v.cod_venda = iv.cod_venda
        LEFT JOIN estoque e ON iv.cod_estoque = e.cod_estoque
        LEFT JOIN produto p ON e.cod_prod = p.cod_prod
        WHERE f.cod_func = p_cod_func
        GROUP BY f.cod_func, f.nome_func, f.salario_base, f.comissao; 
    ELSE
        RETURN QUERY
        SELECT 
            f.cod_func,
            f.nome_func,
            f.salario_base,
            f.comissao,
            COALESCE(SUM(p.valor_prod * iv.qtd_itens_venda), 0) AS total_vendas,
            f.salario_base + (COALESCE(SUM(p.valor_prod * iv.qtd_itens_venda), 0) * f.comissao / 100) AS salario_final
        FROM funcionario f
        LEFT JOIN venda v ON f.cod_func = v.cod_func
        LEFT JOIN item_venda iv ON v.cod_venda = iv.cod_venda
        LEFT JOIN estoque e ON iv.cod_estoque = e.cod_estoque
        LEFT JOIN produto p ON e.cod_prod = p.cod_prod
        WHERE f.cod_func = p_cod_func
        AND EXTRACT(MONTH FROM v.data_venda) = p_mes
        AND EXTRACT(YEAR FROM v.data_venda) = p_ano
        GROUP BY f.cod_func, f.nome_func, f.salario_base, f.comissao;
    END IF;
END;
$$ LANGUAGE plpgsql;

select 