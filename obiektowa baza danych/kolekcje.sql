--Kolekcje
DECLARE
  TYPE t_ksiazki IS VARRAY(10) OF VARCHAR2(20);
  moje_ksiazki t_ksiazki := t_ksiazki('');
BEGIN
  moje_ksiazki(1) := 'PAN TADEUSZ';
  moje_ksiazki.EXTEND(9);
  FOR i IN 2 .. 10 LOOP
    moje_ksiazki(i) := 'KSIAZKI_' || i;
  END LOOP;
  FOR i IN moje_ksiazki.FIRST() .. moje_ksiazki.LAST() LOOP
    DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
  END LOOP;
  moje_ksiazki.TRIM(2);
  FOR i IN moje_ksiazki.FIRST() .. moje_ksiazki.LAST() LOOP
    DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
  DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
  moje_ksiazki.EXTEND();
  moje_ksiazki(9) := 9;
  DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
  DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());

  moje_ksiazki.DELETE();
  DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
  DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
END;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------


DECLARE
  TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
  moje_przedmioty t_przedmioty := t_przedmioty('');
BEGIN
  moje_przedmioty(1) := 'MATEMATYKA';
  moje_przedmioty.EXTEND(9);
  FOR i IN 2 .. 10 LOOP
    moje_przedmioty(i) := 'PRZEDMIOT_' || i;
  END LOOP;
  FOR i IN moje_przedmioty.FIRST() .. moje_przedmioty.LAST() LOOP
    DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
  END LOOP;
  moje_przedmioty.TRIM(2);
  FOR i IN moje_przedmioty.FIRST() .. moje_przedmioty.LAST() LOOP
    DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
  DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
  moje_przedmioty.EXTEND();
  moje_przedmioty(9) := 9;
  DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
  DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());

  moje_przedmioty.DELETE();
  DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
  DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
END;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------


DECLARE
  TYPE t_wykladowcy IS TABLE OF VARCHAR2(20);
  moi_wykladowcy t_wykladowcy := t_wykladowcy();
BEGIN
  moi_wykladowcy.EXTEND(2);
  moi_wykladowcy(1) := 'MORZY';
  moi_wykladowcy(2) := 'WOJCIECHOWSKI';
  moi_wykladowcy.EXTEND(8);
  FOR i IN 3 .. 10 LOOP
    moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
  END LOOP;
  FOR i IN moi_wykladowcy.FIRST() .. moi_wykladowcy.LAST() LOOP
    DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
  END LOOP;
  moi_wykladowcy.TRIM(2);
  FOR i IN moi_wykladowcy.FIRST() .. moi_wykladowcy.LAST() LOOP
    DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
  END LOOP;
  moi_wykladowcy.DELETE(5, 7);
  DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
  DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
  FOR i IN moi_wykladowcy.FIRST() .. moi_wykladowcy.LAST() LOOP
    IF moi_wykladowcy.EXISTS(i) THEN
      DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
    END IF;
  END LOOP;
  moi_wykladowcy(5) := 'ZAKRZEWICZ';
  moi_wykladowcy(6) := 'KROLIKOWSKI';
  moi_wykladowcy(7) := 'KOSZLAJDA';

  FOR i IN moi_wykladowcy.FIRST() .. moi_wykladowcy.LAST() LOOP
    IF moi_wykladowcy.EXISTS(i) THEN
      DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
    END IF;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
  DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
END;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------


DECLARE
  TYPE t_miesiace IS TABLE OF VARCHAR2(20);
  moje_miesiace t_miesiace := t_miesiace();
BEGIN
  moje_miesiace.EXTEND(2);
  moje_miesiace(1) := 'STYCZEŃ';
  moje_miesiace(2) := 'LUTY';
  moje_miesiace.EXTEND(8);
  FOR i IN 3 .. 10 LOOP
    moje_miesiace(i) := 'MIESIAC_' || i;
  END LOOP;
  FOR i IN moje_miesiace.FIRST() .. moje_miesiace.LAST() LOOP
    DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
  END LOOP;
  moje_miesiace.TRIM(2);
  FOR i IN moje_miesiace.FIRST() .. moje_miesiace.LAST() LOOP
    DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
  END LOOP;
  moje_miesiace.DELETE(5, 7);
  DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_miesiace.LIMIT());
  DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_miesiace.COUNT());
  FOR i IN moje_miesiace.FIRST() .. moje_miesiace.LAST() LOOP
    IF moje_miesiace.EXISTS(i) THEN
      DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
    END IF;
  END LOOP;
  moje_miesiace(5) := 'MARZEC';
  moje_miesiace(6) := 'KWIECIEŃ';
  moje_miesiace(7) := 'MAJ';

  FOR i IN moje_miesiace.FIRST() .. moje_miesiace.LAST() LOOP
    IF moje_miesiace.EXISTS(i) THEN
      DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
    END IF;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_miesiace.LIMIT());
  DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_miesiace.COUNT());
END;
