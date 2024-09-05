------- FUNÇÕES DE CADASTRO

-- PRODUTOS

CREATE OR REPLACE FUNCTION CADASTRAR_PRODUTO(
	P_TABELA VARCHAR,
    P_COD_PROD INT,
    P_NOME_PROD VARCHAR(30),
	P_VALOR_PROD NUMERIC
) RETURNS VARCHAR AS $$
DECLARE
    PRODUTO_EXISTE INT;
    RESULT_MESSAGE VARCHAR;
BEGIN
	IF P_TABELA = 'PRODUTO' THEN 
	    
	SELECT COUNT(*)
	    INTO PRODUTO_EXISTE
	    FROM PRODUTO
	    WHERE COD_PROD = P_COD_PROD;
	
	    IF PRODUTO_EXISTE > 0 THEN
	        RESULT_MESSAGE := 'ERRO: O NOME DO PRODUTO JÁ EXISTE NA TABELA PRODUTO.';
	    ELSE
	        INSERT INTO PRODUTO (COD_PROD, NOME_PROD, VALOR_PROD)
	        VALUES (P_COD_PROD, P_NOME_PROD, P_VALOR_PROD);
	        
	        RESULT_MESSAGE := 'SUCESSO: PRODUTO CADASTRADO COM SUCESSO.';
	    END IF;
	ELSE
		RESULT_MESSAGE:= 'ERRO: TABELA NÃO PODE SER CADASTRADA.';
	END IF;

	RETURN RESULT_MESSAGE;
END;
$$ LANGUAGE plpgsql;


-- CLIENTES

CREATE OR REPLACE FUNCTION CADASTRAR_CLIENTE (
	C_TABELA VARCHAR,
	C_COD_CLI INT,
	C_NOME_CLI VARCHAR(50),
	C_DATA_NASC DATE,
	C_TELEFONE VARCHAR(30)
) RETURNS VARCHAR AS $$ 
DECLARE
	CLIENTE_EXISTE INT;
	RESULT_MESSAGE VARCHAR;
