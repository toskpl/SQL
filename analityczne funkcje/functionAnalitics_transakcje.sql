SELECT RANK() OVER(PARTITION BY kategoria ORDER BY kwota DESC) RANK,
       DENSE_RANK() OVER(PARTITION BY kategoria ORDER BY kwota DESC) dense_rank,
       kategoria,
       data,
       kwota
  FROM transakcje
 WHERE nr_konta = '11-11111111'
 ORDER BY kategoria, kwota DESC;
/

SELECT CUME_DIST() OVER(ORDER BY kwota) cume_dist,
       PERCENT_RANK() OVER(ORDER BY kwota) percent_rank,
       kwota
  FROM transakcje
 WHERE nr_konta = '11-11111111'
   AND kategoria = 'PENSJA'
 ORDER BY kwota;

/

SELECT NTILE(4) OVER(ORDER BY kwota) ntile,
       ROW_NUMBER() OVER(ORDER BY kwota) row_number,
       kwota,
       data,
       kategoria
  FROM transakcje
 WHERE nr_konta = '11-11111111'
   AND kategoria IN ('PENSJA', 'RACHUNEK ZA TELEFON')
 ORDER BY kwota;

/

SELECT kwota,
       data,
       SUM(kwota) OVER(ORDER BY data) saldo,
       AVG(kwota) OVER(ORDER BY data RANGE INTERVAL '12' month PRECEDING) avg12,
       MIN(kwota) OVER(ORDER BY data rows 3 PRECEDING) min3,
       COUNT(*) OVER(ORDER BY data RANGE BETWEEN interval '6' month PRECEDING AND interval '6' month FOLLOWING) count6_6
  FROM transakcje
 WHERE nr_konta = '11-11111111'
 ORDER BY data;
/

SELECT kwota,
       data,
       kategoria,
       AVG(kwota) OVER(PARTITION BY kategoria) AS avg_k,
       kwota / SUM(kwota) OVER(PARTITION BY kategoria) AS ratio_to_report
  FROM transakcje
 WHERE nr_konta = '11-11111111'
 ORDER BY kategoria, data;

/

SELECT kwota,
       SUM(kwota) OVER(ORDER BY data) AS saldo,
       data AS od_dnia,
       LEAD(data, 1) OVER(ORDER BY data) AS do_dnia
  FROM transakcje
 WHERE nr_konta = '11-11111111'
 ORDER BY data;

/

SELECT TO_CHAR(data, 'yyyy'),
       MAX(kwota) przychod,
       MAX(data) keep(DENSE_RANK LAST ORDER BY kwota) dzien
  FROM transakcje
 WHERE nr_konta = '11-11111111'
 GROUP BY TO_CHAR(data, 'yyyy');
 
/

SELECT TO_CHAR(data, 'yyyy') rok,
       PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY kwota) disc,
       PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY kwota) cont
  FROM transakcje
 WHERE nr_konta = '11-11111111'
 GROUP BY TO_CHAR(data, 'yyyy');

/

SELECT RANK(3000) WITHIN GROUP(ORDER BY SUM(kwota) DESC) GDZIE_3000
  FROM transakcje
 GROUP BY nr_konta, TO_CHAR(data, 'YYYY');

 /

SET AUTOTRACE ON EXPLAIN

SELECT kwota, data, nr_konta
  FROM (SELECT kwota, data, nr_konta, RANK() OVER(ORDER BY kwota DESC) r
          FROM transakcje)
 WHERE r <= 3;

SELECT kwota, data, nr_konta
  FROM transakcje T1
 WHERE 3 >= (SELECT COUNT(*) FROM transakcje WHERE kwota >= T1.kwota);
/


