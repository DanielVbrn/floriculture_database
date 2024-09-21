CREATE TRIGGER trigger_verificar_nome_produto
BEFORE INSERT ON PRODUTO
FOR EACH ROW
EXECUTE FUNCTION verificar_nome_produto();

CREATE TRIGGER trigger_verificar_cadastrar_cliente
BEFORE INSERT ON CLIENTE
FOR EACH ROW
EXECUTE FUNCTION verificar_e_cadastrar_cliente();

CREATE TRIGGER trigger_verificar_cadastrar_loja
BEFORE INSERT ON FLORICULTURA
FOR EACH ROW
EXECUTE FUNCTION verificar_e_cadastrar_loja();

CREATE TRIGGER trigger_verificar_cadastrar_funcionario
BEFORE INSERT ON FUNCIONARIO
FOR EACH ROW
EXECUTE FUNCTION verificar_e_cadastrar_funcionario();

CREATE TRIGGER trigger_verificar_cadastrar_fornecedor
BEFORE INSERT ON FORNECEDOR
FOR EACH ROW
EXECUTE FUNCTION verificar_e_cadastrar_fornecedor();

CREATE TRIGGER trigger_verificar_cadastrar_estoque
BEFORE INSERT ON ESTOQUE
FOR EACH ROW
EXECUTE FUNCTION verificar_e_cadastrar_estoque();

CREATE OR REPLACE FUNCTION impedir_atualizacao_cod_loja()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.COD_LOJA <> OLD.COD_LOJA THEN
        RAISE EXCEPTION 'Alteração do codigo não é permitida.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_impedir_atualizacao_cod_loja
BEFORE UPDATE ON FLORICULTURA
FOR EACH ROW EXECUTE FUNCTION impedir_atualizacao_cod_loja();

-- Separação dos triggers
CREATE OR REPLACE FUNCTION impedir_atualizacao_cod_fornecedor()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.COD_FORNECEDOR <> OLD.COD_FORNECEDOR THEN
        RAISE EXCEPTION 'Alteração do codigo não é permitida.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_impedir_atualizacao_cod_fornecedor
BEFORE UPDATE ON FORNECEDOR
FOR EACH ROW EXECUTE FUNCTION impedir_atualizacao_cod_fornecedor();

-- Separação dos triggers
CREATE OR REPLACE FUNCTION impedir_atualizacao_cod_prod()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.COD_PROD <> OLD.COD_PROD THEN
        RAISE EXCEPTION 'Alteração do codigo não é permitida.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_impedir_atualizacao_cod_prod
BEFORE UPDATE ON PRODUTO
FOR EACH ROW EXECUTE FUNCTION impedir_atualizacao_cod_prod();

-- Separação dos triggers
CREATE OR REPLACE FUNCTION impedir_atualizacao_cod_estoque()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.COD_ESTOQUE <> OLD.COD_ESTOQUE THEN
        RAISE EXCEPTION 'Alteração do codigo não é permitida.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_impedir_atualizacao_cod_estoque
BEFORE UPDATE ON ESTOQUE
FOR EACH ROW EXECUTE FUNCTION impedir_atualizacao_cod_estoque();

-- Separação dos triggers
CREATE OR REPLACE FUNCTION impedir_atualizacao_cod_func()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.COD_FUNC <> OLD.COD_FUNC THEN
        RAISE EXCEPTION 'Alteração do codigo não é permitida.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_impedir_atualizacao_cod_func
BEFORE UPDATE ON FUNCIONARIO
FOR EACH ROW EXECUTE FUNCTION impedir_atualizacao_cod_func();

-- Separação dos triggers
CREATE OR REPLACE FUNCTION impedir_atualizacao_cod_cli()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.COD_CLI <> OLD.COD_CLI THEN
        RAISE EXCEPTION 'Alteração de codigo não é permitida.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_impedir_atualizacao_cod_cli
BEFORE UPDATE ON CLIENTE
FOR EACH ROW EXECUTE FUNCTION impedir_atualizacao_cod_cli();

-- Separação dos triggers
CREATE OR REPLACE FUNCTION impedir_atualizacao_cod_venda()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.COD_VENDA <> OLD.COD_VENDA THEN
        RAISE EXCEPTION 'Alteração do codigo não é permitida.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_impedir_atualizacao_cod_venda
BEFORE UPDATE ON VENDA
FOR EACH ROW EXECUTE FUNCTION impedir_atualizacao_cod_venda();

