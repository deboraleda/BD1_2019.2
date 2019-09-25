--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.19
-- Dumped by pg_dump version 9.5.19

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_id_medicamento_fkey;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_id_funcionario_fkey;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_id_farmacia_fkey;
ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT funcionarios_id_farmacia_fkey;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_id_venda_fkey;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_id_farmacia_fkey;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_id_cliente_fkey;
ALTER TABLE ONLY public.endereco DROP CONSTRAINT endereco_id_cliente_fkey;
ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_id_farmacia_fkey;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT chave_gerente;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_pkey;
ALTER TABLE ONLY public.medicamentos DROP CONSTRAINT super_key;
ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT funcionarios_pkey;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT farmacias_pkey;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT farmacias_bairro_key;
ALTER TABLE ONLY public.endereco DROP CONSTRAINT endereco_pkey;
ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_pkey;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT apenas_uma_sede;
ALTER TABLE public.vendas ALTER COLUMN id_venda DROP DEFAULT;
DROP SEQUENCE public.vendas_id_venda_seq;
DROP TABLE public.vendas;
DROP TABLE public.medicamentos;
DROP TABLE public.funcionarios;
DROP TABLE public.farmacias;
DROP TABLE public.entregas;
DROP TABLE public.endereco;
DROP TABLE public.cliente;
DROP TYPE public.tipo_funcionario;
DROP TYPE public.estados_nordeste;
DROP EXTENSION btree_gist;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: estados_nordeste; Type: TYPE; Schema: public; Owner: debora
--

CREATE TYPE public.estados_nordeste AS ENUM (
    'PB',
    'PE',
    'BA',
    'RN',
    'SE',
    'MA',
    'PI',
    'CE',
    'AL'
);


ALTER TYPE public.estados_nordeste OWNER TO debora;

--
-- Name: tipo_funcionario; Type: TYPE; Schema: public; Owner: debora
--

CREATE TYPE public.tipo_funcionario AS ENUM (
    'farmaceutico',
    'vendedor',
    'entregdor',
    'caixa',
    'administrador'
);


ALTER TYPE public.tipo_funcionario OWNER TO debora;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: cliente; Type: TABLE; Schema: public; Owner: debora
--

CREATE TABLE public.cliente (
    nome text,
    id_cliente integer NOT NULL,
    idade integer,
    id_farmacia integer,
    CONSTRAINT cliente_idade_check CHECK ((idade > 18))
);


ALTER TABLE public.cliente OWNER TO debora;

--
-- Name: endereco; Type: TABLE; Schema: public; Owner: debora
--

CREATE TABLE public.endereco (
    id_cliente integer NOT NULL,
    rua text,
    numero integer,
    bairro text,
    cidade text,
    tipo_endereco text,
    id_endereco integer NOT NULL,
    CONSTRAINT endereco_tipo_endereco_check CHECK (((tipo_endereco = 'residencia'::text) OR (tipo_endereco = 'trabalho'::text) OR (tipo_endereco = 'outro'::text)))
);


ALTER TABLE public.endereco OWNER TO debora;

--
-- Name: entregas; Type: TABLE; Schema: public; Owner: debora
--

CREATE TABLE public.entregas (
    id_cliente integer NOT NULL,
    id_endereco integer NOT NULL,
    id_farmacia integer NOT NULL,
    id_venda integer NOT NULL
);


ALTER TABLE public.entregas OWNER TO debora;

--
-- Name: farmacias; Type: TABLE; Schema: public; Owner: debora
--

CREATE TABLE public.farmacias (
    nome text NOT NULL,
    id_farmacia integer NOT NULL,
    tipo_farmacia text,
    id_gerente integer,
    tipo_gerente public.tipo_funcionario,
    estado public.estados_nordeste,
    bairro text,
    cidade text,
    CONSTRAINT farmacias_tipo_gerente_check CHECK (((tipo_gerente = 'farmaceutico'::public.tipo_funcionario) OR (tipo_gerente = 'administrador'::public.tipo_funcionario)))
);


