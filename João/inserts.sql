-- Inserções na tabela FLORICULTURA
INSERT INTO FLORICULTURA (NOME_LOJA, ENDERECO_LOJA) 
VALUES 
('Floricultura Central', 'Rua das Flores, 123'),
('Floricultura Jardim', 'Avenida das Rosas, 456'),
('Floricultura Primavera', 'Praça das Tulipas, 789');

-- Inserções na tabela FORNECEDOR
INSERT INTO FORNECEDOR (NOME_FORNECEDOR, CONTATO_FORNECEDOR) 
VALUES 
('Fornecedora A', 'contato@fornecedoraa.com'),
('Fornecedora B', 'contato@fornecedorab.com'),
('Fornecedora C', 'contato@fornecedorac.com');

-- Inserções na tabela PRODUTO
INSERT INTO PRODUTO (NOME_PROD) 
VALUES 
('Rosa'),
('Tulipa'),
('Orquídea');

-- Inserções na tabela ESTOQUE
INSERT INTO ESTOQUE (COD_PROD, QUANTIDADE_EST) 
VALUES 
(1, 100),  -- Rosa
(2, 200),  -- Tulipa
(3, 300);  -- Orquídea

-- Inserções na tabela FUNCIONARIO
INSERT INTO FUNCIONARIO (NOME_FUNC, COD_LOJA, TELEFONE) 
VALUES 
('Mariana Costa', 1, '4444-4444'),
('Ricardo Lima', 1, '5555-5555'),
('Fernanda Souza', 2, '6666-6666');

-- Inserções na tabela CLIENTE
INSERT INTO CLIENTE (NOME_CLI, TELEFONE_CLI) 
VALUES 
('Ana Silva', '1111-1111'),
('Bruno Souza', '2222-2222'),
('Carlos Pereira', '3333-3333');

-- Inserções na tabela VENDA
INSERT INTO VENDA (COD_CLI, COD_FUNC, DATA_VENDA) 
VALUES 
(1, 1, '2024-07-01'),
(2, 2, '2024-07-02'),
(3, 3, '2024-07-03');

-- Inserções na tabela COMPRA
INSERT INTO COMPRA (COD_ESTOQUE, COD_FUNC, COD_FORNECEDOR, DATA_COMPRA) 
VALUES 
(1, 1, 1, '2024-06-01'),
(2, 2, 2, '2024-06-02'),
(3, 3, 3, '2024-06-03');

-- Inserções na tabela ITEM_VENDA
INSERT INTO ITEM_VENDA (COD_VENDA, COD_ESTOQUE, QTD_ITENS_VENDA) 
VALUES 
(1, 1, 10),
(2, 2, 20),
(3, 3, 30);

-- Inserções na tabela ITEM_COMPRA
INSERT INTO ITEM_COMPRA (COD_COMPRA, COD_ESTOQUE, QTD_ITENS_COMPRA) 
VALUES 
(1, 1, 50),
(2, 2, 60),
(3, 3, 70);
