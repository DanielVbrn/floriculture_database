-- gerar relatório 

CREATE OR REPLACE FUNCTION gerar_relatorio_vendas(data_dia DATE, mes_inteiro BOOLEAN)
RETURNS TABLE (
    cod_venda INT,
    nome_cliente VARCHAR,
    telefone_cliente VARCHAR,
    data_venda DATE,
    valor_total NUMERIC,
    nome_funcionario VARCHAR
) AS $$
BEGIN
    IF mes_inteiro THEN
        RETURN QUERY
        SELECT
            v.cod_venda,
            c.nome_cli,
            c.telefone,
            v.data_venda,
            SUM(p.valor_prod) AS valor_total,
            f.nome_func AS nome_funcionario
        FROM venda v
        JOIN cliente c ON v.cod_cli = c.cod_cli
        JOIN item_venda iv ON v.cod_venda = iv.cod_venda
        JOIN produto p ON iv.cod_prod = p.cod_prod
        JOIN funcionario f ON v.cod_func = f.cod_func
        WHERE EXTRACT(MONTH FROM v.data_venda) = EXTRACT(MONTH FROM data_dia)
        AND EXTRACT(YEAR FROM v.data_venda) = EXTRACT(YEAR FROM data_dia)
        GROUP BY v.cod_venda, c.nome_cli, c.telefone, v.data_venda, f.nome_func;
    ELSE
        RETURN QUERY
        SELECT
            v.cod_venda,
            c.nome_cli,
            c.telefone,
            v.data_venda,
            SUM(p.valor_prod) AS valor_total,
            f.nome_func AS nome_funcionario
        FROM venda v
        JOIN cliente c ON v.cod_cli = c.cod_cli
        JOIN item_venda iv ON v.cod_venda = iv.cod_venda
        JOIN produto p ON iv.cod_prod = p.cod_prod
        JOIN funcionario f ON v.cod_func = f.cod_func
        WHERE v.data_venda = data_dia
        GROUP BY v.cod_venda, c.nome_cli, c.telefone, v.data_venda, f.nome_func;
    END IF;
END;
$$ LANGUAGE plpgsql;

--gerar relatorio de salario
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
