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


INSERT INTO CLIENTE VALUES(DEFAULT 'DANIEL VITOR', '2004-08-09', '86995185525')