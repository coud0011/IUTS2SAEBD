/* 4a) */

/* 1) */
SELECT nomPers||'-'||prenomPers AS "Nom-Premon"
FROM Participant p
INNER JOIN Reservation R ON p.cdPers=r.cdPers
INNER JOIN Evenement e ON r.cdSite=e.cdSite AND r.numEv=e.numEv
INNER JOIN Site s ON e.cdsite=s.cdSite
WHERE UPPER(nomSite) LIKE '%PARC%';

/*
SELECT nomPers||'-'||prenomPers AS "Nom-Premon"
FROM Participant p
WHERE p.cdPers IN (SELECT r.cdPers
                   FROM Reservation r
                   WHERE r.numEv IN (SELECT e.numEv
                                   FROM Evenement e)
                   AND r.cdSite IN (SELECT e.cdSite
                                      FROM Evenement e
                                      WHERE e.cdSite IN (SELECT s.cdSite
                                                         FROM Site s
                                                         WHERE UPPER(nomSite) LIKE '%PARC%')));
*/

SELECT nomPers||'-'||prenomPers AS "Nom-Premon"
FROM Participant p, Reservation r, Evenement e, Site s
WHERE p.cdPers=r.cdPers
AND r.cdSite=e.cdSite
AND r.numEv=e.numEv
AND e.cdSite=s.cdSite
AND UPPER(nomSite) LIKE '%PARC%';

/* 2) */
SELECT nomSite,
       DECODE (tpSite, 'PCU', 'Patrimoine Culturel', 'PNA', 'Patrimoine Naturel') AS typesite,
       NVL(nomEv, '---') AS nomev,
       nbPlaces,
       tarif
FROM Site s
LEFT JOIN Evenement e ON s.cdSite=e.cdSite
WHERE UPPER(tpSite) IN ('PCU', 'PNA')
ORDER BY tpSite, nomEv;

/* 3) */
SELECT COUNT(s.cdTerr) AS nbSite,
       nomTerr
FROM Site s
INNER JOIN Territoire t ON s.cdTerr=t.cdTerr
WHERE UPPER(tpSite)='ASC'
GROUP BY nomTerr;

/* 4) */
SELECT nomSite, nomTerr
FROM Territoire t
LEFT JOIN Site s ON t.cdTerr=s.cdTerr
WHERE cdTheme IN (SELECT th.cdTheme
                  FROM Theme th
                  WHERE UPPER(libTheme)='PARCS ET JARDINS')
ORDER BY 2,1;

/* 5) */
SELECT nomAct
FROM Activite a
WHERE cdAct NOT IN (SELECT p.cdAct
                    FROM Programme p);
                    
SELECT nomAct
FROM Activite a
WHERE NOT EXISTS (SELECT NULL
                  FROM Programme p
                  WHERE a.cdAct=p.cdAct);
                  
SELECT nomAct
FROM Activite a
LEFT JOIN Programme p ON a.cdAct=p.cdAct
WHERE p.cdAct IS NULL;

SELECT nomAct
FROM Activite
MINUS
SELECT nomAct
FROM Activite a, Programme p
WHERE a.cdAct=p.cdAct;

/* 6 */
SELECT nomPers||'-'||prenomPers AS personne,
       tpPers
FROM Participant
WHERE tpPers='E'
AND EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM dateNais)>25;

UPDATE Participant
SET tpPers='P'
WHERE tpPers='E'
AND EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM dateNais)>25;

/* 7) */
SELECT nomEv
FROM Evenement
WHERE cdSite NOT IN (SELECT r.cdSite
                     FROM Reservation r)
AND numEv NOT IN (SELECT r.numEv
                  FROM Reservation r)
AND nbPlaces IS NOT NULL
AND TO_CHAR(dateDebEv, 'DD-MM-YYYY')<TO_DATE('20-06-2023', 'DD-MM-YYYY')
AND cdSite IN (SELECT s.cdSite
               FROM Site s
               WHERE UPPER(villeSite)='AVION');

DELETE FROM EVENEMENT
WHERE cdSite NOT IN (SELECT r.cdSite
                     FROM Reservation r)
AND numEv NOT IN (SELECT r.numEv
                  FROM Reservation r)
