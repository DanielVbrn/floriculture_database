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
