--
-- PostgreSQL database dump
--

-- Dumped from database version 10.18
-- Dumped by pg_dump version 13.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

--
-- Name: doktor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doktor (
    doktor_id character varying NOT NULL,
    "kullanici_Adi" character varying(10) NOT NULL,
    sifre character varying(20) NOT NULL,
    doktor_adi character varying(10) NOT NULL,
    doktor_soyadi character varying(20) NOT NULL,
    klinik_id character varying(30) NOT NULL,
    "doktor_cepTel" character varying(11) NOT NULL,
    "doktor_ePosta" character varying(30) NOT NULL
);


ALTER TABLE public.doktor OWNER TO postgres;

--
-- Name: hasta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hasta (
    hasta_tc integer NOT NULL,
    hasta_adi character varying(10) NOT NULL,
    hasta_soyadi character varying(20) NOT NULL,
    hasta_cinsiyeti character varying(5) NOT NULL,
    "hasta_doğumYeri" character varying(20),
    "hasta_doğumTarihi" date,
    hasta_parola character varying,
    "hasta_anneAdi" character varying(10),
    "Hasta_babaAdi" character varying,
    "Hasta_cepTel" character varying(11),
    "Hasta_ePosta" character varying(24),
    oda_no smallint NOT NULL,
    ilac_ismi character varying NOT NULL,
    yas integer
);


ALTER TABLE public.hasta OWNER TO postgres;

--
-- Name: ilac; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ilac (
    gram smallint,
    "fiyatı" money,
    ilac_ismi character varying NOT NULL
);


ALTER TABLE public.ilac OWNER TO postgres;

--
-- Name: klinik; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.klinik (
    klinik_id character varying(30) NOT NULL,
    klinik_adi character varying(30) NOT NULL
);


ALTER TABLE public.klinik OWNER TO postgres;

--
-- Name: randevu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.randevu (
    doktor_id character varying(10) NOT NULL,
    randevu_saat time without time zone NOT NULL,
    hasta_tc integer NOT NULL,
    randevu_klinik_id character varying NOT NULL,
    randevu_id integer NOT NULL,
    randevu_tarih date NOT NULL
);


ALTER TABLE public.randevu OWNER TO postgres;

--
-- Name: recete; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recete (
    ilac_ismi character varying(30) NOT NULL
);


ALTER TABLE public.recete OWNER TO postgres;

--
-- Name: ucret; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ucret (
    fiyat money,
    hasta_tc integer NOT NULL
);


ALTER TABLE public.ucret OWNER TO postgres;

--
-- Name: yatak; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.yatak (
    oda_no smallint NOT NULL
);


ALTER TABLE public.yatak OWNER TO postgres;

--
-- Name: yönetici; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."yönetici" (
    kullanici_id character varying(30) NOT NULL,
    kullanici_adi character varying(10) NOT NULL,
    kullanici_sifre character varying(20) NOT NULL
);


ALTER TABLE public."yönetici" OWNER TO postgres;

--
-- Data for Name: doktor; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.doktor VALUES
	('18', 'ahmet1', '12345', 'Ahmet', 'Taş', '66', '05325558899', 'ahmet@saglik.com'),
	('12', 'sevket2', '12345', 'Şevket', 'keser', '65', '05625886588', 'sevket@saglik.com');


--
-- Data for Name: hasta; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.hasta VALUES
	(12124555, 'Nisa', 'Nur', 'Kadın', 'Yozgat', '2005-04-26', '12345', 'Fatma', 'Ali', '05365776580', 'nisa@hasta.com', 3, 'Parol', 30),
	(123456789, 'Ahmet', 'Arslan', 'Erkek', 'Kayseri', '1966-08-18', '12345', 'Hayriye', 'Adem', '05112252255', 'ahmet@hasta.com', 1, 'Parol', 25),
	(1234567810, 'Hakkı', 'Şen', 'Erkek', 'Ankara', '1973-12-24', '12345', 'Sevim', 'Hasan', '05441597535', 'hakkı@hasta.com', 6, 'Novalgin', 44),
	(123456787, 'veli', 'ateş', 'erkek', 'Kırşehir', '2021-08-24', '12345', 'havva', 'arif', '02554556565', 'veli@hasta.com', 5, 'Parol', 30),
	(2121212212, 'aslan', 'seren', 'Erkek', '', '2021-08-24', '', '', '', '', '', 7, 'Parol', 66);


--
-- Data for Name: ilac; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ilac VALUES
	(200, '?18,00', 'Parol'),
	(500, '?25,00', 'Novalgin'),
	(150, '?9,00', 'Asprin'),
	(300, '?22,00', 'Agumentin');


