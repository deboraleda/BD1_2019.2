-- 1, 2

CREATE TABLE automovel(
	placa VARCHAR(15),
	ano INTEGER,
	marca VARCHAR(15),
	modelo VARCHAR(15)
);

CREATE TABLE segurado(
	cpf VARCHAR(11),
	nome TEXT,
	telefone VARCHAR(11),
	automovel_placa VARCHAR(15),
	endereco TEXT
);

CREATE TABLE perito(
	cpf VARCHAR(11),
	nome TEXT,
	telefone VARCHAR(11)
);

CREATE TABLE oficina(
	nome TEXT,
	telefone VARCHAR(11),
	endereco TEXT,
	id_oficina INTEGER
);

CREATE TABLE seguro(
	valor NUMERIC,
	automovel_placa VARCHAR(15),
	cpf_segurado VARCHAR(11),
	descricao TEXT,
	id_seguro INTEGER
);

CREATE TABLE sinistro(
	data DATE,
	automovel_placa VARCHAR(15),
	cpf_segurado VARCHAR(11),
	cpf_perito VARCHAR(11),
	descricao TEXT,
	id_sinistro INTEGER
);

CREATE TABLE pericia(
	laudo TEXT,
	id_sinistro INTEGER,
	id_pericia INTEGER
);

CREATE TABLE reparo(
	id_oficina INTEGER,
	id_pericia INTEGER,
	id_reparo INTEGER,
	custo_adicional NUMERIC
);


--3

ALTER TABLE automovel ADD PRIMARY KEY (placa);
ALTER TABLE segurado ADD PRIMARY KEY (cpf);
ALTER TABLE perito ADD PRIMARY KEY (cpf);
ALTER TABLE oficina ADD PRIMARY KEY (id_oficina);
ALTER TABLE seguro ADD PRIMARY KEY (id_seguro);
ALTER TABLE sinistro ADD PRIMARY KEY (id_sinistro);
ALTER TABLE pericia ADD PRIMARY KEY (id_pericia);
ALTER TABLE reparo ADD PRIMARY KEY (id_reparo);

--4, 5

ALTER TABLE segurado ADD CONSTRAINT segurado_automovel_placa_fkey FOREIGN KEY (automovel_placa) REFERENCES automovel(placa);
ALTER TABLE seguro ADD CONSTRAINT seguro_placa_fkey FOREIGN KEY (automovel_placa) REFERENCES automovel (placa);
ALTER TABLE seguro ADD CONSTRAINT seguro_cpf_segurado_fkey FOREIGN KEY (cpf_segurado) REFERENCES segurado (cpf);
ALTER TABLE sinistro ADD CONSTRAINT sinistro_cpf_segurado_fkey FOREIGN KEY (cpf_segurado) REFERENCES segurado (cpf);
ALTER TABLE sinistro ADD CONSTRAINT sinistro_cpf_perito_fkey FOREIGN KEY (cpf_perito) REFERENCES perito (cpf);
ALTER TABLE pericia ADD CONSTRAINT pericia_id_sinistro_fkey FOREIGN KEY (id_sinistro) REFERENCES sinistro (id_sinistro);
ALTER TABLE reparo ADD CONSTRAINT reparo_id_oficina_fkey FOREIGN KEY (id_oficina) REFERENCES oficina (id_oficina);
ALTER TABLE reparo ADD CONSTRAINT reparo_id_pericia_fkey FOREIGN KEY (id_pericia) REFERENCES pericia (id_pericia);

--6

DROP TABLE reparo;
DROP TABLE pericia;
DROP TABLE sinistro;
DROP TABLE seguro;
DROP TABLE oficina;
DROP TABLE perito;
DROP TABLE segurado;
DROP TABLE automovel;

--7, 8

CREATE TABLE automovel(
	placa VARCHAR(15) CONSTRAINT automovel_pkey PRIMARY KEY,
	ano INTEGER,
	marca VARCHAR(15),
	modelo VARCHAR(15)
);

CREATE TABLE segurado(
	cpf VARCHAR(11) CONSTRAINT segurado_pkey PRIMARY KEY,
	nome TEXT,
	telefone VARCHAR(11),
	automovel_placa VARCHAR(15) REFERENCES automovel (placa),
	endereco TEXT
);

CREATE TABLE perito(
	cpf VARCHAR(11) PRIMARY KEY,
	nome TEXT,
	telefone VARCHAR(11)
);

CREATE TABLE oficina(
	nome TEXT,
	telefone VARCHAR(11),
	endereco TEXT,
	id_oficina INTEGER PRIMARY KEY
);

CREATE TABLE seguro(
	valor NUMERIC,
	automovel_placa VARCHAR(15) REFERENCES automovel (placa),
	cpf_segurado VARCHAR(11) REFERENCES segurado (cpf),
	descricao TEXT,
	id_seguro INTEGER PRIMARY KEY
);

CREATE TABLE sinistro(
	data DATE,
	automovel_placa VARCHAR(15) REFERENCES automovel (placa),
	cpf_segurado VARCHAR(11) REFERENCES segurado (cpf),
	cpf_perito VARCHAR(11) REFERENCES perito (cpf),
	descricao TEXT,
	id_sinistro INTEGER PRIMARY KEY
);

CREATE TABLE pericia(
	laudo TEXT,
	id_sinistro INTEGER REFERENCES sinistro (id_sinistro),
	id_pericia INTEGER PRIMARY KEY
);

CREATE TABLE reparo(
	id_oficina INTEGER REFERENCES oficina (id_oficina),
	id_pericia INTEGER REFERENCES pericia (id_pericia),
	id_reparo INTEGER PRIMARY KEY,
	custo_adicional NUMERIC
);

--9 

DROP TABLE reparo;
DROP TABLE pericia;
DROP TABLE sinistro;
DROP TABLE seguro;
DROP TABLE oficina;
DROP TABLE perito;
DROP TABLE segurado;
DROP TABLE automovel;
