ALTER TABLE public.farmacias OWNER TO debora;

--
-- Name: funcionarios; Type: TABLE; Schema: public; Owner: debora
--

CREATE TABLE public.funcionarios (
    nome text NOT NULL,
    id_funcionario integer NOT NULL,
    id_farmacia integer,
    funcao public.tipo_funcionario NOT NULL
);


ALTER TABLE public.funcionarios OWNER TO debora;

--
-- Name: medicamentos; Type: TABLE; Schema: public; Owner: debora
--

CREATE TABLE public.medicamentos (
    nome text NOT NULL,
    preco numeric NOT NULL,
    id_medicamento integer NOT NULL,
    caracteristica text NOT NULL
);


ALTER TABLE public.medicamentos OWNER TO debora;

--
-- Name: vendas; Type: TABLE; Schema: public; Owner: debora
--

CREATE TABLE public.vendas (
    id_venda integer NOT NULL,
    id_cliente integer,
    id_funcionario integer,
    funcionario public.tipo_funcionario,
    id_medicamento integer NOT NULL,
    id_farmacia integer NOT NULL,
    caracteristica_medicamento text,
    CONSTRAINT receita_so_para_c_cadastrados CHECK (((id_cliente <> NULL::integer) OR (caracteristica_medicamento <> 'venda exclusiva com receita'::text))),
    CONSTRAINT vendas_funcionario_check CHECK ((funcionario = 'vendedor'::public.tipo_funcionario))
);


ALTER TABLE public.vendas OWNER TO debora;

--
-- Name: vendas_id_venda_seq; Type: SEQUENCE; Schema: public; Owner: debora
--

CREATE SEQUENCE public.vendas_id_venda_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vendas_id_venda_seq OWNER TO debora;

--
-- Name: vendas_id_venda_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: debora
--

ALTER SEQUENCE public.vendas_id_venda_seq OWNED BY public.vendas.id_venda;


--
-- Name: id_venda; Type: DEFAULT; Schema: public; Owner: debora
--

ALTER TABLE ONLY public.vendas ALTER COLUMN id_venda SET DEFAULT nextval('public.vendas_id_venda_seq'::regclass);


--
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: debora
--

INSERT INTO public.cliente (nome, id_cliente, idade, id_farmacia) VALUES ('jose', 1, 19, 1);


--
-- Data for Name: endereco; Type: TABLE DATA; Schema: public; Owner: debora
--

INSERT INTO public.endereco (id_cliente, rua, numero, bairro, cidade, tipo_endereco, id_endereco) VALUES (1, 'rua almirante barroso', 20, 'Quarenta', 'cg', 'residencia', 1);


--
-- Data for Name: entregas; Type: TABLE DATA; Schema: public; Owner: debora
--



--
-- Data for Name: farmacias; Type: TABLE DATA; Schema: public; Owner: debora
--

INSERT INTO public.farmacias (nome, id_farmacia, tipo_farmacia, id_gerente, tipo_gerente, estado, bairro, cidade) VALUES ('Dias', 1, 'sede', 1, 'farmaceutico', 'PB', 'malvinas', 'cg');


--
-- Data for Name: funcionarios; Type: TABLE DATA; Schema: public; Owner: debora
--

INSERT INTO public.funcionarios (nome, id_funcionario, id_farmacia, funcao) VALUES ('Maria', 1, NULL, 'farmaceutico');
INSERT INTO public.funcionarios (nome, id_funcionario, id_farmacia, funcao) VALUES ('Pedro', 2, NULL, 'caixa');


--
-- Data for Name: medicamentos; Type: TABLE DATA; Schema: public; Owner: debora
--

INSERT INTO public.medicamentos (nome, preco, id_medicamento, caracteristica) VALUES ('paracetamol', 5.0, 1, 'venda exclusiva com receita');


--
-- Data for Name: vendas; Type: TABLE DATA; Schema: public; Owner: debora
--



--
-- Name: vendas_id_venda_seq; Type: SEQUENCE SET; Schema: public; Owner: debora
--

