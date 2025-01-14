-- Tabela Fornecedor
CREATE TABLE fornecedor (
    id_fornecedor SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    cnpj VARCHAR(18) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    email VARCHAR(255) NOT NULL
);

-- Tabela Produto
CREATE TABLE produto (
    id_produto SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL,
    id_fornecedor INT REFERENCES fornecedor(id_fornecedor),
    categoria VARCHAR(100),
    imagem_url TEXT
);

-- Tabela Estoque
CREATE TABLE estoque (
    id_estoque SERIAL PRIMARY KEY,
    id_produto INT REFERENCES produto(id_produto),
    quantidade INT NOT NULL,
    preco_compra DECIMAL(10, 2) NOT NULL,
    data_entrada DATE NOT NULL
);

-- Tabela Cliente
CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    tipo_cliente VARCHAR(2) CHECK (tipo_cliente IN ('PF', 'PJ')) NOT NULL,
    cpf VARCHAR(14),
    cnpj VARCHAR(18),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT cliente_tipo_cliente CHECK (
        (tipo_cliente = 'PF' AND cpf IS NOT NULL AND cnpj IS NULL) OR
        (tipo_cliente = 'PJ' AND cnpj IS NOT NULL AND cpf IS NULL)
    )
);

-- Tabela Pagamento
CREATE TABLE pagamento (
    id_pagamento SERIAL PRIMARY KEY,
    id_cliente INT REFERENCES cliente(id_cliente),
    metodo_pagamento VARCHAR(20) CHECK (metodo_pagamento IN ('Cartão de Crédito', 'Boleto', 'Pix', 'Transferência')) NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    status VARCHAR(10) CHECK (status IN ('Pendente', 'Aprovado', 'Recusado')) NOT NULL,
    data_pagamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    detalhes_pagamento TEXT
);

-- Tabela Pedido
CREATE TABLE pedido (
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INT REFERENCES cliente(id_cliente),
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(15) CHECK (status IN ('Em Processamento', 'Enviado', 'Entregue', 'Cancelado')) NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL,
    data_entrega_prevista DATE
);

-- Tabela Item_Pedido
CREATE TABLE item_pedido (
    id_item_pedido SERIAL PRIMARY KEY,
    id_pedido INT REFERENCES pedido(id_pedido),
    id_produto INT REFERENCES produto(id_produto),
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL
);

-- Tabela Entrega
CREATE TABLE entrega (
    id_entrega SERIAL PRIMARY KEY,
    id_pedido INT REFERENCES pedido(id_pedido),
    status_entrega VARCHAR(15) CHECK (status_entrega IN ('Em Rota', 'Entregue', 'Em Atraso', 'Cancelado')) NOT NULL,
    codigo_rastreio VARCHAR(50) NOT NULL,
    data_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_entrega_realizada TIMESTAMP
);

