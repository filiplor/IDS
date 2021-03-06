DROP TABLE pastelky CASCADE CONSTRAINTS;
DROP TABLE skicaky CASCADE CONSTRAINTS;
DROP TABLE zbozi CASCADE CONSTRAINTS;
DROP TABLE dodavatel CASCADE CONSTRAINTS;
DROP TABLE objednavka CASCADE CONSTRAINTS;
DROP TABLE zamestnanec CASCADE CONSTRAINTS;
DROP TABLE hodnoceni_recenze CASCADE CONSTRAINTS;
DROP TABLE zakaznik CASCADE CONSTRAINTS;
DROP TABLE PRAVNICKA_OSOBA CASCADE CONSTRAINTS;
DROP TABLE objednane_zbozi;



CREATE TABLE pastelky (
id_pastelky INT GENERATED ALWAYS AS IDENTITY(START with 1 INCREMENT by 1) primary key, 
nazev VARCHAR (30) NOT NULL,
typ VARCHAR (30),
pocet_v_baleni INT NOT NULL,
CONSTRAINT pastelka_typ CHECK (typ IN ('voskove','pastely' , 'klasicke', 'plastove'))
);

CREATE TABLE skicaky (
id_skicak INT NOT NULL, 
nazev VARCHAR (30) NOT NULL,
velikost VARCHAR (30) NOT NULL,
gramaz INT NOT NULL,
pocet_listu INT NOT NULL,
CONSTRAINT PK_skicak PRIMARY KEY (id_skicak),
CONSTRAINT skicak_velikost CHECK (velikost IN ('A5', 'A4', 'A3'))
);

CREATE TABLE zbozi (
id_zbozi INT NOT NULL,
id_dodavatel INT NOT NULL,
id_pastelky INT,
id_skicaky INT,
id_zamestnance INT NOT NULL,
mnozstvi INT NOT NULL,
cena_za_kus FLOAT NOT NULL,
datum_dodani DATE NOT NULL,
CONSTRAINT PK_zbozi PRIMARY KEY (id_zbozi),
CONSTRAINT CHK_cena CHECK (cena_za_kus>0 AND cena_za_kus<=10000)

);

CREATE TABLE dodavatel (
id_dodavatele INT NOT NULL,
nazev VARCHAR(40),
ulice VARCHAR(20) NOT NULL,
cislo_popisne INTEGER NOT NULL,
mesto VARCHAR(20) NOT NULL,
psc INTEGER NOT NULL,
zeme VARCHAR(20) NOT NULL,
telefon VARCHAR(20) NOT NULL,
email VARCHAR(20) NOT NULL,
ico  VARCHAR(20) NOT NULL CHECK (REGEXP_LIKE(ico,'^\d{8}$')),
CONSTRAINT PK_dodavatel PRIMARY KEY (id_dodavatele)
);

CREATE TABLE objednavka (
id_objednavky INT NOT NULL,
id_zakaznika INT,
stav VARCHAR (20),
id_zamestnance INT,
datum_objednavky DATE NOT NULL,
CONSTRAINT PK_objednavky PRIMARY KEY (id_objednavky),
CONSTRAINT stav CHECK (stav IN ('odeslano', 'neodeslano'))
);

CREATE TABLE zamestnanec(
id_zamestnance INT NOT NULL,
jmeno VARCHAR(40) NOT NULL,
typ_smlouvy VARCHAR(30),
typ_opravneni VARCHAR(10),
login VARCHAR(20),
heslo VARCHAR(20),
CONSTRAINT PK_zamesnance PRIMARY KEY (id_zamestnance),
CONSTRAINT zamestnanec_enum CHECK (typ_opravneni IN ('zakladni', 'rozsirena'))
);

CREATE TABLE hodnoceni_recenze(
id_hodnoceni INT GENERATED ALWAYS AS IDENTITY(START with 1 INCREMENT by 1) primary key,
datum_hodnoceni DATE NOT NULL,
hodnoceni_text VARCHAR(80),
pocet_bodu INT,
id_zakaznika INT,
CONSTRAINT CHK_body CHECK (pocet_bodu>=0 AND pocet_bodu<=10)
);

