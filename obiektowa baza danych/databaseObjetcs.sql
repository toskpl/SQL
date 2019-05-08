--obiekt Pracownik
CREATE TYPE Pracownik AS OBJECT
(
  nazwisko VARCHAR2(20),
  pensja   NUMBER(6, 2),
  etat     VARCHAR2(15),
  data_ur  DATE
);

--tabela obiektów
CREATE TABLE PracownicyObjTab OF PRACOWNIK;

--wstaw obiekt pracownik
INSERT INTO PracownicyObjTab
VALUES (NEW Pracownik('Kowalski', 2500, 'ASYSTENT', DATE '1965-07-01'));
 
/ 

--pobranie danych obiektowych
SELECT * FROM PracownicyObjTab;

SELECT VALUE(p) FROM PracownicyObjTab p; 

/

--tabela projektow z obiektem Pracownik
CREATE TABLE ProjektyTab (
 symbol CHAR(6),
 nazwa VARCHAR(100),
 budzet NUMBER,
 kierownik Pracownik);

--wstaw rekord do projekty z obiektem Pracownik
INSERT INTO ProjektyTab VALUES
('AB 001','Projekt X',20000,
 NEW Pracownik('Nowak',3200,'ADIUNKT',null)); 
 
/
--pobranie danych obiektowych
SELECT nazwa, kierownik FROM ProjektyTab;

SELECT p.kierownik.nazwisko, p.kierownik.pensja FROM ProjektyTab p;

/
--objekt Pracownik rozbudowany o funkcje
ALTER TYPE Pracownik REPLACE AS OBJECT (
 nazwisko VARCHAR2(20),
 pensja NUMBER(6,2),
 etat VARCHAR2(15),
 data_ur DATE,
 MEMBER FUNCTION wiek RETURN NUMBER,
 MEMBER PROCEDURE podwyzka(p_kwota NUMBER) );
/

-- implemetajca funkcji
CREATE OR REPLACE TYPE BODY Pracownik AS
  MEMBER FUNCTION wiek RETURN NUMBER IS
  BEGIN
    RETURN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM data_ur);
  END wiek;
  MEMBER PROCEDURE podwyzka(p_kwota NUMBER) IS
  BEGIN
    pensja := pensja + p_kwota;
  END podwyzka;
END;
/ 


--
SELECT p.nazwisko, p.data_ur, p.wiek() FROM PracownicyObjTab p;

DECLARE
  l_kierownik Pracownik;
BEGIN
  SELECT kierownik
    INTO l_kierownik
    FROM ProjektyTab
   WHERE symbol = 'AB 001';
  l_kierownik.podwyzka(200);
  UPDATE ProjektyTab SET kierownik = l_kierownik WHERE symbol = 'AB 001';
END;

SELECT VALUE(p), REF(p) FROM PracownicyObjTab p; 

/

--dodaj funkcje odwzoruj do obiektu Pracownik
ALTER TYPE Pracownik ADD MAP MEMBER FUNCTION odwzoruj
RETURN NUMBER CASCADE INCLUDING TABLE DATA;

-- implemetajca funkcji 
CREATE OR REPLACE TYPE BODY Pracownik AS
  MEMBER FUNCTION wiek RETURN NUMBER IS
  BEGIN
    RETURN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM data_ur);
  END wiek;
  MEMBER PROCEDURE podwyzka(p_kwota NUMBER) IS
  BEGIN
    pensja := pensja + p_kwota;
  END podwyzka;
  MAP MEMBER FUNCTION odwzoruj RETURN NUMBER IS
  BEGIN
    RETURN ROUND(pensja, -3) + wiek();
  END odwzoruj;
END;
/ 

--wstaw nowe rekordy
INSERT INTO PracownicyObjTab
VALUES
  (NEW Pracownik('Nowak', 2000, 'ADIUNKT', DATE '1961-02-15'));
  
INSERT INTO PracownicyObjTab
VALUES
  (NEW Pracownik('Janiak', 1800, 'ASYSTENT', DATE '1973-12-02'));
 
