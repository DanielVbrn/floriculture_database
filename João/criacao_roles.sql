-- dono
CREATE ROLE DONO WITH SUPERUSER

CREATE USER DANIEL WITH PASSWORD '123'

GRANT FUNCIONARIO TO MARIA

-- funcionario
create role funcionario

create user MARIA WITH PASSWORD '123'

GRANT EXECUTE ON FUNCTION CADASTRAR_ITEM_VENDA(
    p_cod_venda INT,
    p_cod_estoque INT,
    p_qtd_itens_venda NUMERIC
) TO FUNCIONARIO


GRANT USAGE, SELECT ON SEQUENCE estoque_cod_estoque_seq1 TO funcionario;

create role cliente 

create user JOAO WITH PASSWORD '123'
GRANT SELECT ON TABLE FLORICULTURA, PRODUTO TO CLIENTE;

grant cliente to joao

DO $$ 
DECLARE
	R RECORD;
BEGIN
	FOR R IN SELECT ROUTINE_NAME FROM INFORMATION_SCHEMA.ROUTINES 
	WHERE SPECIFIC_SCHEMA = 'FLORICULTURA' 
	LOOP EXECUTE 
		-- ESSE REMOVE PERMISSÕES
		FORMAT('revoke EXECUTE ON FUNCTION %I TO funcionario', R.ROUTINE_NAME);
	END LOOP;
END$$


DO $$ 
DECLARE
	R RECORD;
BEGIN
	FOR R IN SELECT ROUTINE_NAME FROM INFORMATION_SCHEMA.ROUTINES 
	WHERE SPECIFIC_SCHEMA = 'FLORICULTURA' 
	LOOP EXECUTE 
		-- ESSE ATRIBUI PERMISSÕES
		FORMAT('revoke EXECUTE ON FUNCTION %I TO funcionario', R.ROUTINE_NAME);
	END LOOP;
END$$


