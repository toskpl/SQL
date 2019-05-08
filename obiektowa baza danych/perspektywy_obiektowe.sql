--tabela przedmioty
CREATE TABLE PRZEDMIOTY (
 NAZWA VARCHAR2(50),
 NAUCZYCIEL NUMBER REFERENCES PRACOWNICY(ID_PRAC)
);
/

INSERT INTO PRZEDMIOTY VALUES ('BAZY DANYCH', 100);
INSERT INTO PRZEDMIOTY VALUES ('SYSTEMY OPERACYJNE', 100);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE', 110);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE', 110);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE', 120);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA', 120);
INSERT INTO PRZEDMIOTY VALUES ('BAZY DANYCH', 130);
INSERT INTO PRZEDMIOTY VALUES ('SYSTEMY OPERACYJNE', 140);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE', 140);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE', 140);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE', 150);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA', 150);
INSERT INTO PRZEDMIOTY VALUES ('BAZY DANYCH', 160);
INSERT INTO PRZEDMIOTY VALUES ('SYSTEMY OPERACYJNE', 160);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE', 170);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE', 180);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE', 180);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA', 190);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA', 200);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA', 210);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE', 220);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE', 220);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE', 230);

----------------------------------------------------------------------------------


CREATE TYPE ZESPOL AS OBJECT (
 ID_ZESP NUMBER,
 NAZWA VARCHAR2(50),
 ADRES VARCHAR2(100)
);
/ 

--widok na podstawie obiektu Zespol

CREATE OR REPLACE VIEW ZESPOLY_V OF ZESPOL
WITH OBJECT IDENTIFIER(ID_ZESP)
AS SELECT ID_ZESP, NAZWA, ADRES FROM ZESPOLY; 


CREATE TYPE PRZEDMIOTY_TAB AS TABLE OF VARCHAR2(100);
/

--obiekt typu PRACOWNIK_PRZEDMIOT
CREATE TYPE PRACOWNIK_PRZEDMIOT AS OBJECT
(
  ID_PRAC       NUMBER,
  NAZWISKO      VARCHAR2(30),
  ETAT          VARCHAR2(20),
  ZATRUDNIONY   DATE,
  PLACA_POD     NUMBER(10, 2),
  MIEJSCE_PRACY REF ZESPOL,
  PRZEDMIOTY    PRZEDMIOTY_TAB,
  MEMBER FUNCTION ILE_PRZEDMIOTOW RETURN NUMBER
);
/

--implemetnacja funkcji 
CREATE OR REPLACE TYPE BODY PRACOWNIK_PRZEDMIOT AS
  MEMBER FUNCTION ILE_PRZEDMIOTOW RETURN NUMBER IS
  BEGIN
    RETURN PRZEDMIOTY.COUNT();
  END ILE_PRZEDMIOTOW;
END;

/

-- widok z wykorzystaniem obiektu PRACOWNIK_PRZEDMIOT
CREATE OR REPLACE VIEW PRACOWNICY_V OF PRACOWNIK_PRZEDMIOT
WITH OBJECT IDENTIFIER (ID_PRAC)
AS SELECT ID_PRAC, NAZWISKO, ETAT, ZATRUDNIONY, PLACA_POD,
 MAKE_REF(ZESPOLY_V,ID_ZESP),
 CAST(MULTISET( SELECT NAZWA FROM PRZEDMIOTY WHERE NAUCZYCIEL=P.ID_PRAC ) AS PRZEDMIOTY_TAB )
FROM PRACOWNICY P; 

/

SELECT * FROM PRACOWNICY_V;

SELECT P.NAZWISKO, P.ETAT, P.MIEJSCE_PRACY.NAZWA FROM PRACOWNICY_V P;

SELECT P.NAZWISKO, P.ILE_PRZEDMIOTOW() FROM PRACOWNICY_V P;

SELECT *
FROM TABLE( SELECT PRZEDMIOTY FROM PRACOWNICY_V WHERE NAZWISKO='WEGLARZ' );

SELECT NAZWISKO,
       CURSOR (SELECT PRZEDMIOTY FROM PRACOWNICY_V WHERE ID_PRAC = P.ID_PRAC)
  FROM PRACOWNICY_V P;