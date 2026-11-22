-- LOJA VIRTUAL DE PECAS DE COMPUTADOR
-- DQL: consultas de demonstracao academica
-- Executar APOS 01_estrutura_banco.sql e 02_insercao_dados.sql.
USE loja_pecas_computador;

-- 1. Catalogo de produtos com marca e categoria.
SELECT p.id_produto, p.nome AS produto, m.nome AS marca,
       c.nome AS categoria, p.preco_atual, p.ativo
FROM produto AS p
JOIN marca AS m ON m.id_marca = p.id_marca
JOIN categoria AS c ON c.id_categoria = p.id_categoria
ORDER BY c.nome, p.nome;

-- 2. Produtos com disponibilidade em estoque.
SELECT p.id_produto, p.nome AS produto,
       e.quantidade_disponivel, e.quantidade_reservada,
       (e.quantidade_disponivel - e.quantidade_reservada) AS saldo_nao_reservado
FROM produto AS p
JOIN estoque AS e ON e.id_produto = p.id_produto
ORDER BY saldo_nao_reservado DESC, p.nome;

-- 3. Pedidos com cliente, forma de pagamento e endereco de entrega.
SELECT pe.id_pedido, cl.nome AS cliente, fp.nome AS forma_pagamento,
       en.cidade, en.uf, pe.data_pedido, pe.status_pedido, pe.valor_total
FROM pedido AS pe
JOIN cliente AS cl ON cl.id_cliente = pe.id_cliente
JOIN forma_pagamento AS fp ON fp.id_forma_pagamento = pe.id_forma_pagamento
JOIN endereco AS en ON en.id_endereco = pe.id_endereco_entrega
ORDER BY pe.data_pedido DESC;

-- 4. Itens de cada pedido e valor liquido de cada linha.
SELECT i.id_pedido, p.nome AS produto, i.quantidade,
       i.preco_unitario, i.desconto_unitario,
       (i.quantidade * (i.preco_unitario - i.desconto_unitario)) AS total_item
FROM item_pedido AS i
JOIN produto AS p ON p.id_produto = i.id_produto
ORDER BY i.id_pedido, p.nome;

-- 5. Quantidade de pedidos e total registrado por cliente.
SELECT cl.id_cliente, cl.nome AS cliente,
       COUNT(pe.id_pedido) AS quantidade_pedidos,
       COALESCE(SUM(pe.valor_total), 0.00) AS total_pedidos
FROM cliente AS cl
LEFT JOIN pedido AS pe ON pe.id_cliente = cl.id_cliente
GROUP BY cl.id_cliente, cl.nome
ORDER BY total_pedidos DESC;

-- 6. Produtos sem unidades disponiveis.
SELECT p.id_produto, p.nome AS produto, e.quantidade_disponivel
FROM produto AS p
JOIN estoque AS e ON e.id_produto = p.id_produto
WHERE e.quantidade_disponivel = 0
ORDER BY p.nome;

-- 7. Valor registrado dos pedidos por status.
SELECT status_pedido, COUNT(*) AS quantidade_pedidos,
       SUM(valor_total) AS valor_total_registrado
FROM pedido
GROUP BY status_pedido
ORDER BY status_pedido;

-- 8. Quantidade de produtos cadastrados por categoria, inclusive categorias vazias.
SELECT c.nome AS categoria, COUNT(p.id_produto) AS quantidade_produtos
FROM categoria AS c
LEFT JOIN produto AS p ON p.id_categoria = c.id_categoria
GROUP BY c.id_categoria, c.nome
ORDER BY c.nome;

-- 9. Clientes com seus enderecos principais.
SELECT cl.nome AS cliente, en.logradouro, en.numero,
       en.bairro, en.cidade, en.uf
FROM cliente AS cl
JOIN endereco AS en ON en.id_cliente = cl.id_cliente
WHERE en.endereco_principal = TRUE
ORDER BY cl.nome;

-- 10. Conferencia de subtotal registrado versus soma bruta dos itens.
-- O subtotal nao e calculado automaticamente pelo banco.
SELECT pe.id_pedido, pe.valor_subtotal AS subtotal_registrado,
       COALESCE(SUM(i.quantidade * i.preco_unitario), 0.00) AS subtotal_calculado,
       pe.valor_subtotal - COALESCE(SUM(i.quantidade * i.preco_unitario), 0.00) AS diferenca
FROM pedido AS pe
LEFT JOIN item_pedido AS i ON i.id_pedido = pe.id_pedido
GROUP BY pe.id_pedido, pe.valor_subtotal
ORDER BY pe.id_pedido;