CREATE TABLE zakaznik(
id_zakaznika INT NOT NULL,
jmeno VARCHAR(40),
ulice VARCHAR(20) NOT NULL,
cislo_popisne INTEGER NOT NULL,
mesto VARCHAR(20) NOT NULL,
psc INTEGER NOT NULL,
zeme VARCHAR(20) NOT NULL,
telefon VARCHAR(20) NOT NULL CHECK (REGEXP_LIKE(telefon,'^\+\d{12}$')),
email VARCHAR(20) NOT NULL,
CONSTRAINT PK_zakaznik PRIMARY KEY (id_zakaznika)
);

CREATE TABLE pravnicka_osoba(
ico VARCHAR(20) NOT NULL CHECK (REGEXP_LIKE(ico,'^\d{8}$')),
dic VARCHAR(20) NOT NULL,
id_zakaznika INT NOT NULL,
CONSTRAINT PK_pravos PRIMARY KEY (ico),
CONSTRAINT FK_pravnickaosoba FOREIGN KEY (id_zakaznika) REFERENCES zakaznik(id_zakaznika)
);

CREATE TABLE objednane_zbozi(
id_objednane_zbozi INT GENERATED ALWAYS AS IDENTITY(START with 1 INCREMENT by 1) PRIMARY KEY,
id_zbozi INT,
id_objednavky INT
);

ALTER TABLE  hodnoceni_recenze       ADD CONSTRAINT FK_id_autor           FOREIGN KEY(ID_zakaznika)      REFERENCES zakaznik;
ALTER TABLE  objednavka              ADD CONSTRAINT FK_id_objednavatel    FOREIGN KEY(ID_zakaznika)      REFERENCES zakaznik;
ALTER TABLE  zbozi                   ADD CONSTRAINT FK_id_dodavatel       FOREIGN KEY(ID_dodavatel)      REFERENCES dodavatel;
ALTER TABLE  zbozi                   ADD CONSTRAINT FK_id_prevzal         FOREIGN KEY(ID_zamestnance)    REFERENCES zamestnanec;
ALTER TABLE  zbozi                   ADD CONSTRAINT FK_id_pastelky        FOREIGN KEY(ID_pastelky)       REFERENCES pastelky;
ALTER TABLE  zbozi                   ADD CONSTRAINT FK_id_skicaky         FOREIGN KEY(ID_skicaky)        REFERENCES skicaky;
ALTER TABLE  objednavka              ADD CONSTRAINT FK_id_vyexpedoval     FOREIGN KEY(ID_zamestnance)    REFERENCES zamestnanec;
ALTER TABLE  objednane_zbozi         ADD CONSTRAINT FK_zbozi_objednano    FOREIGN KEY(ID_zbozi)          REFERENCES zbozi;
ALTER TABLE  objednane_zbozi         ADD CONSTRAINT FK_objednane_zbozi    FOREIGN KEY(ID_objednavky)     REFERENCES objednavka;


INSERT INTO pastelky (nazev, typ, pocet_v_baleni) VALUES ('kohinor', 'voskove', '6');
INSERT INTO pastelky (nazev, typ, pocet_v_baleni) VALUES ('pinocio', 'klasicke', '12');

INSERT INTO skicaky(id_skicak, nazev, velikost, gramaz, pocet_listu) VALUES ('1', 'hoot', 'A5', '210' , '20');
INSERT INTO skicaky(id_skicak, nazev, velikost, gramaz, pocet_listu) VALUES ('2', 'goot', 'A4', '200' , '30');
INSERT INTO skicaky(id_skicak, nazev, velikost, gramaz, pocet_listu) VALUES ('3', 'foot', 'A3', '220' , '50');

INSERT INTO dodavatel(id_dodavatele, nazev, ulice, cislo_popisne, mesto, psc, zeme, telefon, email, ico) VALUES ('1', 'pepone', 'Zahrand?', '456', 'BRNO', '58401', '?r', '+420566566566', 'peopo@gmail.com', '11111111');
INSERT INTO dodavatel(id_dodavatele, nazev, ulice, cislo_popisne, mesto, psc, zeme, telefon, email, ico) VALUES ('2', 'Huhu', 'hradn?', '457', 'Praha', '58401', 'Ger', '+420886566576', 'HUHU@gmail.com', '22221111');

