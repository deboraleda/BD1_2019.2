CREATE TYPE estados_nordeste AS ENUM (
'PB', 'PE', 'BA', 'RN', 'SE', 'MA', 'PI',
'CE', 'AL'
);

CREATE TYPE tipo_funcionario AS ENUM (
'farmaceutico', 'vendedor', 'entregdor', 'caixa',
'administrador'
);



CREATE TABLE farmacias(
nome TEXT NOT NULL,
id_farmacia INTEGER PRIMARY KEY,
tipo_farmacia TEXT,
id_gerente INTEGER,
tipo_gerente tipo_funcionario CHECK (tipo_gerente = 'farmaceutico' or tipo_gerente = 'administrador'),
estado estados_nordeste,
bairro TEXT UNIQUE,
cidade TEXT

);

ALTER TABLE farmacias ADD CONSTRAINT chave_gerente FOREIGN KEY (id_gerente, tipo_gerente) REFERENCES funcionarios(id_funcionario, funcao);
ALTER TABLE farmacias ADD CONSTRAINT apenas_uma_sede EXCLUDE USING gist (tipo_farmacia with =) WHERE (tipo_farmacia = 'sede');


CREATE TABLE funcionarios(
nome TEXT NOT NULL,
id_funcionario INTEGER,
id_farmacia INTEGER REFERENCES farmacias(id_farmacia),
funcao tipo_funcionario,

CONSTRAINT funcionarios_pkey PRIMARY KEY (id_funcionario, funcao)
);




CREATE TABLE medicamentos(
nome TEXT NOT NULL,
preco NUMERIC NOT NULL,
id_medicamento INTEGER PRIMARY KEY,
caracteristica TEXT
);

ALTER TABLE medicamentos DROP CONSTRAINT medicamentos_pkey;
ALTER TABLE medicamentos ADD CONSTRAINT super_key PRIMARY KEY (id_medicamento, caracteristica);

CREATE TABLE vendas(
id_venda SERIAL,
id_cliente INTEGER,
id_funcionario INTEGER,
funcionario tipo_funcionario CHECK (funcionario = 'vendedor'),
id_medicamento INTEGER NOT NULL,
id_farmacia INTEGER NOT NULL REFERENCES farmacias(id_farmacia),
caracteristica_medicamento TEXT,

CONSTRAINT receita_so_para_C_cadastrados CHECK (id_cliente <> NULL or caracteristica_medicamento <> 'venda exclusiva com receita'),
FOREIGN KEY (id_funcionario, funcionario) REFERENCES funcionarios(id_funcionario, funcao) ON DELETE RESTRICT,
FOREIGN KEY (id_medicamento, caracteristica_medicamento) REFERENCES medicamentos(id_medicamento, caracteristica) ON DELETE RESTRICT

);

ALTER TABLE vendas ADD CONSTRAINT vendas_pkey PRIMARY KEY (id_venda); 

CREATE TABLE entregas(
id_cliente INTEGER NOT NULL,
id_endereco INTEGER NOT NULL,
id_farmacia INTEGER NOT NULL REFERENCES farmacias(id_farmacia),
id_venda INTEGER NOT NULL REFERENCES vendas (id_venda),

FOREIGN KEY (id_cliente, id_endereco) REFERENCES endereco (id_cliente, id_endereco)
);

CREATE TABLE cliente(
nome TEXT,
id_cliente INTEGER PRIMARY KEY,
idade INTEGER CHECK (idade > 18 ),
id_farmacia INTEGER REFERENCES farmacias(id_farmacia)
);

CREATE TABLE endereco(
id_cliente INTEGER REFERENCES cliente(id_cliente),
rua TEXT,
numero INTEGER,
bairro TEXT,
cidade TEXT,
tipo_endereco TEXT CHECK(tipo_endereco = 'residencia' or tipo_endereco = 'trabalho' or tipo_endereco = 'outro'),
id_endereco INTEGER,

PRIMARY KEY (id_endereco, id_cliente)
);

--
-- COMANDOS ADICIONAIS 
--

--deve ser executado com sucesso

INSERT INTO funcionarios VALUES('Maria', 01, NULL, 'farmaceutico');
INSERT INTO farmacias VALUES('Dias', 01, 'sede', 01, 'farmaceutico', 'PB', 'malvinas', 'cg');
INSERT INTO funcionarios VALUES('Pedro', 02, NULL, 'caixa');
INSERT INTO cliente VALUES('jose', 01, 19, 01);
INSERT INTO endereco VALUES(01, 'rua almirante barroso', 20, 'Quarenta', 'cg', 'residencia', 01);
INSERT INTO medicamentos VALUES('paracetamol', 5.0, 01, 'venda exclusiva com receita');


--nao deve funcionar 

--ja existe uma sede
INSERT INTO farmacias VALUES('Dias', 03, 'sede', 01, 'farmaceutico', 'PB', 'rocha', 'cg');
INSERT INTO farmacias VALUES('Dias', 03, 'filial', 01, 'farmaceutico', 'PB', 'malvinas', 'cg');
INSERT INTO funcionarios VALUES('Maria', 02, 01, 'programador');
INSERT INTO farmacias VALUES('Dias', 02, 'filial', 02, 'caixa', 'PB', 'cruzeiro', 'cg');
INSERT INTO endereco VALUES(01, 'rua almirante barroso', 20, 'Quarenta', 'cg', 'feira', 01);
