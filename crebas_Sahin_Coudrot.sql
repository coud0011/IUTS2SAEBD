/*==============================================================*/
/* Nom de SGBD :  ORACLE Version 11g                            */
/* Date de crï¿½ation :  15/05/2023 17:47:32                      */
/*==============================================================*/


drop table EVENEMENT cascade constraints;

drop table PARTICIPANT cascade constraints;

drop table RESERVATION cascade constraints;

drop table SITE cascade constraints;

drop table TERRITOIRE cascade constraints;

drop table THEME cascade constraints;

drop table ACTIVITE cascade constraints;

drop table PROGRAMME cascade constraints;

/*==============================================================*/
/* Table : PARTICIPANT                                          */
/*==============================================================*/
create table PARTICIPANT 
(
   cdPers               INTEGER              not null,
   nomPers              VARCHAR2(50),
   prenomPers           VARCHAR2(50),
   adrPers              VARCHAR2(50),
   cpPers               CHAR(5),
   villePers            VARCHAR2(50),
   telPers              CHAR(10),
   tpPers               CHAR(1),
   dateNais             DATE,       
      constraint CKC_TPPERS_PARTICIP check (tpPers is null or (tpPers in ('P','C','E'))),
   constraint PK_PARTICIPANT primary key (cdPers)
);


/*==============================================================*/
/* Table : TERRITOIRE                                           */
/*==============================================================*/
create table TERRITOIRE 
(
   cdTerr               INTEGER              not null,
   nomTerr              VARCHAR2(50),
   constraint PK_TERRITOIRE primary key (cdTerr)
);


/*==============================================================*/
/* Table : THEME                                                */
/*==============================================================*/
create table THEME 
(
   cdTheme              INTEGER              not null,
   libTheme              VARCHAR2(50),
   constraint PK_THEME primary key (cdTheme)
);


/*==============================================================*/
/* Table : SITE                                                 */
/*==============================================================*/
create table SITE 
(
   cdSite               INTEGER              not null,
   cdTheme              INTEGER                                   constraint FK_SITE_REGROUPER_THEME REFERENCES THEME (cdTheme),
   cdTerr               INTEGER                                   constraint FK_SITE_LOCALISER_TERRITOI REFERENCES TERRITOIRE (cdTerr),
   nomSite              VARCHAR2(60),
   tpSite               VARCHAR2(50),
   adrSite              VARCHAR2(50),
   cpSite               CHAR(5),
   villeSite            VARCHAR2(50),
   emailSite            VARCHAR2(100),
   telSite              CHAR(10),
   siteWeb              VARCHAR2(50),
   constraint PK_SITE primary key (cdSite)
);


/*==============================================================*/
/* Table : EVENEMENT                                            */
/*==============================================================*/
create table EVENEMENT 
(
   cdSite               INTEGER              not null             constraint FK_EVENEMEN_LI_EVENT_SITE REFERENCES SITE (cdSite),
   numEv                INTEGER              not null,
   dateDebEv            DATE,
   dateFinEv            DATE,
   nbPlaces             INTEGER                                    constraint CKC_NBPLACES_EVENEMEN check (nbPlaces is null or (nbPlaces >= 21)),
   dureeEv              GENERATED ALWAYS AS (dateFinEv-dateDebEv) VIRTUAL,          
   tarif                NUMBER(6,2),
      constraint CKC_DATE_FIN_EVENEMEN check (dateFinEv is null or (dateFinEv >= dateDebEv)),
   constraint PK_EVENEMENT primary key (cdSite, numEv)
);


/*==============================================================*/
/* Table : RESERVATION                                          */
/*==============================================================*/
create table RESERVATION 
(
   cdPers               INTEGER              not null             constraint FK_RESERVAT_LI_RESERV_PARTICIP REFERENCES PARTICIPANT (cdPers),
   cdSite               INTEGER              not null,
   numEv                INTEGER              not null,
   dateResa             DATE                 not null,
   nbPlResa             INTEGER              not null,
   modeReglt            INTEGER             
      constraint CKC_MODEREGLT_RESERVAT check (modeReglt is null or (modeReglt between 1 and 3)),
   constraint FK_RESERVAT_LI_RESERV_EVENEMEN FOREIGN KEY (cdSite,numEv)
      REFERENCES EVENEMENT (cdSite,numEv),
   constraint PK_RESERVATION primary key (cdSite, cdPers, numEv, dateResa)
);

/*==============================================================*/
/* Table : ACTIVITE                                             */
/*==============================================================*/
CREATE TABLE ACTIVITE AS
(
   SELECT cdAct, libAct AS nomAct
   FROM TESTSAELD.ACTIVITE      
);

ALTER TABLE ACTIVITE ADD
(
    CONSTRAINT PK_ACTIVITE PRIMARY KEY (cdAct)
);

/*==============================================================*/
/* Table : PROGRAMME                                            */
/*==============================================================*/
CREATE TABLE PROGRAMME 
(
   cdAct                CHAR(1 BYTE)         not null   CONSTRAINT FK_PROGRAMME_ACTIVITE REFERENCES ACTIVITE(cdAct) ON DELETE CASCADE,
   cdSite               INTEGER              not null   CONSTRAINT FK_PROGRAMME_SITE REFERENCES SITE(cdSite) ON DELETE CASCADE,
   tpPublic             VARCHAR2(4)          not null            
      CONSTRAINT CKC_PROGRAMME_TPPUBLIC CHECK (tpPublic IN ('TOUS','+18','+10','+5')),   
   CONSTRAINT PK_PROGRAMME PRIMARY KEY (cdAct, cdSite)
);