-- Separação dos triggers
CREATE OR REPLACE FUNCTION impedir_atualizacao_cod_compra()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.COD_COMPRA <> OLD.COD_COMPRA THEN
        RAISE EXCEPTION 'Alteração do codigo não é permitida.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_impedir_atualizacao_cod_compra
BEFORE UPDATE ON COMPRA
FOR EACH ROW EXECUTE FUNCTION impedir_atualizacao_cod_compra();

-- Separação dos triggers
CREATE OR REPLACE FUNCTION impedir_atualizacao_cod_item_venda()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.COD_ITEM_VENDA <> OLD.COD_ITEM_VENDA THEN
        RAISE EXCEPTION 'Alteração do codigo não é permitida.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_impedir_atualizacao_cod_item_venda
BEFORE UPDATE ON ITEM_VENDA
FOR EACH ROW EXECUTE FUNCTION impedir_atualizacao_cod_item_venda();

-- Separação dos triggers
CREATE OR REPLACE FUNCTION impedir_atualizacao_cod_item_compra()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.COD_ITEM_COMPRA <> OLD.COD_ITEM_COMPRA THEN
        RAISE EXCEPTION 'Alteração do codigo não é permitida.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_impedir_atualizacao_cod_item_compra
BEFORE UPDATE ON ITEM_COMPRA
FOR EACH ROW EXECUTE FUNCTION impedir_atualizacao_cod_item_compra();

-- Separação dos triggers
CREATE OR REPLACE FUNCTION impedir_valores_negativos_estoque()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.QUANTIDADE_EST < 0 THEN
        RAISE EXCEPTION 'Quantidade em estoque não pode ser negativa.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_impedir_valores_negativos_estoque
BEFORE INSERT OR UPDATE ON ESTOQUE
FOR EACH ROW EXECUTE FUNCTION impedir_valores_negativos_estoque();

-- Separação dos triggers
CREATE OR REPLACE FUNCTION impedir_valores_negativos_funcionario()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.SALARIO_BASE < 0 THEN
        RAISE EXCEPTION 'salario do funcionario não pode ser negativo.';
    END IF;
    IF NEW.COMISSAO < 0 THEN
        RAISE EXCEPTION 'comissao do funcionario não pode ser negativa.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_impedir_valores_negativos_funcionario
BEFORE INSERT OR UPDATE ON FUNCIONARIO
FOR EACH ROW EXECUTE FUNCTION impedir_valores_negativos_funcionario();

-- Separação dos triggers
CREATE OR REPLACE FUNCTION impedir_valores_negativos_item_venda()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.QTD_ITENS_VENDA < 0 THEN
        RAISE EXCEPTION 'Quantidade de itens não pode ser negativa.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_impedir_valores_negativos_item_venda
BEFORE INSERT OR UPDATE ON ITEM_VENDA
FOR EACH ROW EXECUTE FUNCTION impedir_valores_negativos_item_venda();

-- Separação dos triggers
CREATE OR REPLACE FUNCTION impedir_valores_negativos_item_compra()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.QTD_ITENS_COMPRA < 0 THEN
        RAISE EXCEPTION 'Quantidade de itens não pode ser negativa.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_impedir_valores_negativos_item_compra
BEFORE INSERT OR UPDATE ON ITEM_COMPRA
FOR EACH ROW EXECUTE FUNCTION impedir_valores_negativos_item_compra();

-- Separação dos triggers
CREATE OR REPLACE FUNCTION verificar_estoque_item_venda()
RETURNS TRIGGER AS $$
DECLARE
    quantidade_estoque INT;
BEGIN
    SELECT QUANTIDADE_EST INTO quantidade_estoque
    FROM ESTOQUE
    WHERE COD_ESTOQUE = NEW.COD_ESTOQUE;

    IF NEW.QTD_ITENS_VENDA > quantidade_estoque THEN
        RAISE EXCEPTION 'A quantidade vendida não pode ser maior que a quantidade em estoque.';
    END IF;

    IF quantidade_estoque < 10 THEN
        RAISE WARNING 'A quantidade em estoque está abaixo de 10 unidades. Considere efetuar compras.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_verificar_estoque_item_venda
BEFORE INSERT OR UPDATE ON ITEM_VENDA
FOR EACH ROW EXECUTE FUNCTION verificar_estoque_item_venda();

