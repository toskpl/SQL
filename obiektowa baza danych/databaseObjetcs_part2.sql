----obiekt Samochod

CREATE TYPE pojazd AS OBJECT
(
  MARKA VARCHAR2(20),
  MODEL VARCHAR2(20),
  KILOMETRY NUMBER,
  DATA_PRODUKCJI DATE,
  CENA NUMBER(10,2)
);

/

CREATE TABLE pojazdOfTab OF pojazd;

--wstaw obiekt pojazd
INSERT INTO pojazdOfTab
VALUES (NEW pojazd('FIAT', 'BRAVA', 60000, sysdate,25000));

INSERT INTO pojazdOfTab
VALUES (NEW pojazd('FORD', 'MONDEO', 80000, sysdate - 5 ,45000));

INSERT INTO pojazdOfTab
VALUES (NEW pojazd('MAZDA', '323', 12000, sysdate -12 ,52000));

----pobranie danych obiektowych
select * from pojazdOfTab; 

----tabela wlasciciel z obiektem pojazd
CREATE TABLE wlasciciel
(
 IMIE VARCHAR2(100),
 NAZWISKO VARCHAR2(100),
 AUTO pojazd 
);

--wstaw rekord do wlasciciel z obiektem pojazd
INSERT INTO wlasciciel VALUES
('ICEK','SHCULZ',
 NEW pojazd('MAZDA', '323', 12000, sysdate -12 ,52000)); 
 
INSERT INTO wlasciciel VALUES
('ALFRED','INNY',
 NEW pojazd('FORD', 'MONDEO', 80000, sysdate - 5 ,45000)); 

INSERT INTO wlasciciel VALUES
('WALERY','XXXX',
 NEW pojazd('FIAT', 'BRAVA', 60000, sysdate,25000)); 


SELECT * FROM wlasciciel;

/

----objekt pojazd rozbudowany o funkcje
ALTER TYPE pojazd REPLACE AS OBJECT (
  MARKA VARCHAR2(20),
  MODEL VARCHAR2(20),
  KILOMETRY NUMBER,
  DATA_PRODUKCJI DATE,
  CENA NUMBER(10,2),
  MEMBER FUNCTION wiek RETURN NUMBER);

--dodaj funkcje wartosc do obiektu pojazd
ALTER TYPE pojazd ADD MAP MEMBER FUNCTION wartosc
RETURN NUMBER CASCADE INCLUDING TABLE DATA;

-- implementacja funkcji 
CREATE OR REPLACE TYPE BODY pojazd AS
  MEMBER FUNCTION wiek RETURN NUMBER IS
  BEGIN
    RETURN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM DATA_PRODUKCJI);
  END wiek;
  MAP MEMBER FUNCTION wartosc RETURN NUMBER IS
  BEGIN
    RETURN ROUND(CENA, -3) + wiek();
  END wartosc;
END;
/

SELECT p.marka, p.model,p.kilometry,p.wartosc() FROM pojazdOfTab p;

/

