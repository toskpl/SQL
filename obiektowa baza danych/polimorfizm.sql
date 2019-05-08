--obiekt instrument
CREATE TYPE instrument AS OBJECT
(
  nazwa  VARCHAR2(20),
  dzwiek VARCHAR2(20),
  MEMBER FUNCTION graj RETURN VARCHAR2
)
NOT FINAL;

/

--obiekt instrument z funkcja graj
CREATE TYPE BODY instrument AS
  MEMBER FUNCTION graj RETURN VARCHAR2 IS
  BEGIN
    RETURN dzwiek;
  END;
END;
/

--obiekt instrument_dety dziedziczacy po obiekcie instrument
CREATE TYPE instrument_dety UNDER instrument
(
  material VARCHAR2(20),
  OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2,
  MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2
);
 
--obiekt instrument_dety implementacja funkcji 
CREATE OR REPLACE TYPE BODY instrument_dety AS
  OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
  BEGIN
    RETURN 'dmucham: ' || dzwiek;
  END;
  MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN glosnosc || ':' || dzwiek;
  END;
END;
/
--obiekt instrument_klawiszowy dziedziczacy po obiekcie instrument
CREATE TYPE instrument_klawiszowy UNDER instrument
(
  producent VARCHAR2(20),
  OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2
);

/

--obiekt instrument_dety implementacja funkcji
CREATE OR REPLACE TYPE BODY instrument_klawiszowy AS
  OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
  BEGIN
    RETURN 'stukam w klawisze: ' || dzwiek;
  END;
END;
/

--polimorfizm
DECLARE
 tamburyn instrument := instrument('tamburyn','brzdek-brzdek');
 trabka instrument_dety := instrument_dety('trabka','tra-ta-ta','metalowa');
 fortepian instrument_klawiszowy := instrument_klawiszowy('fortepian','pingping','steinway');
BEGIN
 dbms_output.put_line(tamburyn.graj);
 dbms_output.put_line(trabka.graj);
 dbms_output.put_line(trabka.graj('glosno'));
 dbms_output.put_line(fortepian.graj);
END;

/

CREATE TABLE instrumenty OF instrument;
INSERT INTO instrumenty VALUES ( instrument('tamburyn','brzdek-brzdek') );
INSERT INTO instrumenty VALUES ( instrument_dety('trabka','tra-tata','metalowa') );
INSERT INTO instrumenty VALUES ( instrument_klawiszowy('fortepian','pingping','steinway') );
SELECT i.nazwa, i.graj() FROM instrumenty i; 

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

--typ istota
CREATE TYPE istota AS OBJECT
(
  nazwa VARCHAR2(20),
  NOT INSTANTIABLE MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR
)
NOT INSTANTIABLE NOT FINAL;

/
--typ lew
CREATE TYPE lew UNDER istota
(
  liczba_nog NUMBER,
  OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR
);

/

--implementacja funkcji 
CREATE OR REPLACE TYPE BODY lew AS
  OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR IS
  BEGIN
    RETURN 'upolowana ofiara: ' || ofiara;
  END;
END;
/

DECLARE
  KrolLew    lew := lew('LEW', 4);
  --InnaIstota istota := istota('FOKA'); --blad ORA
BEGIN
  DBMS_OUTPUT.PUT_LINE(KrolLew.poluj('antylopa'));  
END;
