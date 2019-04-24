--create table figury
CREATE TABLE figury (
 id NUMBER(1) PRIMARY KEY,
 ksztalt MDSYS.SDO_GEOMETRY ); 
/
--insert figury
INSERT INTO figury
VALUES
  (1,
   MDSYS.SDO_GEOMETRY(2003,
                      null,
                      null,
                      MDSYS.SDO_ELEM_INFO_ARRAY(1, 1003, 4),
                      MDSYS.SDO_ORDINATE_ARRAY(7, 5, 5, 7, 3, 5)));
/
INSERT INTO figury
VALUES
  (2,
   MDSYS.SDO_GEOMETRY(2003,
                      null,
                      null,
                      MDSYS.SDO_ELEM_INFO_ARRAY(1, 1003, 3),
                      MDSYS.SDO_ORDINATE_ARRAY(1, 1, 5, 5)));
/
INSERT INTO figury
VALUES
  (3,
   MDSYS.SDO_GEOMETRY(2002,
                      null,
                      null,
                      MDSYS.SDO_ELEM_INFO_ARRAY(1, 4, 2, 1, 2, 1, 5, 2, 2),
                      MDSYS.SDO_ORDINATE_ARRAY(3, 2, 6, 2, 7, 3, 8, 2, 7, 1)));
                      
/

INSERT INTO figury
VALUES
  (4,
   MDSYS.SDO_GEOMETRY(2003,
                      null,
                      null,
                      MDSYS.SDO_ELEM_INFO_ARRAY(1, 1003, 4),
                      MDSYS.SDO_ORDINATE_ARRAY(7, 5, 5, 7, 4, 8)));
/
----------------------------------------------------------------------------------------------------
--validation inserted rows to figury
SELECT id, SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt, 0.01) AS stan
    FROM figury;

/

--delete bad rows
DELETE FROM figury
WHERE
 SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt,0.01)<>'TRUE'; 

----------------------------------------------------------------------------------------------------
--insert information to metadate in database
 
INSERT INTO USER_SDO_GEOM_METADATA
VALUES
  ('FIGURY',
   'KSZTALT',
   MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X', 0, 10, 0.01),
                       MDSYS.SDO_DIM_ELEMENT('Y', 0, 10, 0.01)),
   null);
/

--create index
CREATE INDEX figury_idx ON figury(ksztalt)
 INDEXTYPE IS MDSYS.SPATIAL_INDEX; 
 
/
SELECT id
  FROM figury
 WHERE SDO_FILTER(ksztalt,
                  MDSYS.SDO_GEOMETRY(2001,
                                     null,
                                     MDSYS.SDO_POINT_TYPE(7, 2, null),
                                     null,
                                     null),
                  'querytype=JOIN') = 'TRUE';

/

----------------------------------------------------------------------------------------------------
-- distance from the city Warsaw (100KM)
SELECT b.admin_name AS miasto
  FROM major_cities a, major_cities b
 WHERE SDO_WITHIN_DISTANCE(a.geom, b.geom, 'distance=100 unit=KM') = 'TRUE'
   AND a.admin_name = 'Warszawa'
   AND b.admin_name != 'Warszawa';

/
-- city in territory Slovakia
SELECT c.cntry_name AS kraj, m.city_name AS miasto
  FROM country_boundaries c, major_cities m
 WHERE SDO_RELATE(m.GEOM, c.GEOM, 'mask=INSIDE querytype=WINDOW') = 'TRUE'
   AND c.cntry_name = 'Slovakia';
/

--non-bordering countries with Poland (distance)
SELECT a.cntry_name AS panstwo,
       SDO_GEOM.SDO_DISTANCE(a.GEOM, pl.GEOM, 10, 'unit=KM') AS odl
  FROM country_boundaries a, country_boundaries pl
 WHERE SDO_RELATE(a.GEOM, pl.GEOM, 'mask=touch or equal querytype=WINDOW') <>
       'TRUE'
   AND pl.cntry_name = 'Poland';

/

--bordering countries with Poland (long border)
SELECT s.cntry_name,
       SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(s.GEOM, p.GEOM, 1),
                           1,
                           'unit=KM')
  FROM country_boundaries s, country_boundaries p
 WHERE SDO_RELATE(p.GEOM, s.GEOM, 'mask=TOUCH querytype=JOIN') = 'TRUE'
   AND p.cntry_name = 'Poland';
   
/

SELECT s.cntry_name
  FROM country_boundaries s
 WHERE SDO_GEOM.SDO_AREA(s.GEOM, 1) =
       (SELECT MAX(SDO_GEOM.SDO_AREA(b.GEOM, 1)) FROM country_boundaries b);
       
/

SELECT SDO_GEOM.SDO_MBR(SDO_GEOM.SDO_UNION(w.GEOM, l.GEOM, 1))
  FROM major_cities w, major_cities l
 WHERE w.city_name = 'Warsaw'
   AND l.city_name = 'Lodz';
/

-- length of the river in Poland
SELECT DISTINCT a.name,
                SUM(SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(a.GEOM,
                                                                  b.GEOM,
                                                                  10),
                                        10,
                                        'unit=KM'))
  FROM rivers a, country_boundaries b
 WHERE b.cntry_name = 'Poland'
   AND SDO_RELATE(b.GEOM, a.GEOM, 'mask=ANYINTERACT querytype=JOIN') =
       'TRUE'
 GROUP BY a.name;