CREATE INDEX FK_SITE_REGROUPER_THEME         ON SITE        (cdTheme);
CREATE INDEX FK_SITE_LOCALISER_TERRITOI      ON SITE        (cdTerr);
CREATE INDEX FK_EVENEMEN_LI_EVENT_SITE       ON EVENEMENT   (numEv);
CREATE INDEX FK_RESERVAT_LI_RESERV_PARTICIP  ON RESERVATION (cdPers);
CREATE INDEX FK_RESERVAT_LI_RESERV_EVENEMEN  ON RESERVATION (cdSite,numEv);
CREATE INDEX IX_NOMSITE                      ON SITE        (nomSite);
CREATE INDEX IX_NOMPERS                      ON PARTICIPANT (nomPers);
CREATE INDEX IX_PRENOMPERS                   ON PARTICIPANT (prenomPers);
CREATE INDEX IX_NOMACTIVITE                  ON ACTIVITE    (nomAct);

/*==============================================================*/
/* INSERTION : THEME                                            */
/*==============================================================*/
INSERT INTO THEME (cdTheme,libTheme) VALUES (1,'Animaux');
INSERT INTO THEME (cdTheme,libTheme) VALUES (2,'Sport');
INSERT INTO THEME (cdTheme,libTheme) VALUES (3,'Bateaux');
INSERT INTO THEME (cdTheme,libTheme) VALUES (4,'Ferme pédagogique');
INSERT INTO THEME (cdTheme,libTheme) VALUES (5,'Parcs et jardins');
INSERT INTO THEME (cdTheme,libTheme) VALUES (6,'Jeux pour enfants');
INSERT INTO THEME (cdTheme,libTheme) VALUES (7,'Patrimoine');
INSERT INTO THEME (cdTheme,libTheme) VALUES (8,'Parcours Sportifs');
INSERT INTO THEME (cdTheme,libTheme) VALUES (9,'Golf');
INSERT INTO THEME (cdTheme,libTheme) VALUES (10,'Sports nautiques');
INSERT INTO THEME (cdTheme,libTheme) VALUES (11,'Parc d`attraction');

/*==============================================================*/
/* INSERTION : TERRITOIRE                                       */
/*==============================================================*/

INSERT INTO TERRITOIRE (cdTerr,nomTerr) VALUES (1,'Autour du Louvres - Lens');
INSERT INTO TERRITOIRE (cdTerr,nomTerr) VALUES (2,'Vallées et Marais');
INSERT INTO TERRITOIRE (cdTerr,nomTerr) VALUES (3,'Côte d`opale');

/*==============================================================*/
/* INSERTION : PARTICIPANT                                      */
/*==============================================================*/
DROP SEQUENCE CODE_PERS;
CREATE SEQUENCE CODE_PERS
START WITH 1
INCREMENT BY 1;

INSERT INTO PARTICIPANT (SELECT CODE_PERS.NEXTVAL, nomPers, prenomPers, adrPers, cpPers, villePers, REPLACE(telPers, '.', ''), tpPers, dateNais FROM TESTS1.EMPRUNTEUR);
INSERT INTO PARTICIPANT (SELECT CODE_PERS.NEXTVAL, nom, prnm, adr, cp, localite, NULL, 'P', datNs FROM TESTS1.CLIENT);

/*==============================================================*/
/* INSERTION : SITE                                             */
/*==============================================================*/
INSERT INTO SITE (cdSite, nomSite, tpSite, adrSite, cpSite, villeSite, emailSite, telSite, siteWeb) SELECT cdSite, nomSite, tpSite, adrSite, cpSite, villeSite, emailSite, REPLACE(telSite, ' ', ''), siteWeb FROM TESTSAELD.SITE;
UPDATE SITE s
SET s.cdTheme= (SELECT t.cdTheme
                FROM testSaeld.Site t
                WHERE t.cdSite=s.cdSite
                    AND t.cdTheme in (SELECT cdTheme FROM THEME)),
    s.cdTerr = (SELECT t.cdTerr
                FROM testSaeld.Site t
                WHERE t.cdSite=s.cdSite
                    AND t.cdTerr in (SELECT cdTerr FROM TERRITOIRE));
SELECT t.cdTheme
                FROM testSaeld.Site t
                WHERE t.cdSite=2;
SELECT cdSite
FROM SITE
WHERE cdSite NOT IN (SELECT cdSite FROM testSaeld.Site);
/*==============================================================*/
/* INSERTION : EVENEMENT                                        */
/*==============================================================*/
INSERT INTO EVENEMENT (cdSite, numEv, dateDebEv, dateFinEv, nbPlaces, tarif) SELECT cdSite, numEv, dateDebEv, dateFinEv, nbPlaces, tarif FROM TESTSAELD.EVENEMENT WHERE (nbPlaces>20 OR nbPlaces IS NULL);

/*==============================================================*/
/* INSERTION : RESERVATION                                      */
/*==============================================================*/
INSERT INTO RESERVATION (SELECT cdPers, cdSite, numEv, dateInscr, nbPlResa, modeReglt FROM TESTSAELD.INSCRIPTION WHERE cdSite||numEv IN (SELECT cdSite||numEv FROM TESTSAELD.EVENEMENT WHERE (nbPlaces>20 OR nbPlaces IS NULL)));