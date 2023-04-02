-----------------------------------------------
---- SQL SCRIPT -> SECOND PART OF PROJECT  ----
-- Autor: Marek Spirka -- xlogin: xspirk01 ----
-- Autor: Adam Gabrys  -- xlogin: xgabry01 ----
-----------------------------------------------

----------------DROP TABLES--------------------

DROP TABLE aplikace CASCADE CONSTRAINTS;
DROP TABLE verze CASCADE CONSTRAINTS;
DROP TABLE organizace CASCADE CONSTRAINTS;
DROP TABLE zamestnanec CASCADE CONSTRAINTS;
DROP TABLE smlouva CASCADE CONSTRAINTS;
DROP TABLE manazer CASCADE CONSTRAINTS;
DROP TABLE vyvojar CASCADE CONSTRAINTS;
DROP TABLE doba_smlouvy CASCADE CONSTRAINTS;
DROP TABLE pocet_instalaci CASCADE CONSTRAINTS;

----------------MAKE TABLES--------------------

CREATE TABLE aplikace (
    id_aplikace INT GENERATED ALWAYS AS IDENTITY (START WITH 1 increment by 1) primary key,
    nazov VARCHAR(255) NOT NULL,
    popis VARCHAR(255),
    platforma VARCHAR(7) CHECK (platforma IN('IOS', 'Android', 'LINUX', 'Windows')),
    webstranka VARCHAR(255) NOT NULL
);

CREATE TABLE verze (
    id_verze INT GENERATED ALWAYS AS IDENTITY (START WITH 1 increment by 1) primary key,
    nazov VARCHAR(255) NOT NULL,
    popis VARCHAR(500) NOT NULL,
    datum_vydania VARCHAR(10) NOT NULL CHECK (REGEXP_LIKE(datum_vydania,'^(0?[1-9]|[1-2][0-9]|3[0-1])-(0?[1-9]|1[0-2])-(\d{4})$')), --aj ked existuje DATE pouzili sme vlastny regex v tvare DD-MM-YYYY
    id_aplikace INT NOT NULL,
    FOREIGN KEY (id_aplikace) REFERENCES aplikace(id_aplikace) ON DELETE CASCADE
);

CREATE TABLE organizace (
    ico varchar(20) NOT NULL CHECK (REGEXP_LIKE(ico,'^\d{8}$')) PRIMARY KEY , --regex na ICO
    obchodny_nazov VARCHAR(100) NOT NULL,
    sidlo VARCHAR(50) NOT NULL,
    pravna_forma VARCHAR(100) NOT NULL,
    predmet_podnikania VARCHAR(150) NOT NULL,
    iban  VARCHAR(30) NOT NULL CHECK (REGEXP_LIKE(iban, 'CZ\d{2}[ ]\d{4}[ ]\d{4}[ ]\d{4}[ ]\d{4}[ ]\d{4}|CZ\d{22}')) --check validný input pre IBAN
);

CREATE TABLE zamestnanec (
    rodne_cislo NUMBER(10) NOT NULL CHECK (REGEXP_LIKE(rodne_cislo, '\d{2}(0[1-9]|1[0-2]|5[1-9]|6[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])\d{3,4}')) PRIMARY KEY, --bez lomitka
    meno VARCHAR(50) NOT NULL,
    priezvisko VARCHAR(50) NOT NULL,
    telefon VARCHAR(20) NOT NULL CHECK (REGEXP_LIKE(telefon,'^\+\d{12}$')), --berieme s predvolbou bez pluska
    mail VARCHAR(50)
);

CREATE TABLE smlouva (
    id_zmluvy INT GENERATED ALWAYS AS IDENTITY (START WITH 1 increment by 1) primary key,
    datum_zavretia VARCHAR(10) NOT NULL CHECK (REGEXP_LIKE(datum_zavretia,'^(0?[1-9]|[1-2][0-9]|3[0-1])-(0?[1-9]|1[0-2])-(\d{4})$')), --aj ked existuje DATE pouzili sme vlastny regex v tvare DD-MM-YYYY
    predavajuci VARCHAR(100) NOT NULL,
    kupujuci VARCHAR(100) NOT NULL
);