AND nbPlaces IS NOT NULL
AND TO_CHAR(dateDebEv, 'DD-MM-YYYY')<TO_DATE('20-06-2023', 'DD-MM-YYYY')
AND cdSite IN (SELECT s.cdSite
               FROM Site s
               WHERE UPPER(villeSite)='AVION');

/* 8) */
INSERT INTO RESERVATION (cdPers, cdSite, numEv, dateResa, nbPlResa, modeReglt)
    (SELECT 10, cdSite, numEv, SYSDATE, 15, 1
    FROM Evenement
    WHERE cdSite=(SELECt s.cdSite
                  FROM Site s
                  WHERE UPPER(nomSite)='BASE DE LOISIRS')
    AND numEv=(SELECT e.numEv
               FROM Evenement e
               WHERE UPPER(nomEv)='CONCOURS DE PÉTANQUE'));

/* b) */         
/* 9) */
SELECT nom, COUNT(cdMemb)
FROM Membre
WHERE cdMemb IN (SELECT p.cdMemb
                 FROM Participation p)
GROUP BY nom;

/* 10) */
SELECT libTheme, nomSite, dateDebEv, COUNT(p.cdPers) AS nbParticipant
FROM Participant p
INNER JOIN Reservation R ON p.cdPers=r.cdPers
INNER JOIN Evenement e ON r.cdSite=e.cdSite AND r.numEv=e.numEv
INNER JOIN Site s ON e.cdSite=s.cdSite
INNER JOIN Theme t ON s.cdTheme=t.cdTheme
WHERE dateDebEv BETWEEN '01/05/2023' AND '30/06/2023'
GROUP BY libTheme, nomSite, dateDebEv;

/* 11) */
SELECT libTheme, nomSite, COUNT(p.cdPers) AS nbParticipant
FROM Participant p
INNER JOIN Reservation R ON p.cdPers=r.cdPers
INNER JOIN Evenement e ON r.cdSite=e.cdSite AND r.numEv=e.numEv
INNER JOIN Site s ON e.cdSite=s.cdSite
INNER JOIN Theme t ON s.cdTheme=t.cdTheme
GROUP BY libTheme, nomSite
HAVING COUNT(p.cdPers)>1;

/* 12) */
SELECT cdTpStage, COUNT(*) AS nbStage
FROM Stage
GROUP BY cdTpStage
HAVING COUNT(*)=(SELECT MAX(COUNT(*))
                 FROM Stage
                 GROUP BY cdTpStage);

/* 13) */
SELECT nomPers, telpers
FROM Participant p
LEFt JOIN Reservation r ON p.cdPers=r.cdPers
MINUS
SELECT nomPers, telpers
FROM Participant
WHERE telPers IS NULL;

/* 14) */
SELECT nom||'-'||prnm AS "Nom-Prenom"
FROM Membre m
INNER JOIN Inscription i ON m.cdMemb=i.cdMemb
GROUP BY nom||'-'||prnm
HAVING COUNT(DISTINCT cdStage)=(SELECT COUNT(s.cdStage)
                                FROM Stage s);

/* c) */
GRANT SELECT ON SITE TO SAHI0015;
GRANT UPDATE ON SITE TO SAHI0015;
GRANT DELETE ON SITE TO SAHI0015;

GRANT UPDATE (nbPlResa, dateResa, modeReglt), DELETE ON RESERVATION TO SAHI0015;

GRANT INSERT (cdSite, numEv, nomEv, dateDebEv) ON EVENEMENT TO SAHI0015;
GRANT UPDATE (cdSite, numEv, nomEv, dateDebEv) ON EVENEMENT TO SAHI0015;

UPDATE COUD0011.Evenement
SET dateDebEv=TO_DATE('15/05/2023', 'DD/MM/YYYY')
WHERE UPPER(nomEv)='CONCOURS DE PÉTANQUE'
AND cdSite IN (SELECT cdSite
                FROM COUD0011.Site
                WHERE UPPER(nomSite)='BASE DE LOISIRS');
                
DELETE FROM COUD0011.RESERVATION r
WHERE numEv IN (SELECT numEv
                FROM COUD0011.EVENEMENT
                WHERE dateResa>dateDebEv)
AND cdSite IN (SELECT cdSite
                FROM COUD0011.EVENEMENT);