-- ============================================================
-- PROJETO: SISTEMA DE GESTAO OMNICHANNEL
-- ALUNO:GABRIEL HENRIQUE CALUMBY MOURA
-- TURMA 307.008 NEM SESI
-- Arquivo: 03_automacao_plsql.sql
-- Banco: omnichannel_db
-- ============================================================

USE omnichannel_db;

-- 1. REMOVER OBJETOS ANTIGOS PARA RECRIACAO

DROP PROCEDURE IF EXISTS sp_registrar_venda;
DROP TRIGGER IF EXISTS trg_auditoria_preco;

-- 2. PROCEDURE PARA REGISTRAR UMA VENDA

DELIMITER //

CREATE PROCEDURE sp_registrar_venda(
    IN p_id_cliente INT,
    IN p_id_loja INT,
    IN p_origem_compra VARCHAR(20),
    IN p_forma_pagamento VARCHAR(20),
    IN p_id_produto INT,
    IN p_quantidade INT
)
BEGIN
    DECLARE v_preco DECIMAL(10,2);
    DECLARE v_estoque INT;
    DECLARE v_id_pedido INT;
    DECLARE v_total DECIMAL(12,2);
    DECLARE v_novo_estoque INT;

    -- Qualquer erro cancela a transacao.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_quantidade IS NULL OR p_quantidade <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'A quantidade deve ser maior que zero.';
    END IF;

    IF p_origem_compra NOT IN ('LOJA_FISICA', 'E_COMMERCE') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Origem de compra invalida.';
    END IF;

    IF p_forma_pagamento NOT IN ('PIX', 'CARTAO', 'BOLETO') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Forma de pagamento invalida.';
    END IF;

    START TRANSACTION;

    -- Bloquear o registro do produto durante a venda.
    SELECT preco, estoque_atual
      INTO v_preco, v_estoque
      FROM produtos
     WHERE id_produto = p_id_produto
     FOR UPDATE;

    IF v_estoque < p_quantidade THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Estoque insuficiente para a venda.';
    END IF;

    SET v_total = v_preco * p_quantidade;

    -- Registrar o pedido.
    INSERT INTO pedidos (
        id_cliente,
        id_loja,
        origem_compra,
        forma_pagamento,
        valor_total,
        status
    )
    VALUES (
        p_id_cliente,
        p_id_loja,
        p_origem_compra,
        p_forma_pagamento,
        v_total,
        'CONCLUIDO'
    );

    SET v_id_pedido = LAST_INSERT_ID();

    -- Registrar o produto vendido.
    INSERT INTO itens_pedido (
        id_pedido,
        id_produto,
        quantidade,
        preco_unitario
    )
    VALUES (
        v_id_pedido,
        p_id_produto,
        p_quantidade,
        v_preco
    );

    -- Baixar o estoque.
    UPDATE produtos
       SET estoque_atual = estoque_atual - p_quantidade
     WHERE id_produto = p_id_produto;

    SET v_novo_estoque = v_estoque - p_quantidade;

    COMMIT;

    -- Retornar o resultado da venda.
    SELECT
        v_id_pedido AS pedido_registrado,
        v_total AS valor_total,
        v_novo_estoque AS estoque_restante,
        CASE
            WHEN v_novo_estoque < 5 THEN
                'ALERTA: Produto atinge nivel de estoque minimo de seguranca!'
            ELSE
                'Venda realizada com sucesso. Estoque normal.'
        END AS mensagem;

END //

DELIMITER ;

-- 3. TRIGGER DE AUDITORIA AUTOMATICA DE PRECOS

DELIMITER //

CREATE TRIGGER trg_auditoria_preco
AFTER UPDATE ON produtos
FOR EACH ROW
BEGIN
    IF NOT (OLD.preco <=> NEW.preco) THEN

        INSERT INTO auditoria_preco (
            id_produto,
            preco_antigo,
            preco_novo,
            data_alteracao,
            usuario
        )
        VALUES (
            OLD.id_produto,
            OLD.preco,
            NEW.preco,
            NOW(),
            USER()
        );

    END IF;
END //

DELIMITER ;

-- 4. TESTE DA PROCEDURE
-- Cliente 1, loja 4, e-commerce, PIX,
-- produto 3, quantidade 2.

CALL sp_registrar_venda(
    1,
    4,
    'E_COMMERCE',
    'PIX',
    3,
    2
);

-- Conferir a venda criada.
SELECT *
FROM pedidos
ORDER BY id_pedido DESC
LIMIT 1;

SELECT *
FROM itens_pedido
ORDER BY id_item DESC
LIMIT 1;

-- Conferir o estoque atualizado.
SELECT id_produto, nome, estoque_atual
FROM produtos
WHERE id_produto = 3;

-- 5. TESTE DA TRIGGER
-- O preco sera alterado e a auditoria sera automatica.

UPDATE produtos
SET preco = 175.00
WHERE id_produto = 3;

-- Conferir o historico de auditoria.
SELECT *
FROM auditoria_preco
WHERE id_produto = 3
ORDER BY id_auditoria DESC;

-- 6. CONSULTA DE VENDAS POR PRODUTO (DESAFIO EXTRA)

CREATE OR REPLACE VIEW vw_relatorio_vendas AS
SELECT
    pr.id_produto,
    pr.nome AS produto,
    COALESCE(SUM(ip.quantidade), 0) AS unidades_vendidas,
    COALESCE(SUM(ip.quantidade * ip.preco_unitario), 0.00)
        AS receita_total
FROM produtos pr
LEFT JOIN itens_pedido ip
    ON pr.id_produto = ip.id_produto
LEFT JOIN pedidos pe
    ON ip.id_pedido = pe.id_pedido
   AND pe.status = 'CONCLUIDO'
GROUP BY pr.id_produto, pr.nome;

SELECT * FROM vw_relatorio_vendas;

-- Analisar o uso do indice de data.
EXPLAIN
SELECT id_pedido, data_pedido, valor_total
FROM pedidos
WHERE data_pedido >= '2026-10-01 00:00:00';

