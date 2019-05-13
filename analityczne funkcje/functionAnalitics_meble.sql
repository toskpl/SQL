--funkcja CUBE

SELECT kategoria, rok, SUM(ilosc_sprzed)
  FROM prod_prod
 GROUP BY CUBE(kategoria, rok)
 ORDER BY kategoria,rok;

/

--funkcja ROLLUP
SELECT kategoria, miesiac, rok, SUM(ilosc_sprzed)
  FROM prod_prod
 GROUP BY ROLLUP(kategoria, miesiac, rok);

/

--funkcja ROLLUP + GROUPING
SELECT kategoria,
       miesiac,
       rok,
       SUM(ilosc_sprzed),
       SUM(ilosc_prod),
       GROUPING(kategoria),
       GROUPING(miesiac)
  FROM prod_prod
 GROUP BY ROLLUP(kategoria, miesiac, rok);

/

--funkcja GROUPING SETS
SELECT nazwa, kategoria, rok, SUM(ilosc_sprzed)
  FROM prod_prod
 GROUP BY GROUPING SETS((nazwa, rok),(kategoria, rok),())
 ORDER BY 1, 3, 2;
 
/

-- funkcja RANK() i DENSE_RANK()
SELECT *
  FROM (SELECT kategoria,
               SUM(ilosc_sprzed) AS suma,
               rok,
               RANK() OVER(PARTITION BY kategoria ORDER BY SUM(ilosc_sprzed) ASC NULLS LAST) AS pozycja,
               DENSE_RANK() OVER(ORDER BY SUM(ilosc_sprzed) DESC NULLS LAST) AS drank
          FROM prod_prod
         GROUP BY kategoria, rok)
 WHERE rok = 2001;

/

--funkcja RANK() i DENSE_RANK()
SELECT *
  FROM (SELECT nazwa,
               SUM(ilosc_sprzed) AS suma,
               kategoria,
               RANK() OVER(PARTITION BY kategoria ORDER BY SUM(ilosc_sprzed) DESC NULLS LAST) AS pozycja,
               DENSE_RANK() OVER(ORDER BY SUM(ilosc_sprzed) DESC NULLS LAST) AS drank
          FROM prod_prod
         GROUP BY nazwa, kategoria)
         WHERE pozycja = 1;

/
--funkcja MAX
SELECT *
  FROM (SELECT 
               kategoria,
               rok,
               SUM(ilosc_sprzed) AS suma,
               MAX(SUM(ilosc_sprzed)) OVER(PARTITION BY kategoria ) AS max_kategoria
          FROM prod_prod
         GROUP BY kategoria, rok
         ORDER BY kategoria,rok);

/
--funkcja UNBOUNDED PRECEDING suma kumulacyjna
SELECT nazwa,miesiac,rok,
       SUM(ilosc_sprzed) produkcja,
       SUM(SUM(ilosc_sprzed)) OVER(ORDER BY nazwa ROWS UNBOUNDED PRECEDING) AS cum_sum
  FROM prod_prod
  WHERE nazwa = 'fotel A'
 GROUP BY nazwa,miesiac,rok
 
 
/

--RANK what if analysis - ranking hipotetyczny

SELECT RANK(140) WITHIN GROUP(ORDER BY SUM(ilosc_sprzed) DESC) AS hrank
  FROM prod_prod
 GROUP BY nazwa;
 
/

-- LAG i LEAD 
SELECT rok,
       miesiac,
       nazwa,
       LAG(SUM(ilosc_sprzed), 1) OVER(ORDER BY rok , miesiac, nazwa) AS poprzedni,
       LAG(SUM(ilosc_sprzed), 0) OVER(ORDER BY rok , miesiac, nazwa) AS biezacy,
       LEAD(SUM(ilosc_sprzed), 1) OVER(ORDER BY rok , miesiac, nazwa) AS nastepny,
       LAG(SUM(ilosc_sprzed), 0) OVER(ORDER BY rok , miesiac, nazwa) -
       LAG(SUM(ilosc_sprzed), 1) OVER(ORDER BY rok , miesiac, nazwa) AS biezacy_poprzedni,
       LEAD(SUM(ilosc_sprzed), 1) OVER(ORDER BY rok , miesiac, nazwa) -
       LAG(SUM(ilosc_sprzed), 0) OVER(ORDER BY rok , miesiac, nazwa) AS nstepny_biezacy

  FROM prod_prod
 WHERE nazwa = 'krzesło A'
 GROUP BY nazwa, miesiac, rok
 ORDER BY rok , miesiac, nazwa