SELECT p.nazwisko, p.pensja, p.wiek()
  FROM PracownicyObjTab p
 ORDER BY VALUE(p);

SELECT *
  FROM PracownicyObjTab p
 WHERE VALUE(p) >
       (SELECT VALUE(r) FROM PracownicyObjTab r WHERE r.nazwisko = 'Janiak');
/

--dodano konstruktor w obiecie Pracownik
ALTER TYPE Pracownik REPLACE AS OBJECT (
 nazwisko VARCHAR2(20),
 pensja NUMBER(6,2),
 etat VARCHAR2(15),
 data_ur DATE,
 MEMBER FUNCTION wiek RETURN NUMBER,
 MEMBER PROCEDURE podwyzka(p_kwota NUMBER),
 MAP MEMBER FUNCTION odwzoruj RETURN NUMBER,
 CONSTRUCTOR FUNCTION Pracownik(p_nazwisko VARCHAR2)
 RETURN SELF AS RESULT );

/

--implementacja konstruktora

CREATE OR REPLACE TYPE BODY Pracownik AS
  MEMBER FUNCTION wiek RETURN NUMBER IS
  BEGIN
    RETURN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM data_ur);
  END wiek;
  MEMBER PROCEDURE podwyzka(p_kwota NUMBER) IS
  BEGIN
    pensja := pensja + p_kwota;
  END podwyzka;
  MAP MEMBER FUNCTION odwzoruj RETURN NUMBER IS
  BEGIN
    RETURN ROUND(pensja, -3) + wiek();
  END odwzoruj;
  CONSTRUCTOR FUNCTION Pracownik(p_nazwisko VARCHAR2) RETURN SELF AS RESULT IS
  BEGIN
    SELF.nazwisko := p_nazwisko;
    SELF.pensja   := 1000;
    SELF.etat     := null;
    SELF.data_ur  := null;
    RETURN;
  END;
END;
/ 

--wstaw nowy rekord z obiektem Pracownik (wykorzystanowo konstruktor)
INSERT INTO PracownicyObjTab VALUES (
 NEW Pracownik('Dziamdziak') ); 
 
/

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--nowe obiety
CREATE TYPE Adres AS OBJECT
(
  ulica      VARCHAR2(15),
  dom        NUMBER(4),
  mieszkanie NUMBER(3)
);

CREATE TYPE Osoba AS OBJECT
(
  Nazwisko     VARCHAR2(20),
  Imie         VARCHAR2(15),
  GdzieMieszka REF Adres
);

--tabele obiektowe
CREATE TABLE AdresyObjTab OF Adres;
CREATE TABLE OsobyObjTab OF Osoba;

ALTER TABLE OsobyObjTab ADD
SCOPE FOR(GdzieMieszka) IS AdresyObjTab;

--wstaw rekordy do tabel obiektowych
INSERT INTO AdresyObjTab VALUES
 (NEW Adres('Kolejowa',2,18));

INSERT INTO OsobyObjTab VALUES
 (NEW Osoba('Kowalska','Anna',null));

INSERT INTO OsobyObjTab VALUES
 (NEW Osoba('Kowalski','Jan',null));

UPDATE OsobyObjTab o
SET o.gdziemieszka = (
 SELECT REF(a) FROM AdresyObjTab a
 WHERE a.ulica = 'Kolejowa' ); 
 
-- referencje

SELECT o.imie, o.nazwisko, DEREF(o.gdziemieszka) FROM OsobyObjTab o;

SELECT o.imie, o.nazwisko, o.gdziemieszka.ulica, o.gdziemieszka.dom
  FROM OsobyObjTab o;

SELECT o.imie, o.nazwisko, a.ulica, a.dom, a.mieszkanie
  FROM OsobyObjTab o
  JOIN AdresyObjTab a
    ON o.gdziemieszka = REF(a);
    
/

DELETE FROM AdresyObjTab a WHERE a.ulica = 'Kolejowa';
SELECT * FROM OsobyObjTab o WHERE o.gdziemieszka IS NULL;
SELECT * FROM OsobyObjTab o WHERE o.gdziemieszka IS DANGLING; 

/

