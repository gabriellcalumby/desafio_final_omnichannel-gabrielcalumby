-- PROJETO: SISTEMA DE GESTAO OMNICHANNEL
-- ALUNO:GABRIEL HENRIQUE CALUMBY MOURA
-- TURMA 307.008 NEM SESI
-- Arquivo: 02_dml_povoamento.sql


USE omnichannel_db;

-- 1. CLIENTES: 5 REGISTROS

INSERT INTO clientes
(nome_completo, cpf, email, telefone)
VALUES
('Ana Souza', '10000000001', 'ana@email.com', '81990000001'),
('Bruno Lima', '10000000002', 'bruno@email.com', '81990000002'),
('Carla Santos', '10000000003', 'carla@email.com', '81990000003'),
('Diego Alves', '10000000004', 'diego@email.com', '81990000004'),
('Eduarda Costa', '10000000005', 'eduarda@email.com', '81990000005');

-- 2. LOJAS: 5 REGISTROS

INSERT INTO lojas
(nome_loja, tipo, cidade, uf)
VALUES
('Loja Recife Centro', 'LOJA_FISICA', 'Recife', 'PE'),
('Loja Caruaru', 'LOJA_FISICA', 'Caruaru', 'PE'),
('Loja Sao Paulo', 'LOJA_FISICA', 'Sao Paulo', 'SP'),
('E-commerce Nacional', 'E_COMMERCE', 'Recife', 'PE'),
('Loja Belo Horizonte', 'LOJA_FISICA', 'Belo Horizonte', 'MG');

-- 3. PRODUTOS: 5 REGISTROS

INSERT INTO produtos
(nome, categoria, preco, estoque_atual)
VALUES
('Smartphone Galaxy S23', 'Eletronicos', 2500.00, 15),
('Notebook Dell Inspiron', 'Eletronicos', 3800.00, 10),
('Fone Bluetooth', 'Acessorios', 180.00, 30),
('Camiseta Basica', 'Vestuario', 59.90, 25),
('Mouse Sem Fio', 'Acessorios', 89.90, 12);

-- 4. PEDIDOS: 5 REGISTROS

INSERT INTO pedidos
(data_pedido, id_cliente, id_loja, origem_compra,
 forma_pagamento, valor_total, status)
VALUES
('2026-10-18 10:00:00', 1, 1, 'LOJA_FISICA',
 'PIX', 2500.00, 'CONCLUIDO'),

('2026-10-18 11:30:00', 2, 4, 'E_COMMERCE',
 'CARTAO', 3800.00, 'CONCLUIDO'),

('2026-10-19 09:15:00', 3, 2, 'LOJA_FISICA',
 'BOLETO', 180.00, 'CONCLUIDO'),

('2026-10-19 14:20:00', 4, 4, 'E_COMMERCE',
 'PIX', 119.80, 'CONCLUIDO'),

('2026-10-20 16:45:00', 5, 3, 'LOJA_FISICA',
 'CARTAO', 89.90, 'CONCLUIDO');

-- 5. ITENS_PEDIDO: 5 REGISTROS

INSERT INTO itens_pedido
(id_pedido, id_produto, quantidade, preco_unitario)
VALUES
(1, 1, 1, 2500.00),
(2, 2, 1, 3800.00),
(3, 3, 1, 180.00),
(4, 4, 2, 59.90),
(5, 5, 1, 89.90);

-- 6. AUDITORIA: 5 REGISTROS DE EXEMPLO
-- Estes registros sao demonstrativos.
-- As proximas alteracoes serao registradas pela trigger.

INSERT INTO auditoria_preco
(id_produto, preco_antigo, preco_novo, data_alteracao, usuario)
VALUES
(1, 2600.00, 2500.00, '2026-10-15 09:00:00', 'admin@localhost'),
(2, 3900.00, 3800.00, '2026-10-15 09:30:00', 'admin@localhost'),
(3, 200.00, 180.00, '2026-10-16 10:00:00', 'admin@localhost'),
(4, 64.90, 59.90, '2026-10-16 11:00:00', 'admin@localhost'),
(5, 99.90, 89.90, '2026-10-17 14:00:00', 'admin@localhost');

-- 7. CONSULTAS DE VALIDACAO

SELECT * FROM clientes;
SELECT * FROM lojas;
SELECT * FROM produtos;
SELECT * FROM pedidos;
SELECT * FROM itens_pedido;
SELECT * FROM auditoria_preco;

-- Conferir a quantidade de registros em cada tabela
SELECT 'clientes' AS tabela, COUNT(*) AS total FROM clientes
UNION ALL
SELECT 'lojas', COUNT(*) FROM lojas
UNION ALL
SELECT 'produtos', COUNT(*) FROM produtos
UNION ALL
SELECT 'pedidos', COUNT(*) FROM pedidos
UNION ALL
SELECT 'itens_pedido', COUNT(*) FROM itens_pedido
UNION ALL
SELECT 'auditoria_preco', COUNT(*) FROM auditoria_preco;