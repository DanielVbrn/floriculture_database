create or replace function implementar_restricao()
returns trigger as $$
begin 
	alter table pedido alter column cod_pedido primary key not null; 
	alter table pedido alter column cod_fornecedor foreign key not null;
	alter table pedido alter column valor_total_pedido not null;
	alter table pedido alter column data_pedido not null;
	alter table pedido alter column hora_pedido not null;
	alter table pedido alter column quant_itens_pedidos not null;

end;
$$ language plpgsql;



create trigger trg_implementar_restricao
before insert on pedido
for each row execute impplementar_restricao();



create or replace function verificar_estoque_livro()
returns trigger as $$
declare
	result_quantity int;
begin
	select quant_estoque into result_quantity from livro where cod_livro = new.cod_livro;
	
	if(result_quantity < 1) then
		raise exception 'Quantidade em estoque não pode ser negativa.';	
	end if;

	if(result_quantity < 10) then
		raise notice 'Quantidade em estoque abaixo de 10 unidades.';		
	end if;
	return new;
end;
$$ language plpgsql;

create trigger trg_verificar_estoque_livro
before insert or update on livro
for each row execute function verificar_estoque_livro();


create or replace function realizar_pedido()
returns trigger as $$
begin
	if(select quant_estoque from livro where cod_livro = NEW.cod_livro) < NEW.quant_itens_pedido then
		raise exception 'Quantidade insuficiente no estoque %', New.cod_livro;
	end if;

	update livro set 
	quant_estoque = quant_estoque - NEW.quant_itens_pedido;

	return new;

end;
$$ language plpgsql;

update livro set quant_estoque = 9 where cod_livro = 1

select * from livro
	
create trigger trg_realizar_pedido
before insert on pedido
for each row execute function realizar_pedido();


create or replace view vendas_fevereiro_2024
as select * from fornecedor natural join pedido
where extract(month from data_pedido) = 2
and extract(year from data_pedido) = 2024;


SELECT NOME_FORNECEDOR FROM VENDAS_FEVEREIRO_2024 
GROUP BY NOME_FORNECEDOR 
ORDER BY SUM(VALOR_TOTAL_PEDIDO) DESC LIMIT 1;



create or replace view vendas_marco_2




SELECT DECREMENTA_PROD(4,2)

CREATE OR REPLACE FUNCTION DECREMENTA_PROD(COD INT,QUANTIDADE INT)
RETURNS VOID
AS $$
BEGIN
UPDATE PRODUTO SET QUANT=QUANT-QUANTIDADE WHERE COD_PROD=COD;
IF EXISTS (SELECT * FROM COMBO WHERE COD_PROD_COMBO=COD) THEN
	UPDATE PRODUTO P SET QUANT=P.QUANT-(QUANTIDADE*C.QUANT)
	FROM COMBO C
	WHERE P.COD_PROD=C.COD_PROD_COMPOE
	AND COD_PROD_COMBO=COD;
END IF;
END;
$$
LANGUAGE PLPGSQL