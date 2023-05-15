/*==============================================================*/
/* Nom de SGBD :  ORACLE Version 11g                            */
/* Date de création :  15/05/2023 17:47:32                      */
/*==============================================================*/


drop table EVENEMENT cascade constraints;

drop table PARTICIPANT cascade constraints;

drop table RESERVATION cascade constraints;

drop table SITE cascade constraints;

drop table TERRITOIRE cascade constraints;

drop table THEME cascade constraints;

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
   tpPers               CHAR(1)             
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
   libThme              VARCHAR2(50),
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
   nomSite              VARCHAR2(50),
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
   nbPlaces             INTEGER             
      constraint CKC_NBPLACES_EVENEMEN check (nbPlaces is null or (nbPlaces >= 21)),
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



