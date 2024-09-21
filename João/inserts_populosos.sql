-- Inserts para a tabela FLORICULTURA
INSERT INTO FLORICULTURA (NOME, ENDERECO_LOJA, STATUS_LOJA) VALUES 
('Floricultura A', 'Rua das Flores, 123', 'ATIVO'),
('Floricultura B', 'Av. Primavera, 456', 'ATIVO'),
('Floricultura C', 'Praça do Sol, 789', 'ATIVO'),
('Floricultura D', 'Rua Verde, 321', 'ATIVO'),
('Floricultura E', 'Av. das Árvores, 654', 'ATIVO'),
('Floricultura F', 'Rua do Campo, 987', 'ATIVO'),
('Floricultura G', 'Rua das Orquídeas, 159', 'ATIVO'),
('Floricultura H', 'Av. das Rosas, 753', 'ATIVO'),
('Floricultura I', 'Praça das Tulipas, 951', 'ATIVO'),
('Floricultura J', 'Rua do Girassol, 852', 'ATIVO');

-- Inserts para a tabela FORNECEDOR
INSERT INTO FORNECEDOR (NOME, CONTATO_FORNECEDOR) VALUES 
('Fornecedor A', '123456789'),
('Fornecedor B', '987654321'),
('Fornecedor C', '456789123'),
('Fornecedor D', '321654987'),
('Fornecedor E', '789123456'),
('Fornecedor F', '159753486'),
('Fornecedor G', '753159852'),
('Fornecedor H', '852963741'),
('Fornecedor I', '963852741'),
('Fornecedor J', '258147963');

-- Inserts para a tabela PRODUTO
INSERT INTO PRODUTO (NOME, VALOR_PROD) VALUES 
('Rosa Vermelha', 10.50),
('Girassol', 8.00),
('Orquídea', 15.00),
('Lírio', 12.00),
('Tulipa', 9.50),
('Jasmim', 7.00),
('Cravo', 5.50),
('Hortênsia', 20.00),
('Flor de Lis', 18.00),
('Crisântemo', 14.00);

-- Inserts para a tabela ESTOQUE
INSERT INTO ESTOQUE (COD_PROD, QUANTIDADE_EST) VALUES 
(1, 50),
(2, 30),
(3, 20),
(4, 40),
(5, 15),
(6, 10),
(7, 25),
(8, 5),
(9, 60),
(10, 12);

-- Inserts para a tabela FUNCIONARIO
INSERT INTO FUNCIONARIO (NOME, SALARIO_BASE, COMISSAO, COD_LOJA, TELEFONE, STATUS_FUNC) VALUES 
('João Silva', 2000.00, 0.05, 1, '123456789', 'ATIVO'),
('Maria Oliveira', 2500.00, 0.07, 2, '987654321', 'ATIVO'),
('Carlos Pereira', 1800.00, 0.06, 3, '456789123', 'ATIVO'),
('Fernanda Lima', 2200.00, 0.04, 4, '321654987', 'ATIVO'),
('Ana Souza', 2400.00, 0.08, 5, '789123456', 'ATIVO'),
('Lucas Santos', 2600.00, 0.05, 6, '159753486', 'ATIVO'),
('Patrícia Costa', 2300.00, 0.07, 7, '753159852', 'ATIVO'),
('Ricardo Mendes', 2100.00, 0.06, 8, '852963741', 'ATIVO'),
('Julia Ferreira', 2000.00, 0.04, 9, '963852741', 'ATIVO'),
('Marcos Rocha', 2700.00, 0.05, 10, '258147963', 'ATIVO');

-- Inserts para a tabela CLIENTE
INSERT INTO CLIENTE (NOME, TELEFONE_CLI) VALUES 
('Pedro Almeida', '123456789'),
('Sandra Ribeiro', '987654321'),
('Eduardo Martins', '456789123'),
('Julia Nascimento', '321654987'),
('Felipe Gomes', '789123456'),
('Carla Dias', '159753486'),
('Rafael Lima', '753159852'),
('Renata Costa', '852963741'),
('Fernando Silva', '963852741'),
('Camila Rocha', '258147963');

-- Inserts para a tabela VENDA
INSERT INTO VENDA (COD_CLI, COD_FUNC, DATA_VENDA) VALUES 
(1, 1, '2024-01-15'),
(2, 2, '2024-01-16'),
(3, 3, '2024-01-17'),
(4, 4, '2024-01-18'),
(5, 5, '2024-01-19'),
(6, 6, '2024-01-20'),
(7, 7, '2024-01-21'),
(8, 8, '2024-01-22'),
(9, 9, '2024-01-23'),
(10, 10, '2024-01-24');

-- Inserts para a tabela COMPRA
INSERT INTO COMPRA (COD_ESTOQUE, COD_FUNC, COD_FORNECEDOR, DATA_COMPRA) VALUES 
(1, 1, 1, '2024-01-10'),
(2, 2, 2, '2024-01-11'),
(3, 3, 3, '2024-01-12'),
(4, 4, 4, '2024-01-13'),
(5, 5, 5, '2024-01-14'),
(6, 6, 6, '2024-01-15'),
(7, 7, 7, '2024-01-16'),
(8, 8, 8, '2024-01-17'),
(9, 9, 9, '2024-01-18'),
(10, 10, 10, '2024-01-19');

-- Inserts para a tabela ITEM_VENDA
INSERT INTO ITEM_VENDA (COD_VENDA, COD_ESTOQUE, QTD_ITENS_VENDA) VALUES 
(1, 1, 3),
(2, 2, 2),
(3, 3, 5),
(4, 4, 1),
(5, 5, 4),
(6, 6, 2),
(7, 7, 3),
(8, 8, 1),
(9, 9, 6),
(10, 10, 2);

-- Inserts para a tabela ITEM_COMPRA
INSERT INTO ITEM_COMPRA (COD_COMPRA, COD_ESTOQUE, QTD_ITENS_COMPRA) VALUES 
(1, 1, 10),
(2, 2, 5),
(3, 3, 7),
(4, 4, 3),
(5, 5, 8),
(6, 6, 2),
(7, 7, 4),
(8, 8, 1),
(9, 9, 9),
(10, 10, 6);