BEGIN
	IF C_TABELA = 'CLIENTE' THEN 
	    SELECT COUNT(*)
	    INTO CLIENTE_EXISTE
	    FROM CLIENTE
	    WHERE COD_CLI = C_COD_CLI;
	
	    IF CLIENTE_EXISTE > 0 THEN
	        RESULT_MESSAGE := 'ERRO: CLIENTE JÁ CADASTRADO.';
	    ELSE
	        INSERT INTO CLIENTE (COD_CLI, NOME_CLI, DATA_NASC, TELEFONE)
	        VALUES (C_COD_CLI, C_NOME_CLI, C_DATA_NASC, C_TELEFONE);
	        
	        RESULT_MESSAGE := 'SUCESSO: CLIENTE CADASTRADO COM SUCESSO.';
	    END IF;
	ELSE
		RESULT_MESSAGE:= 'ERRO: TABELA NÃO PODE SER CADASTRADA.';
	END IF;

	RETURN RESULT_MESSAGE;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE LOG_CLIENTE (
    ID SERIAL PRIMARY KEY,
    RESULTADO VARCHAR(255),
    DATA TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

------- TRIGGER TESTE PARA CADASTRAR CLIENTE

CREATE OR REPLACE FUNCTION trigger_cadastrar_cliente() RETURNS TRIGGER AS $$
DECLARE
    resultado VARCHAR;
BEGIN
    resultado := CADASTRAR_CLIENTE('CLIENTE', NEW.COD_CLI, NEW.NOME_CLI, NEW.DATA_NASC, NEW.TELEFONE);
    INSERT INTO LOG_CLIENTE (RESULTADO) VALUES (resultado);
    IF resultado LIKE 'SUCESSO%' THEN
        RETURN NEW;
    ELSE
        RETURN NULL; 
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_after_insert_cliente
BEFORE INSERT ON CLIENTE
FOR EACH ROW
EXECUTE FUNCTION trigger_cadastrar_cliente();


-- REDE DE FLORICULTURAS

CREATE OR REPLACE FUNCTION CADASTRAR_LOJA(
	L_TABELA VARCHAR,
	L_COD_LOJA INT,
	L_NOME_LOJA VARCHAR(30),
	L_ENDERECO_LOJA VARCHAR(50)
) RETURNS VARCHAR AS $$
DECLARE 
	FLORICULTURA_EXISTE INT;
	RESULT_MESSAGE VARCHAR;
BEGIN
	IF C_TABELA = 'FLORICULTURA' THEN 
	    SELECT COUNT(*)
	    INTO FLORICULTURA_EXISTE
	    FROM FLORICULTURA
	    WHERE COD_LOJA = L_COD_LOJA;
	
	    IF FLORICULTURA_EXISTE > 0 THEN
	        RESULT_MESSAGE := 'ERRO: FLORICULTURA JÁ CADASTRADO NA REDE DE LOJAS.';
	    ELSE
	        INSERT INTO FLORICULTURA (COD_LOJA, NOME_LOJA, ENDERECO_LOJA)
	        VALUES (L_COD_LOJA, L_NOME_LOJA, L_ENDERECO_LOJA);
	        
	        RESULT_MESSAGE := 'SUCESSO: FLORICULTURA CADASTRADA COM SUCESSO NA REDE DE LOJAS.';
	    END IF;
	ELSE
		RESULT_MESSAGE:= 'ERRO: TABELA NÃO PODE SER CADASTRADA.';
	END IF;

	RETURN RESULT_MESSAGE;
END;
$$ LANGUAGE plpgsql;	


	

-- FUNCIONARIOS

CREATE OR REPLACE FUNCTION CADASTRAR_FUNCIONARIO (
	FUNC_TABELA VARCHAR,
	F_COD_FUNC INT,
	F_NOME_FUNC VARCHAR(30),
	F_COD_LOJA INT,
	F_TELEFONE VARCHAR(30)
) RETURNS VARCHAR AS $$
DECLARE 
	FUNCIONARIO_EXISTE INT;
	RESULT_MESSAGE VARCHAR;
BEGIN
	IF FUNC_TABELA = 'FUNCIONARIO'THEN
		SELECT COUNT(*)
		INTO FUNCIONARIO_EXISTE
		FROM FUNCIONARIO
		WHERE COD_FUNC = F_COD_FUNC;
		IF FUNCIONARIO_EXISTE > 0 THEN
			RESULT_MESSAGE := 'ERRO: FUNCIONÁRIO JÁ CADASTRADO NO BANCO DE DADOS.';
		ELSIF F_COD_LOJA IS NULL THEN
			RESULT_MESSAGE:= 'ERRO: O FUNCIONÁRIO DEVE ESTAR LIGADO A ALGUMA FLORICULTURA';
		ELSE
			INSERT INTO FUNCIONARIO ( COD_FUNC, NOME_FUNC, COD_LOJA, TELEFONE)
			VALUES(F_COD_FUNC , F_NOME_FUNC , F_COD_LOJA , F_TELEFONE );
			RESULT_MESSAGE := 'SUCESSO: FUNCIONÁRIO CADASTRADO COM SUCESSO.';
		END IF;
	ELSE
		RESULT_MESSAGE:= 'ERRO: TABELA NÃO PODE SER CADASTRADA.';
	END IF;
	
	RETURN RESULT_MESSAGE;
END;
$$ LANGUAGE plpgsql;	


-- FORNECEDOR

CREATE OR REPLACE FUNCTION CADASTRAR_FORNECEDOR (
	F_TABELA VARCHAR,
	F_COD_FORNEC INT,
	F_NOME_FORNEC VARCHAR(50),
	F_CONTATO_FORNEC VARCHAR(30)
) RETURNS VARCHAR AS $$
DECLARE 
	FORNECEDOR_EXISTE INT;
	RESULT_MESSAGE VARCHAR;
BEGIN
	IF F_TABELA = 'FORNECEDOR'THEN
		SELECT COUNT(*)
		INTO FORNECEDOR_EXISTE
		FROM FORNECEDOR
		WHERE COD_FORNECEDOR = F_COD_FORNEC;
		IF FORNECEDOR_EXISTE > 0 THEN
			RESULT_MESSAGE := 'ERRO: FORNECEDOR JÁ CADASTRADO NO BANCO DE DADOS.';
		ELSE
			INSERT INTO FORNECEDOR ( COD_FORNECEDOR, NOME_FORNECEDOR, CONTATO_FORNECEDOR)
			VALUES(F_COD_FORNEC , F_NOME_FORNEC , F_CONTATO_FORNEC );
			RESULT_MESSAGE := 'SUCESSO: FORNECEDOR CADASTRADO COM SUCESSO.';
		END IF;
	ELSE
		RESULT_MESSAGE:= 'ERRO: TABELA NÃO PODE SER CADASTRADA.';
	END IF;
	
	RETURN RESULT_MESSAGE;
END;
$$ LANGUAGE plpgsql;



-- ESTOQUE
CREATE OR REPLACE FUNCTION CADASTRAR_ESTOQUE (
    E_TABELA VARCHAR,
    E_COD_ESTOQUE INT,
    E_QTD_ESTOQUE INT,
    E_COD_PROD INT,
    E_COD_LOJA INT
) RETURNS VARCHAR AS $$
DECLARE 
    ESTOQUE_EXISTE INT;
    RESULT_MESSAGE VARCHAR;
BEGIN
    IF E_TABELA = 'ESTOQUE' THEN
        -- Verifica se o estoque já existe para o produto na loja
        SELECT COUNT(*)
        INTO ESTOQUE_EXISTE
        FROM ESTOQUE
        WHERE COD_PROD = E_COD_PROD AND COD_LOJA = E_COD_LOJA;

        IF ESTOQUE_EXISTE > 0 THEN
            -- Se o estoque já existir, atualiza a quantidade
            UPDATE ESTOQUE
            SET QUANTIDADE_EST = QUANTIDADE_EST + E_QTD_ESTOQUE
            WHERE COD_PROD = E_COD_PROD AND COD_LOJA = E_COD_LOJA;
            RESULT_MESSAGE := 'SUCESSO: QUANTIDADE ATUALIZADA NO ESTOQUE.';
        ELSE
            -- Se o estoque não existir, insere um novo registro
            INSERT INTO ESTOQUE (COD_ESTOQUE, QUANTIDADE_EST, COD_PROD, COD_LOJA)
            VALUES (E_COD_ESTOQUE, E_QTD_ESTOQUE, E_COD_PROD, E_COD_LOJA);
            RESULT_MESSAGE := 'SUCESSO: ESTOQUE CADASTRADO COM SUCESSO.';
        END IF;
    ELSE
        RESULT_MESSAGE := 'ERRO: TABELA NÃO PODE SER CADASTRADA.';
    END IF;

    RETURN RESULT_MESSAGE;
END;
$$ LANGUAGE plpgsql;


-- VENDAS

CREATE OR REPLACE FUNCTION CADASTRAR_VENDA (
    P_COD_CLI INT,
    P_COD_FUNC INT,
    P_DATA_VENDA DATE
) RETURNS INT AS $$
DECLARE
    NOVO_COD_VENDA INT;
BEGIN
    INSERT INTO VENDA (COD_CLI, COD_FUNC, DATA_VENDA)
    VALUES (P_COD_CLI, P_COD_FUNC, P_DATA_VENDA)
    RETURNING COD_VENDA INTO NOVO_COD_VENDA;

    -- Aqui você pode chamar a função CADASTRAR_ITEM_VENDA, se necessário
    PERFORM CADASTRAR_ITEM_VENDA(NOVO_COD_VENDA);  -- Ajuste conforme necessário

    RETURN NOVO_COD_VENDA;
END;
$$ LANGUAGE plpgsql;



-- ITEM VENDAS
CREATE OR REPLACE FUNCTION CADASTRAR_ITEM_VENDA(
    P_COD_VENDA INT
)
RETURNS VOID AS $$
DECLARE
    ITEM RECORD;
    NOVO_COD_ESTOQUE INT;
    NOVO_COD_ITEM_VENDA INT;
    QUANTIDADE_ATUAL INT;
    VALOR_UNITARIO NUMERIC;
BEGIN
    FOR ITEM IN (SELECT * FROM TEMP_ITEM_VENDA) LOOP
        -- Obtém o estoque do produto
        SELECT COD_ESTOQUE, QUANTIDADE_EST 
        INTO NOVO_COD_ESTOQUE, QUANTIDADE_ATUAL
        FROM ESTOQUE
        WHERE COD_PROD = ITEM.COD_PROD
        LIMIT 1;

        -- Verifica se há quantidade suficiente no estoque
        IF QUANTIDADE_ATUAL < ITEM.QTD_ITENS_VENDA THEN
            RAISE EXCEPTION 'ERRO: QUANTIDADE INSUFICIENTE NO ESTOQUE DO PRODUTO %', ITEM.COD_PROD;
        END IF;

        -- Obtém o valor unitário do produto
        SELECT VALOR_ITEM INTO VALOR_UNITARIO 
        FROM PRODUTO 
        WHERE COD_PROD = ITEM.COD_PROD;

        -- Gera o código do novo item de venda
        SELECT COALESCE(MAX(COD_ITEM_VENDA), 0) + 1 INTO NOVO_COD_ITEM_VENDA FROM ITEM_VENDA;

        -- Insere o item de venda na tabela ITEM_VENDA
        INSERT INTO ITEM_VENDA (COD_ITEM_VENDA, COD_VENDA, COD_ESTOQUE, QTD_ITENS_VENDA, VALOR_ITEM_VENDA)
        VALUES (NOVO_COD_ITEM_VENDA, P_COD_VENDA, NOVO_COD_ESTOQUE, ITEM.QTD_ITENS_VENDA, 
                ITEM.QTD_ITENS_VENDA * VALOR_UNITARIO); -- Cálculo do valor total

        -- Atualiza a quantidade no estoque
        UPDATE ESTOQUE
        SET QUANTIDADE_EST = QUANTIDADE_EST - ITEM.QTD_ITENS_VENDA
        WHERE COD_ESTOQUE = NOVO_COD_ESTOQUE;
    END LOOP;

    -- Limpa a tabela temporária após o processamento
    DELETE FROM TEMP_ITEM_VENDA;
END;
$$ LANGUAGE plpgsql;


CREATE TABLE TEMP_ITEM_VENDA (
    COD_PROD INT NOT NULL,
    QTD_ITENS_VENDA INT NOT NULL
)


-- ITEM COMPRAS

CREATE OR REPLACE FUNCTION INSERIR_ITEM_COMPRA()
RETURNS TRIGGER AS $$
DECLARE
    ITEM RECORD;
    NOVO_COD_ESTOQUE INT;
    NOVO_COD_ITEM_COMPRA INT;
BEGIN
    FOR ITEM IN (SELECT * FROM TEMP_ITEM_COMPRA) LOOP
        SELECT COD_ESTOQUE INTO NOVO_COD_ESTOQUE
        FROM ESTOQUE
        WHERE COD_PROD = ITEM.COD_PROD
        LIMIT 1;

        SELECT COALESCE(MAX(COD_ITEM_COMPRA), 0) + 1 INTO NOVO_COD_ITEM_COMPRA FROM ITEM_COMPRA;

        INSERT INTO ITEM_COMPRA (COD_ITEM_COMPRA, COD_COMPRA, COD_ESTOQUE, QTD_ITENS_COMPRA)
        VALUES (NOVO_COD_ITEM_COMPRA, NEW.COD_COMPRA, NOVO_COD_ESTOQUE, ITEM.QTD_ITENS_COMPRA);

        UPDATE ESTOQUE
        SET QUANTIDADE_EST = QUANTIDADE_EST + ITEM.QTD_ITENS_COMPRA
        WHERE COD_ESTOQUE = NOVO_COD_ESTOQUE;
    END LOOP;

    DELETE FROM TEMP_ITEM_COMPRA;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CREATE TABLE TEMP_ITEM_COMPRA (
    COD_PROD INT,
    QTD_ITENS_COMPRA INT
);


CREATE TRIGGER AFTER_INSERT_COMPRA
AFTER INSERT ON COMPRA
FOR EACH ROW
EXECUTE FUNCTION INSERIR_ITEM_COMPRA();




SELECT * FROM CLIENTE

SELECT CADASTRAR_CLIENTE('CLIENTE', 1, 'JOAO VITOR', '2003-09-08', '86932432423');

INSERT INTO TEMP_ITEM_VENDA (COD_PROD, QTD_ITENS_VENDA)
VALUES (1, 10), (1, 4);

DROP TABLE TEMP_ITEM_VENDA

SELECT CADASTRAR_VENDA( 2, 1, '2024-08-21');


INSERT INTO ESTOQUE (COD_ESTOQUE, QUANTIDADE_EST, COD_PROD, COD_LOJA)
VALUES 
(50,1, 1),
(30, 2, 1);


select * from temp_item_venda
SELECT * FROM ITEM_VENDA
SELECT * FROM VENDA
	
SELECT * FROM ESTOQUE
DELETE FROM TEMP_ITEM_VENDA
DELETE FROM ITEM_VENDA

DELETE FROM ESTOQUE

