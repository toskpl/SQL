
DROP TABLE produkcja CASCADE CONSTRAINTS;
DROP TABLE produkty CASCADE CONSTRAINTS;
DROP VIEW prod_prod;

CREATE TABLE produkty
( produkt_id NUMBER(2) PRIMARY KEY,
  nazwa VARCHAR2(15) NOT NULL,
  kategoria VARCHAR2(15) NOT NULL);

CREATE TABLE produkcja
( ilosc_prod NUMBER(4) NOT NULL,
  ilosc_sprzed NUMBER (4) NOT NULL,
  produkt_id NUMBER(2) NOT NULL,
  miesiac NUMBER(2) NOT NULL,
  rok NUMBER(4) NOT NULL,
  CONSTRAINT prod_fk FOREIGN KEY (produkt_id) REFERENCES produkty(produkt_id));

INSERT INTO produkty VALUES (1, 'krzesło A', 'meble kuchenne');
INSERT INTO produkty VALUES (2, 'fotel A', 'meble salonowe');
INSERT INTO produkty VALUES (3, 'stół dębowy', 'meble kuchenne');
INSERT INTO produkty VALUES (4, 'stół jesion', 'meble salonowe');
INSERT INTO produkty VALUES (5, 'krzesło plastik', 'meble ogrodowe');
INSERT INTO produkty VALUES (6, 'stół plastik', 'meble ogrodowe');

INSERT INTO produkcja VALUES (50, 40, 1, 1, 2000);
INSERT INTO produkcja VALUES (55, 51, 1, 2, 2000);
INSERT INTO produkcja VALUES (30, 15, 2, 1, 2000);
INSERT INTO produkcja VALUES (20, 15, 2, 2, 2000);
INSERT INTO produkcja VALUES (10,  8, 3, 1, 2000);
INSERT INTO produkcja VALUES (10, 10, 3, 2, 2000);
INSERT INTO produkcja VALUES (15,  9, 4, 1, 2000);
INSERT INTO produkcja VALUES (15, 11, 4, 2, 2000);
INSERT INTO produkcja VALUES (70, 69, 5, 1, 2000);
INSERT INTO produkcja VALUES (80, 76, 5, 2, 2000);
INSERT INTO produkcja VALUES (55, 35, 6, 1, 2000);
INSERT INTO produkcja VALUES (60, 25, 6, 2, 2000);
INSERT INTO produkcja VALUES (65, 45, 1, 1, 2001);
INSERT INTO produkcja VALUES (65, 55, 1, 2, 2001);
INSERT INTO produkcja VALUES (35, 35, 2, 1, 2001);
INSERT INTO produkcja VALUES (30, 25, 2, 2, 2001);
INSERT INTO produkcja VALUES (15, 14, 3, 1, 2001);
INSERT INTO produkcja VALUES (15, 10, 3, 2, 2001);
INSERT INTO produkcja VALUES (60, 49, 1, 3, 2000);

COMMIT;

CREATE OR REPLACE VIEW prod_prod
AS 
SELECT nazwa, kategoria, ilosc_prod, ilosc_sprzed, miesiac, rok
FROM produkcja pa, produkty pr
WHERE pa.produkt_id=pr.produkt_id;