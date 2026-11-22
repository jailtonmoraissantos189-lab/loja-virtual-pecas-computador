-- LOJA VIRTUAL DE PECAS DE COMPUTADOR
-- DML: dados ficticios para demonstracao academica
-- Executar APOS 01_estrutura_banco.sql, em banco sem registros.
-- MySQL 8.0.16+
USE loja_pecas_computador;

START TRANSACTION;

INSERT INTO cliente (id_cliente, nome, email, cpf, telefone) VALUES
(1, 'Mariana Costa', 'mariana.exemplo@example.com', '00000000001', '71900000001'),
(2, 'Lucas Almeida', 'lucas.exemplo@example.com', '00000000002', '71900000002'),
(3, 'Beatriz Santos', 'beatriz.exemplo@example.com', '00000000003', '71900000003');

INSERT INTO endereco (id_endereco, id_cliente, cep, logradouro, numero, complemento, bairro, cidade, uf, endereco_principal) VALUES
(1, 1, '40000000', 'Rua Exemplo A', '100', NULL, 'Centro', 'Salvador', 'BA', TRUE),
(2, 2, '40000001', 'Rua Exemplo B', '200', 'Apto 2', 'Brotas', 'Salvador', 'BA', TRUE),
(3, 3, '40000002', 'Rua Exemplo C', '300', NULL, 'Pituba', 'Salvador', 'BA', TRUE);

INSERT INTO marca (id_marca, nome, descricao, site_oficial) VALUES
(1, 'AMD', 'Fabricante de processadores e placas de video', 'https://www.amd.com'),
(2, 'NVIDIA', 'Fabricante de processadores graficos', 'https://www.nvidia.com'),
(3, 'Kingston', 'Fabricante de memorias e armazenamento', 'https://www.kingston.com'),
(4, 'ASUS', 'Fabricante de componentes de computador', 'https://www.asus.com');

INSERT INTO categoria (id_categoria, nome, descricao) VALUES
(1, 'Processadores', 'Unidades centrais de processamento'),
(2, 'Placas de video', 'Placas graficas dedicadas'),
(3, 'Memorias RAM', 'Modulos de memoria'),
(4, 'Placas-mae', 'Placas principais do computador');

INSERT INTO produto (id_produto, nome, descricao, id_marca, id_categoria, preco_atual, garantia_meses, ativo) VALUES
(1, 'Ryzen 5 5500', 'Processador de seis nucleos', 1, 1, 599.90, 12, TRUE),
(2, 'GeForce RTX 5060', 'Placa de video para jogos', 2, 2, 2299.90, 12, TRUE),
(3, 'Kingston Fury 16GB DDR4', 'Modulo de memoria DDR4', 3, 3, 249.90, 12, TRUE),
(4, 'ASUS TUF B550M', 'Placa-mae AM4', 4, 4, 799.90, 12, TRUE),
(5, 'Ryzen 7 5700X', 'Processador de oito nucleos', 1, 1, 1099.90, 12, TRUE);

INSERT INTO estoque (id_produto, quantidade_disponivel, quantidade_reservada) VALUES
(1, 12, 2),
(2, 5, 1),
(3, 30, 4),
(4, 8, 0),
(5, 0, 0);

INSERT INTO forma_pagamento (id_forma_pagamento, nome, ativo) VALUES
(1, 'PIX', TRUE),
(2, 'Cartao de credito', TRUE),
(3, 'Boleto bancario', TRUE);

-- Os totais sao valores demonstrativos registrados explicitamente.
-- O DDL nao possui trigger para calculo automatico de totais ou baixa de estoque.
INSERT INTO pedido (id_pedido, id_cliente, id_endereco_entrega, id_forma_pagamento, data_pedido, status_pedido, valor_subtotal, valor_frete, valor_desconto, valor_total) VALUES
(1, 1, 1, 1, '2026-11-10 10:30:00', 'PAGO', 849.80, 25.00, 0.00, 874.80),
(2, 2, 2, 2, '2026-11-11 14:15:00', 'PENDENTE', 2299.90, 35.00, 100.00, 2234.90),
(3, 3, 3, 1, '2026-11-12 09:00:00', 'PAGO', 1599.80, 20.00, 0.00, 1619.80);

INSERT INTO item_pedido (id_item_pedido, id_pedido, id_produto, quantidade, preco_unitario, desconto_unitario) VALUES
(1, 1, 1, 1, 599.90, 0.00),
(2, 1, 3, 1, 249.90, 0.00),
(3, 2, 2, 1, 2299.90, 100.00),
(4, 3, 4, 2, 799.90, 0.00);

COMMIT;