CREATE TABLE pocet_instalaci(
    pocet_instalaci INT NOT NULL,
    id_zmluvy INT,
    id_verze INT,
    FOREIGN KEY (id_zmluvy) REFERENCES smlouva(id_zmluvy),
    FOREIGN KEY (id_verze) REFERENCES verze(id_verze)
);

CREATE TABLE doba_smlouvy (
    ucinost_od VARCHAR(10) NOT NULL CHECK (REGEXP_LIKE(ucinost_od,'^(0?[1-9]|[1-2][0-9]|3[0-1])-(0?[1-9]|1[0-2])-(\d{4})$')), --aj ked existuje DATE pouzili sme vlastny regex v tvare DD-MM-YYYY
    ucinost_do VARCHAR(10) NOT NULL CHECK (REGEXP_LIKE(ucinost_do,'^(0?[1-9]|[1-2][0-9]|3[0-1])-(0?[1-9]|1[0-2])-(\d{4})$')), --aj ked existuje DATE pouzili sme vlastny regex v tvare DD-MM-YYYY
    id_zmluvy INT,
    rodne_cislo INT,
    FOREIGN KEY (id_zmluvy) REFERENCES smlouva(id_zmluvy),
    FOREIGN KEY (rodne_cislo) REFERENCES zamestnanec(rodne_cislo)
);

CREATE TABLE vyvojar (
    rodne_cislo NUMBER(10) NOT NULL CHECK (REGEXP_LIKE(rodne_cislo, '\d{2}(0[1-9]|1[0-2]|5[1-9]|6[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])\d{3,4}')), --rodne cislo bez lomitku
    prog_jazyk VARCHAR(20),
    FOREIGN KEY (rodne_cislo) REFERENCES zamestnanec(rodne_cislo)
);

CREATE TABLE manazer (
    rodne_cislo NUMBER(10) NOT NULL CHECK (REGEXP_LIKE(rodne_cislo, '\d{2}(0[1-9]|1[0-2]|5[1-9]|6[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])\d{3,4}')), --rodne cislo bez lomitku
    oddeleni VARCHAR(25) CHECK (oddeleni IN('Vyvojarske oddeleni', 'Logistika a prodej', 'Technicke oddeleni', 'Financni oddeleni', 'Oddeleni planovani', 'Testovaci oddeleni')),
    FOREIGN KEY (rodne_cislo) REFERENCES zamestnanec(rodne_cislo)
);

----------------INPUT TO TABLES--------------------

INSERT INTO zamestnanec VALUES(3002056954, 'adam', 'Novak', '+123456789012', 'asdadsada@gmail.com');
INSERT INTO zamestnanec VALUES(3502316955, 'marek', 'Hess', '+789654000012', 'marek@gmail.com');
INSERT INTO zamestnanec VALUES(2402056966, 'jan', 'Plecko', '+123456789012', 'asdadsada@gmail.com');
INSERT INTO zamestnanec VALUES(3502316977, 'jarek', 'Hecko', '+789654000012', 'marek@gmail.com');


INSERT INTO vyvojar(rodne_cislo, prog_jazyk) VALUES(3002056954, 'Python');
INSERT INTO vyvojar(rodne_cislo, prog_jazyk) VALUES(3502316977, 'PHP');


INSERT INTO manazer(rodne_cislo, oddeleni) VALUES(2402056966, 'Logistika a prodej');
INSERT INTO manazer(rodne_cislo, oddeleni) VALUES(3502316955, 'Vyvojarske oddeleni');


INSERT INTO aplikace(nazov, popis, platforma, webstranka) VALUES('firstapp', 'krasna appka', 'IOS', 'firstapp.com');
INSERT INTO aplikace(nazov, popis, platforma, webstranka) VALUES('secondapp', 'vyborna appka', 'Android', 'secondtapp.com');
INSERT INTO aplikace(nazov, popis, platforma, webstranka) VALUES('thirdapp', 'mobilni appka', 'Android', 'thirdapp.com');