--
-- Data for Name: klinik; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.klinik VALUES
	('66', 'Şehir Hastane'),
	('65', 'Özel Hastane'),
	('64', 'Numune Hastanesi');


--
-- Data for Name: randevu; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.randevu VALUES
	('18', '09:00:00', 123456789, '65', 1, '2021-08-23');


--
-- Data for Name: recete; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.recete VALUES
	('Parol'),
	('Agumentin'),
	('Novalgin'),
	('Asprin');


--
-- Data for Name: ucret; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ucret VALUES
	('?500,00', 123456789);


--
-- Data for Name: yatak; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.yatak VALUES
	(1),
	(2),
	(3),
	(4),
	(5),
	(6),
	(7),
	(8),
	(9),
	(10),
	(11),
	(12),
	(13),
	(14),
	(15),
	(16),
	(17),
	(18),
	(19),
	(20),
	(21);


--
-- Data for Name: yönetici; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."yönetici" VALUES
	('1', 'admin', '12345'),
	('2', 'resul', '12345');


--
-- Name: doktor doktor_klinik_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doktor
    ADD CONSTRAINT doktor_klinik_id_key UNIQUE (klinik_id);


--
-- Name: doktor doktor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doktor
    ADD CONSTRAINT doktor_pkey PRIMARY KEY (doktor_id);


--
-- Name: hasta hasta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hasta
    ADD CONSTRAINT hasta_pkey PRIMARY KEY (hasta_tc);


--
-- Name: ilac ilac_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ilac
    ADD CONSTRAINT ilac_pkey PRIMARY KEY (ilac_ismi);


--
-- Name: klinik klinik_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klinik
    ADD CONSTRAINT klinik_pkey PRIMARY KEY (klinik_id);


--
-- Name: randevu randevu_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.randevu
    ADD CONSTRAINT randevu_pkey PRIMARY KEY (randevu_id);


--
-- Name: recete recete_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recete
    ADD CONSTRAINT recete_pkey PRIMARY KEY (ilac_ismi);


--
-- Name: hasta unique_hasta_Hasta_cepTel; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hasta
    ADD CONSTRAINT "unique_hasta_Hasta_cepTel" UNIQUE ("Hasta_cepTel");


--
-- Name: hasta unique_hasta_yatak_no; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hasta
    ADD CONSTRAINT unique_hasta_yatak_no UNIQUE (oda_no);


--
-- Name: ilac unique_ilac_ilac_ismi; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ilac
    ADD CONSTRAINT unique_ilac_ilac_ismi UNIQUE (ilac_ismi);


--
-- Name: randevu unique_randevu_doktor_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.randevu
    ADD CONSTRAINT unique_randevu_doktor_id UNIQUE (doktor_id);


--
-- Name: randevu unique_randevu_randevu_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.randevu
    ADD CONSTRAINT unique_randevu_randevu_id UNIQUE (randevu_id);


--
-- Name: ucret unique_ucret_hasta_tc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ucret
    ADD CONSTRAINT unique_ucret_hasta_tc UNIQUE (hasta_tc);


--
-- Name: yatak yatak_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yatak
    ADD CONSTRAINT yatak_pkey PRIMARY KEY (oda_no);


--
-- Name: yönetici yönetici_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."yönetici"
    ADD CONSTRAINT "yönetici_pkey" PRIMARY KEY (kullanici_id);


--
-- Name: randevu Klinik_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.randevu
    ADD CONSTRAINT "Klinik_id" FOREIGN KEY (randevu_klinik_id) REFERENCES public.klinik(klinik_id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: hasta hasta_ilac; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hasta
    ADD CONSTRAINT hasta_ilac FOREIGN KEY (ilac_ismi) REFERENCES public.ilac(ilac_ismi) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ucret hasta_tc2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ucret
    ADD CONSTRAINT hasta_tc2 FOREIGN KEY (hasta_tc) REFERENCES public.hasta(hasta_tc) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: recete ilac_ismi1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recete
    ADD CONSTRAINT ilac_ismi1 FOREIGN KEY (ilac_ismi) REFERENCES public.ilac(ilac_ismi) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: doktor klinik_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doktor
    ADD CONSTRAINT klinik_id FOREIGN KEY (klinik_id) REFERENCES public.klinik(klinik_id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: hasta oda_no; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hasta
    ADD CONSTRAINT oda_no FOREIGN KEY (oda_no) REFERENCES public.yatak(oda_no) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: randevu randevu_hasta_tc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.randevu
    ADD CONSTRAINT randevu_hasta_tc FOREIGN KEY (hasta_tc) REFERENCES public.hasta(hasta_tc) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

