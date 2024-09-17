-- remover funcionario
create or replace function verificar_remocao_funcionario()
returns trigger as $$
declare
	func_register int;
	result_message varchar;
begin 
	select 1 into func_register
	from funcionario func 
	where func.cod_loja is not null
	and func.status_func = 'ATIVO'
	and func.cod_func = old.cod_func;
	
	if found then 
        RAISE EXCEPTION 'ERRO: FUNCIONÁRIO ESTÁ VINCULADO A UMA LOJA.';
	ELSE
		result_message:= 'FUNCIONÁRIO REMOVIDO.';
		return old, RESULT_MESSAGE;
	end if;
end;
$$ language plpgsql;


create trigger trg_verificar_remocao_funcionario
before delete on funcionario
for each row 
execute function verificar_remocao_funcionario();


-- remover produto

CREATE OR REPLACE FUNCTION verificar_estoque_antes_remocao_produto()
RETURNS TRIGGER AS $$
DECLARE 
    quantidade_atual INT;
BEGIN
    SELECT quantidade_est INTO quantidade_atual 
    FROM estoque 
    WHERE cod_prod = OLD.cod_prod;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Produto % não encontrado no estoque', OLD.cod_prod;
    END IF;

    IF quantidade_atual > 0 THEN
        UPDATE estoque 
        SET quantidade_est = quantidade_est - 1
        WHERE cod_prod = OLD.cod_prod;
    ELSE
        RAISE EXCEPTION 'Produto % não tem quantidade suficiente no estoque', OLD.cod_prod;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER trg_verificar_remocao_produto
BEFORE DELETE ON produto
FOR EACH ROW 
EXECUTE FUNCTION verificar_estoque_antes_remocao_produto();


-- Função para verificar se a loja pode ser removida
CREATE OR REPLACE FUNCTION verificar_remocao_loja()
RETURNS TRIGGER AS $$
DECLARE
    loja_ativa BOOLEAN;
    funcionarios_vinculados INT;
BEGIN
    SELECT (status_loja = 'INATIVA') INTO loja_ativa
    FROM loja
    WHERE cod_loja = OLD.cod_loja;
    
    IF NOT loja_ativa THEN
        -- Verifica se a loja está vinculada a funcionários ativos
        SELECT COUNT(*) INTO funcionarios_vinculados
        FROM funcionario
        WHERE cod_loja = OLD.cod_loja
        AND status_func = 'ATIVO';
        
        IF funcionarios_vinculados > 0 THEN
            RAISE EXCEPTION 'ERRO: LOJA ESTÁ VINCULADA A FUNCIONÁRIOS ATIVOS.';
        END IF;
    END IF;
    
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_verificar_remocao_loja
BEFORE DELETE ON loja
FOR EACH ROW
EXECUTE FUNCTION verificar_remocao_loja();