-- Separação dos triggers
CREATE OR REPLACE FUNCTION verificar_telefone_funcionario()
RETURNS TRIGGER AS $$
BEGIN
    IF LENGTH(NEW.TELEFONE) <> 9 OR NEW.TELEFONE !~ '^[0-9]+$' THEN
        RAISE EXCEPTION 'O telefone deve ter  9 dígitos (0-9)';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_verificar_telefone_funcionario
BEFORE INSERT OR UPDATE ON FUNCIONARIO
FOR EACH ROW EXECUTE FUNCTION verificar_telefone_funcionario();

-- Separação dos triggers
CREATE OR REPLACE FUNCTION verificar_telefone_cliente()
RETURNS TRIGGER AS $$
BEGIN
    IF LENGTH(NEW.TELEFONE_CLI) <> 9 OR NEW.TELEFONE_CLI !~ '^[0-9]+$' THEN
        RAISE EXCEPTION 'O telefone deve ter 9 dígitos (0-9)';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_verificar_telefone_cliente
BEFORE INSERT OR UPDATE ON CLIENTE
FOR EACH ROW EXECUTE FUNCTION verificar_telefone_cliente();

-- Separação dos triggers
CREATE OR REPLACE FUNCTION verificar_telefone_fornecedor()
RETURNS TRIGGER AS $$
BEGIN
    IF LENGTH(NEW.CONTATO_FORNECEDOR) <> 9 OR NEW.CONTATO_FORNECEDOR !~ '^[0-9]+$' THEN
        RAISE EXCEPTION 'O telefone deve ter 9 dígitos (0-9)';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_verificar_telefone_fornecedor
BEFORE INSERT OR UPDATE ON FORNECEDOR
FOR EACH ROW EXECUTE FUNCTION verificar_telefone_fornecedor();

-- Separação dos triggers
CREATE OR REPLACE FUNCTION verificar_status_funcionario_compra()
RETURNS TRIGGER AS $$
DECLARE
    status_funcionario VARCHAR(50);
BEGIN
    SELECT STATUS_FUNC INTO status_funcionario
    FROM FUNCIONARIO
    WHERE COD_FUNC = NEW.COD_FUNC;

    IF status_funcionario <> 'ATIVO' THEN
        RAISE EXCEPTION 'Funcionário em situação irregular, não pode realizar vendas.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_verificar_status_funcionario_compra
BEFORE INSERT OR UPDATE ON COMPRA
FOR EACH ROW EXECUTE FUNCTION verificar_status_funcionario_compra();

-- Separação dos triggers
CREATE OR REPLACE FUNCTION verificar_nome_cliente()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM CLIENTE WHERE NOME = NEW.NOME) THEN
        RAISE EXCEPTION 'Já existe um cliente com este nome.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_verificar_nome_cliente
BEFORE INSERT OR UPDATE ON CLIENTE
FOR EACH ROW EXECUTE FUNCTION verificar_nome_cliente();

-- Separação dos triggers
CREATE OR REPLACE FUNCTION verificar_nome_funcionario()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM FUNCIONARIO WHERE NOME = NEW.NOME) THEN
        RAISE EXCEPTION 'Já existe um funcionário com este nome.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_verificar_nome_funcionario
BEFORE INSERT OR UPDATE ON FUNCIONARIO
FOR EACH ROW EXECUTE FUNCTION verificar_nome_funcionario();

-- Separação dos triggers
CREATE OR REPLACE FUNCTION verificar_nome_produto()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM PRODUTO WHERE NOME = NEW.NOME) THEN
        RAISE EXCEPTION 'Já existe um produto com este nome.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_verificar_nome_produto
BEFORE INSERT OR UPDATE ON PRODUTO
FOR EACH ROW EXECUTE FUNCTION verificar_nome_produto();

-- Separação dos triggers
CREATE OR REPLACE FUNCTION verificar_nome_fornecedor()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM FORNECEDOR WHERE NOME = NEW.NOME) THEN
        RAISE EXCEPTION 'Já existe um fornecedor com este nome.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_verificar_nome_fornecedor
BEFORE INSERT OR UPDATE ON FORNECEDOR
FOR EACH ROW EXECUTE FUNCTION verificar_nome_fornecedor();

-- Separação dos triggers
CREATE OR REPLACE FUNCTION verificar_nome_floricultura()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM FLORICULTURA WHERE NOME = NEW.NOME) THEN
        RAISE EXCEPTION 'Já existe uma floricultura com este nome.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_verificar_nome_floricultura
BEFORE INSERT OR UPDATE ON FLORICULTURA
FOR EACH ROW EXECUTE FUNCTION verificar_nome_floricultura();