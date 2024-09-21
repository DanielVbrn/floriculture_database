CREATE OR REPLACE FUNCTION relatorio_salario_funcionario(
    p_cod_func INT,
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
    IF p_cod_func = 0 THEN
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

CREATE OR REPLACE FUNCTION salario_vigente(
    p_cod_func INT DEFAULT NULL
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
        AND EXTRACT(MONTH FROM v.data_venda) = EXTRACT(MONTH FROM CURRENT_DATE)
		AND EXTRACT(YEAR FROM v.data_venda) = EXTRACT(YEAR FROM CURRENT_DATE)
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
        AND EXTRACT(MONTH FROM v.data_venda) = EXTRACT(MONTH FROM CURRENT_DATE)
		AND EXTRACT(YEAR FROM v.data_venda) = EXTRACT(YEAR FROM CURRENT_DATE)
        GROUP BY f.cod_func, f.nome_func, f.salario_base, f.comissao;
	END IF;
END;
$$ LANGUAGE plpgsql;

-- --gera relatorio de vendas
-- CREATE OR REPLACE FUNCTION RELATORIO_VENDAS(
--     DATA_INICIO TEXT DEFAULT NULL,
--     DATA_FIM TEXT DEFAULT NULL
-- ) RETURNS TABLE(
--     CLIENTE TEXT,
--     FUNCIONARIO TEXT,
--     FLORICULTURA TEXT,
--     PRODUTO TEXT,
--     QUANTIDADE INT,
--     DATA_VENDA DATE
-- ) AS $$
-- DECLARE
--     inicio DATE;
--     fim DATE;
-- BEGIN
--     IF DATA_INICIO IS NULL OR DATA_FIM IS NULL THEN
--         RAISE EXCEPTION 'Por favor, passe os parâmetros no formato DD-MM-YYYY.';
--     END IF;

--     BEGIN
--         inicio := TO_DATE(DATA_INICIO, 'DD-MM-YYYY');
--         fim := TO_DATE(DATA_FIM, 'DD-MM-YYYY');
--     EXCEPTION
--         WHEN OTHERS THEN
--             RAISE EXCEPTION 'Erro ao converter as datas. Verifique o formato.';
--     END;

--     RETURN QUERY
--     SELECT
--         c.NOME AS CLIENTE,
--         f.NOME AS FUNCIONARIO,
--         fl.NOME AS FLORICULTURA,
--         p.NOME AS PRODUTO,
--         iv.QTD_ITENS_VENDA AS QUANTIDADE,
--         v.DATA_VENDA AS DATA_VENDA
--     FROM VENDA v
--     JOIN ITEM_VENDA iv ON v.COD_VENDA = iv.COD_VENDA
--     JOIN CLIENTE c ON v.COD_CLI = c.COD_CLI
--     JOIN FUNCIONARIO f ON v.COD_FUNC = f.COD_FUNC
--     JOIN ESTOQUE e ON iv.COD_ESTOQUE = e.COD_ESTOQUE
--     JOIN PRODUTO p ON e.COD_PROD = p.COD_PROD
--     JOIN FLORICULTURA fl ON f.COD_LOJA = fl.COD_LOJA
--     WHERE v.DATA_VENDA BETWEEN inicio AND fim;

-- END;
-- $$ LANGUAGE plpgsql;