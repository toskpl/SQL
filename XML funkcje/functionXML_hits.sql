SELECT XMLElement("PROWADZACY",
                  XMLElement("P_IMIE", P_IMIE),
                  XMLElement("P_NAZWISKO", P_NAZWISKO)) AS XML
  FROM LP3_PROWADZACY;

/

select XMLElement("NaliterkeA",
                  XMLAttributes(u.u_id as utwor_id, w.w_id as wykonawca_id),
                  XMLElement("Nazwa", w.w_nazwa),
                  XMLElement("Utwor", u.u_tytul))
  from LP3_UTWORY u, LP3_WYKONAWCY w
 where u.u_w_id = w.w_id
   and w.w_nazwa like 'A%'
  -- and u.u_tytul like 'A%'
 order by w.w_nazwa
 
/

select XMLElement("Najlepszy",
                  XMLAttributes(w.w_id as wykonawca_id),
                  XMLElement("Nazwa", w.w_nazwa),
                  XMLElement("Ile_utworow", count(u.u_w_id)))
  from LP3_UTWORY u, LP3_WYKONAWCY w
 where u.u_w_id = w.w_id
 group by w.w_nazwa, w.w_id
having count(u.u_w_id) > 10

/

select XMLElement("Wykonawca",
                  XMLAttributes(w.w_id as wykonawca_id),
                  XMLElement("Nazwa", w.w_nazwa),                  
                  XMLAgg(XMLElement("UTWOR", u.u_tytul)))
  from LP3_UTWORY u, LP3_WYKONAWCY w
 where u.u_w_id = w.w_id
   and w.w_nazwa = 'TSA'
 GROUP BY w.w_nazwa, w.w_id;
 
/

select XMLElement("Notowanie",
                  XMLAttributes(n.n_data as "Data", n.n_nr as "Nr"),
                  XMLElement("Prowadzacy", p.p_nazwisko || ' ' || p.p_imie), 
                  XMLAgg(XMLElement("Utwor",
                                    XMLAttributes(m.m_lp as "Lp"),
                                    u.u_tytul)))
  from LP3_UTWORY     u,
       LP3_PROWADZACY p,
       LP3_NOTOWANIA  n,
       LP3_MIEJSCA    m,
       LP3_WYKONAWCY  w
 where n.n_nr = '1'
   and p.p_id = 1
   and n.n_p_id = p.p_id
   and m.m_n_id = n.n_nr
   and m.m_w_id = w.w_id
   and u.u_w_id = w.w_id
   and m.m_u_id = u.u_id
 group by n.n_data, n.n_nr, p.p_imie, p.p_nazwisko;

/


select XMLElement("Notowanie",
                  XMLElement("Nr", n.n_nr),
                  XMLElement("Data", n.n_data),
                  XMLElement("Prowadzacy",
                             XMLForest(p.p_nazwisko AS "Nazwisko",
                                       p.p_imie AS "Imie")),
                  XMLElement("Miejsca",
                             XMLAgg(XMLElement("Miejsce",
                                               XMLForest(m.m_lp AS "Lp",
                                                         w.w_nazwa as
                                                         "Wykonawca",
                                                         u.u_tytul as "Tytul"))
                                    order by m.m_lp)))
  from LP3_UTWORY     u,
       LP3_PROWADZACY p,
       LP3_NOTOWANIA  n,
       LP3_MIEJSCA    m,
       LP3_WYKONAWCY  w
 where n.n_nr = '1'
   and p.p_id = 1
   and n.n_p_id = p.p_id
   and m.m_n_id = n.n_nr
   and m.m_w_id = w.w_id
   and u.u_w_id = w.w_id
   and m.m_u_id = u.u_id
 group by n.n_data, n.n_nr, p.p_imie, p.p_nazwisko
