create table empregado_auditoria (
	operacao varchar,
	usuario varchar,
	data_auditoria timestamp default current_timestamp,
	nome varchar,
	salario int
)

create table empregado (
	cod_empreg serial primary key,
	nome varchar(50),
	salario int
)
	
create or replace function auditoria_empregado()
returns trigger as $$
begin

	IF(TG_OP = 'INSERT') THEN
		insert into empregado_auditoria(operacao, usuario, data_auditoria, nome, salario)
		values ('I', SESSION_USER, current_timestamp, new.nome, new.salario);
		RETURN NEW;
	elsif(TG_OP = 'UPDATE') THEN
		insert into empregado_auditoria(operacao, usuario, data_auditoria, nome, salario)
		values ('A', SESSION_USER, current_timestamp, new.nome, new.salario);
		RETURN NEW;
	elsif(TG_OP = 'DELETE') THEN
		insert into empregado_auditoria(operacao, usuario, data_auditoria, nome, salario)
		values ('E', SESSION_USER, current_timestamp, new.nome, new.salario);
		RETURN NEW;
	END IF;
END;
$$ LANGUAGE PLPGSQL;


CREATE TRIGGER trg_auditoria_empregado
after insert or update or delete on
empregado for each row
execute function auditoria_empregado()


insert into empregado values (default, 'Daniel', 2333)

select * from empregado