INSERT INTO zakaznik (id_zakaznika, jmeno, ulice, cislo_popisne, mesto, psc, zeme, telefon, email) VALUES ('1', 'Viktor Ko?en?', 'Velk?', '112', 'Velk? Paka', '11101', '?r', '+420545666566', 'viktor@gmail.com');
INSERT INTO zakaznik (id_zakaznika, jmeno, ulice, cislo_popisne, mesto, psc, zeme, telefon, email) VALUES ('2', 'Viktor Hadrn?', 'Dlouh?', '1122', 'Velk? Draka', '11564', '?r', '+420545666577', 'viktor@seznam.com');
INSERT INTO zakaznik (id_zakaznika, jmeno, ulice, cislo_popisne, mesto, psc, zeme, telefon, email) VALUES ('3', 'Viktor Zelen?', 'Kr?tk?', '1232', 'Velk? Jezera', '11178', '?r', '+420545666599', 'viktor@centrum.com');
INSERT INTO zakaznik (id_zakaznika, jmeno, ulice, cislo_popisne, mesto, psc, zeme, telefon, email) VALUES ('4', 'Martin ?etrn?', 'Vlhk?', '53', 'Potkanice', '69420', '?r', '+370594522189', 'matospoko@gmail.com');

INSERT INTO hodnoceni_recenze(datum_hodnoceni, hodnoceni_text, pocet_bodu, id_zakaznika) VALUES (TO_DATE('17/12/2020', 'DD/MM/YYYY'), 'dobry obchod', '10', '1');
INSERT INTO hodnoceni_recenze(datum_hodnoceni, hodnoceni_text, pocet_bodu, id_zakaznika) VALUES (TO_DATE('8/5/2021', 'DD/MM/YYYY'), 'Pomaly dovoz', '5', '2');
INSERT INTO hodnoceni_recenze(datum_hodnoceni, hodnoceni_text, pocet_bodu, id_zakaznika) VALUES (TO_DATE('17/11/2021', 'DD/MM/YYYY'), 'Nejhor?? obchod kde jsem kdy byl', '1', '2');
INSERT INTO hodnoceni_recenze(datum_hodnoceni, hodnoceni_text, pocet_bodu, id_zakaznika) VALUES (TO_DATE('30/11/2021', 'DD/MM/YYYY'), 'Dal jsem mu druhou ?anci, obchod znovu sklamal', '2', '2');
INSERT INTO hodnoceni_recenze(datum_hodnoceni, hodnoceni_text, pocet_bodu, id_zakaznika) VALUES (TO_DATE('3/4/2022', 'DD/MM/YYYY'), 'Kvalitn? produkty, akor?t cena je vy???', '7', '3');
INSERT INTO hodnoceni_recenze(datum_hodnoceni, hodnoceni_text, pocet_bodu, id_zakaznika) VALUES (TO_DATE('10/2/2022', 'DD/MM/YYYY'), 'Produkt do?el rychle, kvalita je skv?l?', '10', '3');


INSERT INTO pravnicka_osoba(ico, dic, id_zakaznika) VALUES ('98765432',  'CZ9876543288', '3');

INSERT INTO zamestnanec(id_zamestnance, jmeno, typ_smlouvy, typ_opravneni, heslo, login) VALUES ('1', 'V?t Traktor', 'zakladni', 'zakladni', 'hoo5hoo', 'xpepa98');
INSERT INTO zamestnanec(id_zamestnance, jmeno, typ_smlouvy, typ_opravneni, heslo, login) VALUES ('2', 'Jan Auto', 'rozsirena', 'rozsirena', 'hoogoong', 'xjana98');

INSERT INTO objednavka(id_objednavky, id_zakaznika, id_zamestnance, stav, datum_objednavky) VALUES ('1', '1', '1', 'odeslano', TO_DATE('17/12/2020', 'DD/MM/YYYY'));
INSERT INTO objednavka(id_objednavky, id_zakaznika, id_zamestnance, stav, datum_objednavky) VALUES ('2', '2', '2', 'odeslano', TO_DATE('17/11/2021', 'DD/MM/YYYY'));
INSERT INTO objednavka(id_objednavky, id_zakaznika, id_zamestnance, stav, datum_objednavky) VALUES ('3', '3', '1', 'neodeslano', TO_DATE('03/4/2022', 'DD/MM/YYYY'));