INSERT INTO verze(nazov, popis, datum_vydania, id_aplikace) VALUES('v2', 'edited config', '24-03-2006', 2);
INSERT INTO verze(nazov, popis, datum_vydania, id_aplikace) VALUES('v3.4', 'for config', '21-03-2002', 1);
INSERT INTO verze(nazov, popis, datum_vydania, id_aplikace) VALUES('v9.4', 'final version', '21-03-2002', 3);


INSERT INTO smlouva(DATUM_ZAVRETIA, PREDAVAJUCI, KUPUJUCI) VALUES('24-04-2015', 'adam', 'marek');
INSERT INTO smlouva(DATUM_ZAVRETIA, PREDAVAJUCI, KUPUJUCI) VALUES('24-04-2015', 'adam', 'jozef');
INSERT INTO smlouva(DATUM_ZAVRETIA, PREDAVAJUCI, KUPUJUCI) VALUES('20-04-2015', 'adam', 'anicka');
INSERT INTO smlouva(DATUM_ZAVRETIA, PREDAVAJUCI, KUPUJUCI) VALUES('04-06-2016', 'marek', 'adam');


INSERT INTO doba_smlouvy(UCINOST_OD, UCINOST_DO, ID_ZMLUVY, RODNE_CISLO) VALUES('24-04-2015','24-04-2022', 1, 3502316955);
INSERT INTO doba_smlouvy(UCINOST_OD, UCINOST_DO, ID_ZMLUVY, RODNE_CISLO) VALUES('26-02-2012','21-12-2032', 2, 3502316977);
INSERT INTO doba_smlouvy(UCINOST_OD, UCINOST_DO, ID_ZMLUVY, RODNE_CISLO) VALUES('26-02-2012','21-12-2032', 3, 2402056966);


INSERT INTO ORGANIZACE(ICO, OBCHODNY_NAZOV, SIDLO, PRAVNA_FORMA, PREDMET_PODNIKANIA, IBAN)
VALUES('12345678', 'Facebook', 'Amsterdam', 'Vedecka', 'vyvoj umele inteligence','CZ12 3456 7890 1234 5678 9012');
INSERT INTO ORGANIZACE(ICO, OBCHODNY_NAZOV, SIDLO, PRAVNA_FORMA, PREDMET_PODNIKANIA, IBAN)
VALUES('87654321', 'Google', 'Amsterdam', 's.r.o.', 'vyvoj regexu','CZ34 5634 7890 1234 5678 9012');


INSERT INTO pocet_instalaci(pocet_instalaci, ID_ZMLUVY, ID_VERZE) VALUES(10000, 1, 1);
INSERT INTO pocet_instalaci(pocet_instalaci, ID_ZMLUVY, ID_VERZE) VALUES(200000, 2, 2);
INSERT INTO pocet_instalaci(pocet_instalaci, ID_ZMLUVY, ID_VERZE) VALUES(1000000, 3, 3);

COMMIT;

--1. Vypise zamestnanca spolu s programovacim jazykom, ktory ovlada
SELECT meno, priezvisko, prog_jazyk AS Jazyk
FROM zamestnanec NATURAL JOIN vyvojar;

--2. Vypis verzii, ich datum vydania a naslede maximalny pocet instalacii
SELECT verze.nazov Verzia, verze.datum_vydania, pocet_instalaci.pocet_instalaci
FROM pocet_instalaci INNER JOIN verze ON pocet_instalaci.id_verze = verze.id_verze;

--3. Ake aplikacie boli vytvoren� pre android? (n�zov aplikacie, verzia, pocet instalacii)
SELECT A.nazov, V.nazov Verzia, V.datum_vydania , pocet_instalaci
FROM aplikace A, verze V, pocet_instalaci P
WHERE A.id_aplikace = V.id_aplikace AND V.id_verze = P.id_verze AND A.platforma='Android';

--4. Kolko zmluv podpisali zamestnanci s rovnakym krstnym menom? (Pocet, pocet_stiahnutia)
SELECT meno, telefon, COUNT(*) Pocet_podpisov
FROM zamestnanec Z, smlouva S
WHERE Z.meno=S.predavajuci GROUP BY meno, telefon



