SELECT nr_konta, SUM(kwota) AS suma, RANK() OVER(ORDER BY SUM(kwota) DESC) RANK
  FROM transakcje
 GROUP BY nr_konta
 ORDER BY suma DESC;

/

SELECT ntile(4) OVER(ORDER BY DATA) ntile, kwota, DATA, kategoria
  FROM transakcje
 WHERE nr_konta = '11-11111111'
 ORDER BY DATA;

/

SELECT MIN(DATA),
       nr_konta,
       RANK() OVER(PARTITION BY nr_konta ORDER BY 1 DESC) AS ranking
  FROM transakcje
 GROUP BY nr_konta
 
/

SELECT DATA, nr_konta,ranking
  FROM (SELECT to_char(DATA, 'YYYY') AS DATA,
               nr_konta,
               RANK() OVER(PARTITION BY nr_konta ORDER BY COUNT(*) DESC) AS ranking
          FROM transakcje
         GROUP BY nr_konta, to_char(DATA, 'YYYY'))
 WHERE ranking <= 1
 
/

SELECT kwota,
       data,
       AVG(kwota) OVER(ORDER BY data RANGE INTERVAL '6' MONTH PRECEDING) średnia
  FROM transakcje
 ORDER BY data;

/

SELECT kwota,
       nr_konta,
       SUM(kwota) OVER(PARTITION BY nr_konta ORDER BY nr_konta, data) AS saldo,
       data
  FROM transakcje
 ORDER BY nr_konta, data;
 
/

SELECT *
  FROM (SELECT kwota,
               nr_konta,
               SUM(kwota) OVER(PARTITION BY nr_konta ORDER BY nr_konta, data) AS saldo,
               data
          FROM transakcje
         ORDER BY nr_konta, data)
 WHERE saldo < 0
 
/

SELECT nr_konta,
       data,
       kwota,
       round(kwota - AVG(kwota) OVER(PARTITION BY NR_KONTA), 2) AS avg_k
  FROM transakcje
 WHERE kategoria IN ('PENSJA')
 GROUP BY nr_konta, data, kwota, kategoria
 ORDER BY nr_konta, data

 /
 
SELECT to_char(data, 'YYYY') rok,
       SUM(kwota) przychod,
       SUM(kwota) - LAG(SUM(kwota), 1) OVER(ORDER BY to_char(data, 'YYYY')) roznica
  FROM transakcje
GROUP BY to_char(data, 'YYYY');

/

SELECT RANK(3000) WITHIN GROUP(ORDER BY SUM(kwota) DESC) GDZIE_3000
  FROM transakcje
 GROUP BY TO_CHAR(data, 'YYYY');