INSERT INTO zbozi(id_zbozi, id_dodavatel, id_pastelky, id_zamestnance, mnozstvi, cena_za_kus, datum_dodani) VALUES ( '1', '1', '1', '1', '10', '200', TO_DATE('03/4/2020', 'DD/MM/YYYY'));
INSERT INTO zbozi(id_zbozi, id_dodavatel, id_skicaky, id_zamestnance, mnozstvi, cena_za_kus, datum_dodani) VALUES ( '2', '2','2', '1', '5', '230', TO_DATE('08/5/2021', 'DD/MM/YYYY'));
INSERT INTO zbozi(id_zbozi, id_dodavatel, id_pastelky, id_skicaky, id_zamestnance, mnozstvi, cena_za_kus, datum_dodani) VALUES ( '3', '1', '1', '1', '1', '50', '200', TO_DATE('03/4/2020', 'DD/MM/YYYY'));
INSERT INTO zbozi(id_zbozi, id_dodavatel, id_skicaky, id_zamestnance, mnozstvi, cena_za_kus, datum_dodani) VALUES ( '4', '2','1', '1', '60', '120', TO_DATE('15/6/2021', 'DD/MM/YYYY'));

INSERT INTO objednane_zbozi(id_zbozi, id_objednavky) VALUES ('1', '1');
INSERT INTO objednane_zbozi(id_zbozi, id_objednavky) VALUES ('2', '2');
INSERT INTO objednane_zbozi(id_zbozi, id_objednavky) VALUES ('3', '3');


--          SELECTY

--1. Kolik je pastelek dan?ch pastelek na sklade [ID_ZBOZI, MNOZSTVI] (2 tabulky, NATURAL JOIN)
SELECT id_zbozi, mnozstvi 
FROM zbozi NATURAL JOIN pastelky;

--2. Ktery zakaznik je pravnicka osoba? [ID, JMENO] (2 tabulky, INNER JOIN, ON)
SELECT pravnicka_osoba.id_zakaznika, zakaznik.jmeno 
FROM zakaznik INNER JOIN pravnicka_osoba ON zakaznik.id_zakaznika = pravnicka_osoba.id_zakaznika;

--3. Jak? zbo?? vyexpedoval zamestnanec V?t Traktor [JMENO, ID_ZBOZI, ID_OBJEDNAVKY](3 tabulky, NATURAL JOIN, WHERE)
SELECT zamestnanec.jmeno, id_zbozi, id_objednavky
FROM objednavka NATURAL JOIN objednane_zbozi NATURAL JOIN zamestnanec 
WHERE zamestnanec.jmeno = 'V?t Traktor';

--4. KOlik nejv?ce hodnocen? napsal jeden z?kazn?k (GROUP BY, COUNT())
SELECT id_zakaznika, COUNT(id_zakaznika) pocet_hodnoceni 
FROM hodnoceni_recenze 
GROUP BY id_zakaznika;

--5. Vyber jm?no a telefon nespokojen?ho z?kazn?ka. Najdeme ho podle ?patn?ch bodu recenze a zistime kolik krat se stazoval. [JMENO, TELEFON, POCET_ZLYCH_RECENZI, NEJNIZSI_HODNOCENI] (2 tabulky, NATURAL JOIN, GROUP BY, COUNT, MIN)
SELECT jmeno, telefon, COUNT(jmeno) nespokojne_recenze, MIN(pocet_bodu) nejnizsi_hodnoceni
FROM zakaznik NATURAL JOIN hodnoceni_recenze
WHERE pocet_bodu <= 5
GROUP BY jmeno, telefon;

--6. Vyberem v?echny produkty kter? byly u? n?kdy objedn?ny a expedov?ny. [ID_ZBOZI] (IN)
SELECT id_zbozi
FROM zbozi 
WHERE id_zbozi 
    IN (SELECT objednane_zbozi.id_zbozi FROM objednavka LEFT JOIN objednane_zbozi ON objednavka.id_objednavky = objednane_zbozi.id_objednavky WHERE objednavka.stav = 'odeslano');

--7. Vybere v?echny zakazn?ky, kte?? hodnotili n?? obchod. [JMENO, EMAIL] (EXISTS)
SELECT jmeno, email
FROM zakaznik z
WHERE EXISTS (SELECT datum_hodnoceni FROM hodnoceni_recenze hr WHERE hr.id_zakaznika = z.id_zakaznika);
