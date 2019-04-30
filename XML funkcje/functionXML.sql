SELECT id_prac, XMLElement("PRACOWNIK", nazwisko) AS XML FROM pracownicy;

/

SELECT XMLElement("PRACOWNIK", XMLAttributes(id_prac), nazwisko) AS XML
FROM pracownicy; 

/

SELECT XMLElement("PRACOWNIK",
                  XMLAttributes(id_prac AS id),
                  XMLElement("NAZWISKO", nazwisko),
                  'pracuje jako ' || etat || ' i zarabia ',
                  XMLElement("PLACA", placa_pod + NVL(placa_dod, 0))) AS XML
  FROM pracownicy;
  
/

SELECT XMLElement("PRACOWNIK",
                  XMLAttributes(id_prac, placa_pod, placa_dod),
                  nazwisko) AS XML
  FROM pracownicy;

SELECT XMLElement("PRACOWNIK",
                  XMLAttributes(id_prac AS id),
                  XMLElement("NAZWISKO", nazwisko),
                  XMLElement("DODATEK", placa_dod)) AS XML
  FROM pracownicy;
  
/

SELECT XMLElement("PRACOWNIK",
                  XMLAttributes(id_prac AS id),
                  XMLForest(nazwisko, placa_dod AS "DODATEK")) AS XML
  FROM pracownicy;

SELECT XMLElement("PRACOWNIK",
                  XMLAttributes(id_prac AS "id"),
                  XMLForest(nazwisko AS "NAZWISKO",
                            XMLForest(placa_pod AS "PODSTAWA",
                                      placa_dod AS "DODATEK") AS "ZAROBKI")) AS XML
  FROM pracownicy;
  
/

SELECT XMLConcat(XMLElement("SZEF", S.NAZWISKO),
                 XMLElement("PODWLADNY", P.NAZWISKO)) AS XML
  FROM pracownicy p
  JOIN pracownicy s
    ON p.id_szefa = s.id_prac;

/

SELECT XMLConcat(XMLSequence(CURSOR (SELECT nazwisko, placa_pod, placa_dod
                                FROM pracownicy))) AS XML
  FROM dual;
  
/

SELECT XMLElement("ZESPOL",
                  XMLAttributes(z.id_zesp),
                  XMLElement("NAZWA", z.nazwa),
                  XMLElement("PRACOWNICY",
                             XMLAgg(XMLElement("PRACOWNIK", p.nazwisko)))) AS XML
  FROM pracownicy p
  JOIN zespoly z
    ON (p.id_zesp = z.id_zesp)
 GROUP BY z.id_zesp, z.nazwa;
 
/

SELECT XMLElement("PRACOWNIK",
                  XMLAttributes(id_prac AS ID),
                  XMLColAttVal(nazwisko AS NAZWISKO, placa_dod AS DODATEK)) AS XML
  FROM pracownicy;
  
SELECT XMLElement("PRACOWNIK",
                  XMLAttributes(id_prac AS ID),
                  XMLColAttVal(nazwisko AS "NAZWISKO",
                               XMLColAttVal(placa_pod AS "PODSTAWA",
                                            placa_dod AS "DODATEK") AS
                               "ZAROBKI")) AS XML
  FROM pracownicy;

/

SELECT XMLRoot(XMLElement("DOKUMENT",
                          SYS_XMLGEN('Chrząszcz brzmi w trzcinie',
                                     XMLFormat('FRAZA')),
                          XMLComment('Wiersz Jana Brzechwy')),
               VERSION '1.1') AS XML
  FROM dual;

/

SELECT XMLParse(CONTENT 'Ala ma <PIES>Asa</PIES>' WELLFORMED).isFragment()
  FROM dual;
