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

--
-- Name: hastaara(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.hastaara(hastano character varying) RETURNS TABLE(hasta_tc integer, hasta_adi character varying, hasta_soyadi character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT "hasta_tc", "hasta_adi", "hasta_soyadi" FROM hasta
                 WHERE "hasta_tc" = hastaNo;
END;
$$;


ALTER FUNCTION public.hastaara(hastano character varying) OWNER TO postgres;

--
-- Name: kayitEkle(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."kayitEkle"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW."doktor.doktor_adi" = UPPER(NEW."doktor.doktor_adi"); -- büyük harfe dönüştürdükten sonra ekle
    
    IF NEW."doktor_cepTel" IS NULL THEN
            RAISE EXCEPTION 'CEP TELEFON boş olamaz';  
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public."kayitEkle"() OWNER TO postgres;

--
-- Name: kayitdolanimi(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.kayitdolanimi() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    hastalar hasta%ROWTYPE; -- hasta."hasta_tc"%TYPE
    sonuc TEXT;
BEGIN
    sonuc := '';
    FOR hastalar IN SELECT * FROM hasta LOOP
        sonuc := sonuc || hastalar."hasta_tc" || E'\t' || hastalar."hasta_adi" || E'\r\n';
    END LOOP;
    RETURN sonuc;
END;
$$;


ALTER FUNCTION public.kayitdolanimi() OWNER TO postgres;

--
-- Name: kdvli ilac fiyatı(money); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."kdvli ilac fiyatı"(fiyat money, OUT kdvli real) RETURNS real
    LANGUAGE plpgsql
    AS $$
	 BEGIN
	 kdvli := 1.18 * ilac.fiyatı;
	END; 
	$$;


ALTER FUNCTION public."kdvli ilac fiyatı"(fiyat money, OUT kdvli real) OWNER TO postgres;

--
-- Name: odaDegisikligiTR1(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."odaDegisikligiTR1"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW."oda_no" <> OLD."oda_no" THEN
        INSERT INTO "hastaodadegisikligi"("hastaTC", "eskiOda", "yeniOda", "degisiklikTarihi")
        VALUES(OLD."hasta_tc", OLD."oda_no", NEW."oda_no", CURRENT_TIMESTAMP::TIMESTAMP);
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public."odaDegisikligiTR1"() OWNER TO postgres;

--
-- Name: sınırlama(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."sınırlama"() RETURNS character varying
    LANGUAGE plpgsql
    AS $$
	 DECLARE BEGIN
	 SELECT * FROM hasta WHERE yas<30;
	END; 
	$$;


ALTER FUNCTION public."sınırlama"() OWNER TO postgres;

SET default_tablespace = '';

--
-- Name: doktor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doktor (
    doktor_id character varying NOT NULL,
    "kullanici_Adi" character varying(10) NOT NULL,
    sifre character varying(20) NOT NULL,
    doktor_adi character varying(10) NOT NULL,
    doktor_soyadi character varying(20),
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
-- Name: hastaodadegisikligi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hastaodadegisikligi (
    "kayitNo" integer NOT NULL,
    "hastaTC" character varying NOT NULL,
    "eskiOda" real NOT NULL,
    "yeniOda" real NOT NULL,
    "degisiklikTarihi" timestamp without time zone NOT NULL
);


ALTER TABLE public.hastaodadegisikligi OWNER TO postgres;

--
-- Name: hastaodadegisikligi_kayitNo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."hastaodadegisikligi_kayitNo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."hastaodadegisikligi_kayitNo_seq" OWNER TO postgres;

--
-- Name: hastaodadegisikligi_kayitNo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."hastaodadegisikligi_kayitNo_seq" OWNED BY public.hastaodadegisikligi."kayitNo";


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
-- Name: hastaodadegisikligi kayitNo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hastaodadegisikligi ALTER COLUMN "kayitNo" SET DEFAULT nextval('public."hastaodadegisikligi_kayitNo_seq"'::regclass);


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
	(1234567810, 'Hakkı', 'Şen', 'Erkek', 'Ankara', '1973-12-24', '12345', 'Sevim', 'Hasan', '05441597535', 'hakkı@hasta.com', 6, 'Novalgin', 44),
	(123456787, 'veli', 'ateş', 'erkek', 'Kırşehir', '2021-08-24', '12345', 'havva', 'arif', '02554556565', 'veli@hasta.com', 5, 'Parol', 30),
	(2121212212, 'aslan', 'seren', 'Erkek', '', '2021-08-24', '', '', '', '', '', 7, 'Parol', 66),
	(123456789, 'Ahmet', 'Arslan', 'Erkek', 'Kayseri', '1966-08-18', '12345', 'Hayriye', 'Adem', '05112252255', 'ahmet@hasta.com', 15, 'Parol', 25);


--
-- Data for Name: hastaodadegisikligi; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.hastaodadegisikligi VALUES
	(2, '123456789', 1, 15, '2021-08-25 18:03:44.181752');


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
-- Name: hastaodadegisikligi_kayitNo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."hastaodadegisikligi_kayitNo_seq"', 2, true);


--
-- Name: hastaodadegisikligi PK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hastaodadegisikligi
    ADD CONSTRAINT "PK" PRIMARY KEY ("kayitNo");


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
-- Name: hasta hastaOdaDegistiginde; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "hastaOdaDegistiginde" BEFORE UPDATE ON public.hasta FOR EACH ROW EXECUTE PROCEDURE public."odaDegisikligiTR1"();


--
-- Name: doktor kayitKontrol; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "kayitKontrol" BEFORE INSERT OR UPDATE ON public.doktor FOR EACH ROW EXECUTE PROCEDURE public."kayitEkle"();


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

