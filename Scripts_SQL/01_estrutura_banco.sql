CREATE DATABASE IF NOT EXISTS loja_pecas_computador
 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE loja_pecas_computador;

CREATE TABLE cliente (
 id_cliente INT AUTO_INCREMENT PRIMARY KEY,  nome VARCHAR(120), email VARCHAR(150) NOT NULL, cpf CHAR(11) NOT NULL, telefone VARCHAR(20),
 CONSTRAINT uq_cliente_email UNIQUE (email),
 CONSTRAINT uq_cliente_cpf UNIQUE (cpf)
) ENGINE=InnoDB;

CREATE TABLE endereco (
 id_endereco INT AUTO_INCREMENT PRIMARY KEY, id_cliente INT NOT NULL,
 cep CHAR(8), logradouro VARCHAR(150), numero VARCHAR(15),
 complemento VARCHAR(100) NULL, bairro VARCHAR(80), cidade VARCHAR(80), uf CHAR(2),
 endereco_principal BOOLEAN DEFAULT FALSE,
 CONSTRAINT fk_endereco_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
 ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE marca (
 id_marca INT AUTO_INCREMENT PRIMARY KEY, nome VARCHAR(100),
 descricao VARCHAR(255) NULL, site_oficial VARCHAR(200) NULL,
 CONSTRAINT uq_marca_nome UNIQUE (nome)
) ENGINE=InnoDB;

CREATE TABLE categoria (
 id_categoria INT AUTO_INCREMENT PRIMARY KEY, nome VARCHAR(100), descricao VARCHAR(255) NULL
) ENGINE=InnoDB;

CREATE TABLE produto (
 id_produto INT AUTO_INCREMENT PRIMARY KEY, nome VARCHAR(150), descricao TEXT NULL,
 id_marca INT NOT NULL, id_categoria INT NOT NULL, preco_atual DECIMAL(10,2),
 garantia_meses INT DEFAULT 0, ativo BOOLEAN DEFAULT TRUE,
 CONSTRAINT chk_produto_preco CHECK (preco_atual >= 0),
 CONSTRAINT chk_produto_garantia CHECK (garantia_meses >= 0),
 CONSTRAINT fk_produto_marca FOREIGN KEY (id_marca) REFERENCES marca(id_marca)
 ON DELETE RESTRICT ON UPDATE CASCADE,
 CONSTRAINT fk_produto_categoria FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
 ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE estoque (
 id_produto INT PRIMARY KEY, quantidade_disponivel INT DEFAULT 0,
 quantidade_reservada INT DEFAULT 0, data_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT chk_estoque_disponivel CHECK (quantidade_disponivel >= 0),
 CONSTRAINT chk_estoque_reservado CHECK (quantidade_reservada >= 0),
 CONSTRAINT fk_estoque_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
 ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE forma_pagamento (
 id_forma_pagamento INT AUTO_INCREMENT PRIMARY KEY, nome VARCHAR(50), ativo BOOLEAN DEFAULT TRUE,
 CONSTRAINT uq_forma_pagamento_nome UNIQUE (nome)
) ENGINE=InnoDB;

CREATE TABLE pedido (
 id_pedido INT AUTO_INCREMENT PRIMARY KEY, id_cliente INT NOT NULL,
 id_endereco_entrega INT NOT NULL, id_forma_pagamento INT NOT NULL,
 data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP, status_pedido VARCHAR(30) DEFAULT 'PENDENTE',
 valor_subtotal DECIMAL(10,2) DEFAULT 0.00, valor_frete DECIMAL(10,2) DEFAULT 0.00,
 valor_desconto DECIMAL(10,2) DEFAULT 0.00, valor_total DECIMAL(10,2) DEFAULT 0.00,
 CONSTRAINT chk_pedido_valores CHECK (valor_subtotal >= 0 AND valor_frete >= 0
 AND valor_desconto >= 0 AND valor_total >= 0),
 CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
 ON DELETE RESTRICT ON UPDATE CASCADE,
 CONSTRAINT fk_pedido_endereco FOREIGN KEY (id_endereco_entrega) REFERENCES endereco(id_endereco)
 ON DELETE RESTRICT ON UPDATE CASCADE,
 CONSTRAINT fk_pedido_forma_pagamento FOREIGN KEY (id_forma_pagamento)
 REFERENCES forma_pagamento(id_forma_pagamento) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE item_pedido (
id_item_pedido INT AUTO_INCREMENT PRIMARY KEY, id_pedido INT NOT NULL, id_produto INT NOT NULL,
quantidade INT, preco_unitario DECIMAL(10,2), desconto_unitario DECIMAL(10,2) DEFAULT 0.00,
CONSTRAINT uq_item_pedido_produto UNIQUE (id_pedido, id_produto),
CONSTRAINT chk_item_quantidade CHECK (quantidade > 0),
CONSTRAINT chk_item_preco CHECK (preco_unitario >= 0 AND desconto_unitario >= 0),
CONSTRAINT fk_item_pedido_pedido FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido)
ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT fk_item_pedido_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;
