--Questao 1

CREATE TABLE tarefas(
id_funcionario INTEGER,
tarefa TEXT,
id_tarefa CHAR(11),
valor_tarefa INTEGER,
bloco_predio CHAR(1)
);

--comando 1/ deve ser executado
INSERT INTO tarefas VALUES(2147483646, 'limpar chão do corredor central', '98765432111', 0, 'F');
INSERT INTO tarefas VALUES(2147483647, 'limpar janelas da sala 203', '98765432122', 1, 'F');
INSERT INTO tarefas VALUES(null, null, null, null, null);

--nao devem ser executados
INSERT INTO tarefas VALUES(2147483644, 'limpar chão do corredor superior', '987654323211', 0, 'F');
INSERT INTO tarefas VALUES(2147483643, 'limpar chão do corredor superior', '98765432321', 0, 'FF');

--Questao 2

INSERT INTO tarefas VALUES(2147483648, 'limpar portas do térreo', '32323232955', 4, 'A');
ALTER TABLE tarefas ALTER COLUMN id_funcionario TYPE bigint;
INSERT INTO tarefas VALUES(2147483648, 'limpar portas do térreo', '32323232955', 4, 'A');

--Questao 3

ALTER TABLE tarefas ADD CONSTRAINT check_valor_tarefa CHECK (valor_tarefa <= 32767);

-- nao devem ser executados

INSERT INTO tarefas VALUES(2147483649, 'limpar portas da entrada principal', '32322525199', 32768, 'A');
INSERT INTO tarefas VALUES(2147483649, 'limpar portas da entrada principal', '32322525199', 32769, 'A');

--devem ser executados

INSERT INTO tarefas VALUES(2147483651, 'limpar portas do 1o andar', '32323232911', 32767, 'A');
INSERT INTO tarefas VALUES(2147483652, 'limpar portas do 2o andar', '32323232911', 32766, 'A');

--Questao 4


ALTER TABLE tarefas ALTER COLUMN id_funcionario SET NOT NULL;
DELETE FROM tarefas WHERE id_funcionario IS NULL;
ALTER TABLE tarefas ALTER COLUMN tarefa SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN id_tarefa SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN valor_tarefa SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN bloco_predio SET NOT NULL;

--alterando os nomes das colunas

ALTER TABLE tarefas RENAME COLUMN id_funcionario TO id; 
ALTER TABLE tarefas	RENAME COLUMN tarefa TO descricao;
ALTER TABLE tarefas	RENAME COLUMN id_tarefa TO func_resp_cpf;
ALTER TABLE tarefas	RENAME COLUMN valor_tarefa TO prioridade; 
ALTER TABLE tarefas	RENAME COLUMN bloco_predio TO status;

--Questao 5

INSERT INTO tarefas VALUES (2147483653, 'limpar portas do 1o andar', '32323232911', 2, 'A');
ALTER TABLE tarefas ADD CONSTRAINT status UNIQUE(id);


--Questao 6
--6 A
ALTER TABLE tarefas ADD CONSTRAINT func_resp_cpf CHECK (char_length(func_resp_cpf) = 11);

--6 B

ALTER TABLE tarefas ADD CONSTRAINT possiveis_status CHECK (status IN ('A', 'R', 'F', 'P', 'E', 'C'));

--QUESTÃO 7

ALTER TABLE tarefas ADD CONSTRAINT possiveis_prioridades CHECK (prioridade BETWEEN 0 and 5);
UPDATE tarefas SET prioridade = 0 WHERE id = 2147483651;
UPDATE tarefas SET prioridade = 0 WHERE id = 2147483652;

--QUESTAO 8

CREATE TABLE funcionario(
cpf CHAR(11) NOT NULL,
data_nasc DATE NOT NULL,
nome TEXT NOT NULL,
funcao TEXT NOT NULL,
nivel CHAR(1) NOT NULL,
superior_cpf CHAR(11),

CONSTRAINT chave_primaria PRIMARY KEY(cpf),
CONSTRAINT possiveis_niveis  CHECK (nivel IN ('J', 'P', 'S')),
CONSTRAINT possiveis_funcoes  CHECK (funcao IN ('SUP_LIMPEZA', 'LIMPEZA')),
CONSTRAINT check_supervisor_funcao  CHECK (superior_cpf <> NULL or funcao <> 'LIMPEZA'),
CONSTRAINT chave_estrangeira FOREIGN KEY (superior_cpf) REFERENCES funcionario (cpf)
);

--devem funcionar

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678911', '1980-05-07', 'Pedro da Silva', 'SUP_LIMPEZA', 'S', null);
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678912', '1980-03-08', 'Jose da Silva', 'LIMPEZA', 'J', '12345678911');

--nao deve funcionar
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678913', '1980-04-09', 'Joao da Silva', 'LIMPEZA', 'J', null);


--QUESTAO 9

INSERT INTO funcionario VALUES ('12345678913', '1980-05-07', 'Pedro da costa', 'SUP_LIMPEZA', 'S', null);
INSERT INTO funcionario VALUES ('12345678914', '1980-05-06', 'Pedro da costa', 'SUP_LIMPEZA', 'S', null);
INSERT INTO funcionario VALUES ('12345678915', '1980-05-05', 'Pedro da costa', 'SUP_LIMPEZA', 'S', null);
INSERT INTO funcionario VALUES ('12345678916', '1980-05-04', 'Pedro da costa', 'SUP_LIMPEZA', 'S', null);
INSERT INTO funcionario VALUES ('12345678917', '1980-05-03', 'Pedro da costa', 'SUP_LIMPEZA', 'S', null);
