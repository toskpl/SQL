--typ jezyki_obce i stypendium
CREATE TYPE jezyki_obce AS VARRAY(10) OF VARCHAR2(20);
/

CREATE TYPE stypendium AS OBJECT
(
  nazwa  VARCHAR2(50),
  kraj   VARCHAR2(30),
  jezyki jezyki_obce
);

/

--tabela stypendia dla obiektów stypendim
CREATE TABLE stypendia OF stypendium;

INSERT INTO stypendia
VALUES
  ('SOKRATES',
   'FRANCJA',
   jezyki_obce('ANGIELSKI', 'FRANCUSKI', 'NIEMIECKI'));
INSERT INTO stypendia
VALUES
  ('ERASMUS',
   'NIEMCY',
   jezyki_obce('ANGIELSKI', 'NIEMIECKI', 'HISZPANSKI'));

SELECT * FROM stypendia;
SELECT s.jezyki FROM stypendia s;

UPDATE STYPENDIA
SET jezyki = jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI','FRANCUSKI')
WHERE nazwa = 'ERASMUS';

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
--typ lista_egzaminow i semestr

CREATE TYPE lista_egzaminow AS TABLE OF VARCHAR2(20);
/

CREATE TYPE semestr AS OBJECT (
 numer NUMBER,
 egzaminy lista_egzaminow );
/

CREATE TABLE semestry OF semestr
NESTED TABLE egzaminy STORE AS tab_egzaminy;

INSERT INTO semestry
VALUES
  (semestr(1, lista_egzaminow('MATEMATYKA', 'LOGIKA', 'ALGEBRA')));
  
INSERT INTO semestry
VALUES
  (semestr(2, lista_egzaminow('BAZY DANYCH', 'SYSTEMY OPERACYJNE')));
  
SELECT s.numer, e.* FROM semestry s, TABLE(s.egzaminy) e;

SELECT e.* FROM semestry s, TABLE(s.egzaminy) e;

SELECT * FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=1 );

INSERT INTO TABLE
  (SELECT s.egzaminy FROM semestry s WHERE numer = 2)
VALUES
  ('METODY NUMERYCZNE');
  
UPDATE TABLE (SELECT s.egzaminy FROM semestry s WHERE numer = 2) e
   SET e.column_value = 'SYSTEMY ROZPROSZONE'
 WHERE e.column_value = 'SYSTEMY OPERACYJNE';

DELETE FROM TABLE (SELECT s.egzaminy FROM semestry s WHERE numer = 2) e
 WHERE e.column_value = 'BAZY DANYCH';


SELECT s.numer, e.* FROM semestry s, TABLE(s.egzaminy) e;

SELECT e.* FROM semestry s, TABLE(s.egzaminy) e;

SELECT * FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=1 );


------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
--typ lista_zakupow i koszyk

CREATE TYPE lista_zakupow AS TABLE OF VARCHAR2(20);
/

CREATE TYPE koszyk AS OBJECT (
 numer NUMBER,
 zakupy lista_zakupow );
/

CREATE TABLE koszyki OF koszyk
NESTED TABLE zakupy STORE AS tab_zakupy;

INSERT INTO koszyki
VALUES
  (koszyk(1, lista_zakupow('MASŁO', 'CHLEB', 'MLEKO')));
  
INSERT INTO koszyki
VALUES
  (koszyk(2, lista_zakupow('PIWO', 'WOODKA')));
  
SELECT s.numer, e.* FROM koszyki s, TABLE(s.zakupy) e;

SELECT e.* FROM koszyki s, TABLE(s.zakupy) e;

SELECT * FROM TABLE ( SELECT s.zakupy FROM koszyki s WHERE numer=1 );

INSERT INTO TABLE
  (SELECT s.zakupy FROM koszyki s WHERE numer = 2)
VALUES
  ('SOCZEK');
  
UPDATE TABLE (SELECT s.zakupy FROM koszyki s WHERE numer = 2) e
   SET e.column_value = 'SOCZEK POMARAŃCZOWY'
 WHERE e.column_value = 'SOCZEK';

DELETE FROM TABLE (SELECT s.zakupy FROM koszyki s WHERE numer = 2) e
 WHERE e.column_value = 'PIWO';


SELECT s.numer, e.* FROM koszyki s, TABLE(s.zakupy) e;

SELECT e.* FROM koszyki s, TABLE(s.zakupy) e;

SELECT * FROM TABLE ( SELECT s.zakupy FROM koszyki s WHERE numer=1 );