SELECT pg_catalog.setval('public.vendas_id_venda_seq', 1, false);


--
-- Name: apenas_uma_sede; Type: CONSTRAINT; Schema: public; Owner: debora
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT apenas_uma_sede EXCLUDE USING gist (tipo_farmacia WITH =) WHERE ((tipo_farmacia = 'sede'::text));


--
-- Name: cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: debora
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (id_cliente);


--
-- Name: endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: debora
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (id_endereco, id_cliente);


--
-- Name: farmacias_bairro_key; Type: CONSTRAINT; Schema: public; Owner: debora
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT farmacias_bairro_key UNIQUE (bairro);


--
-- Name: farmacias_pkey; Type: CONSTRAINT; Schema: public; Owner: debora
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT farmacias_pkey PRIMARY KEY (id_farmacia);


--
-- Name: funcionarios_pkey; Type: CONSTRAINT; Schema: public; Owner: debora
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_pkey PRIMARY KEY (id_funcionario, funcao);


--
-- Name: super_key; Type: CONSTRAINT; Schema: public; Owner: debora
--

ALTER TABLE ONLY public.medicamentos
    ADD CONSTRAINT super_key PRIMARY KEY (id_medicamento, caracteristica);


--
-- Name: vendas_pkey; Type: CONSTRAINT; Schema: public; Owner: debora
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_pkey PRIMARY KEY (id_venda);


--
-- Name: chave_gerente; Type: FK CONSTRAINT; Schema: public; Owner: debora
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT chave_gerente FOREIGN KEY (id_gerente, tipo_gerente) REFERENCES public.funcionarios(id_funcionario, funcao);


--
-- Name: cliente_id_farmacia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: debora
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_id_farmacia_fkey FOREIGN KEY (id_farmacia) REFERENCES public.farmacias(id_farmacia);


--
-- Name: endereco_id_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: debora
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.cliente(id_cliente);


--
-- Name: entregas_id_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: debora
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_id_cliente_fkey FOREIGN KEY (id_cliente, id_endereco) REFERENCES public.endereco(id_cliente, id_endereco);


--
-- Name: entregas_id_farmacia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: debora
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_id_farmacia_fkey FOREIGN KEY (id_farmacia) REFERENCES public.farmacias(id_farmacia);


--
-- Name: entregas_id_venda_fkey; Type: FK CONSTRAINT; Schema: public; Owner: debora
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_id_venda_fkey FOREIGN KEY (id_venda) REFERENCES public.vendas(id_venda);


--
-- Name: funcionarios_id_farmacia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: debora
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_id_farmacia_fkey FOREIGN KEY (id_farmacia) REFERENCES public.farmacias(id_farmacia);


--
-- Name: vendas_id_farmacia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: debora
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_id_farmacia_fkey FOREIGN KEY (id_farmacia) REFERENCES public.farmacias(id_farmacia);


--
-- Name: vendas_id_funcionario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: debora
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_id_funcionario_fkey FOREIGN KEY (id_funcionario, funcionario) REFERENCES public.funcionarios(id_funcionario, funcao) ON DELETE RESTRICT;


--
-- Name: vendas_id_medicamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: debora
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_id_medicamento_fkey FOREIGN KEY (id_medicamento, caracteristica_medicamento) REFERENCES public.medicamentos(id_medicamento, caracteristica) ON DELETE RESTRICT;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

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
--ja existe uma farmacia nesse bairro
INSERT INTO farmacias VALUES('Dias', 03, 'filial', 01, 'farmaceutico', 'PB', 'malvinas', 'cg');
--a funcao nao existe
INSERT INTO funcionarios VALUES('Maria', 02, 01, 'programador');
--um gerente deve ser farmaceutico ou adminstrador
INSERT INTO farmacias VALUES('Dias', 02, 'filial', 02, 'caixa', 'PB', 'cruzeiro', 'cg');
--tipo do endereco invalido
INSERT INTO endereco VALUES(01, 'rua almirante barroso', 20, 'Quarenta', 'cg', 'feira', 01);


