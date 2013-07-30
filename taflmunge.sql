-- test import TAFL data
drop table if exists lines;
drop table if exists tafl;
-- create a scratch table just for the input lines
create temporary table lines (line TEXT);
.import atl_tafl.txt lines
.remdupl lines
-- clean up spurious quotes in fields
UPDATE lines SET line=replace(line, '"', ' ');
-- now define main TAFL table
CREATE TABLE tafl (
  PK_ROWID     INTEGER PRIMARY KEY,
  TX           DOUBLE,
  FLAGRXONLY   TEXT,
  RX           DOUBLE,
  F            INTEGER,
  RECID        INTEGER,
  LOCATION     TEXT,
  IC           TEXT,
  LAT          TEXT,
  LONG         TEXT,
  ERP          DOUBLE,
  GANT         DOUBLE,
  AZIM         DOUBLE,
  SITE         INTEGER,
  HANT         INTEGER,
  PARC         TEXT,
  C            INTEGER,
  Z            TEXT,
  LINKID       TEXT,
  FLAGMULTI    TEXT,
  E            INTEGER,
  P            TEXT,
  DO           INTEGER,
  LICENCE      INTEGER,
  L            TEXT,
  COCODE       INTEGER,
  LICENSEE     TEXT,
  CLASSNA      TEXT,
  CALLSIGN     TEXT,
  NOMOB        INTEGER,
  BW1EMMIS     TEXT,
  BW2EMMIS     TEXT,
  CL2EMMIS     TEXT,
  DATE         DATE,
  TLPT         DOUBLE,
  TXP          DOUBLE,
  PWRUNIT      TEXT,
  PANT         INTEGER,
  ELEV         DOUBLE,
  ICN          INTEGER
);

INSERT INTO tafl(TX, FLAGRXONLY, RX, F, RECID, LOCATION, IC, LAT, LONG,
       ERP, GANT, AZIM, SITE, HANT, PARC, C, Z, LINKID,
       FLAGMULTI, E, P, DO, LICENCE, L, COCODE, LICENSEE,
       CLASSNA, CALLSIGN, NOMOB, BW1EMMIS, BW2EMMIS, CL2EMMIS,
       DATE, TLPT, TXP, PWRUNIT, PANT, ELEV, ICN) SELECT
-- Field: TX           Start:   1 Length:  12 Type: DOUBLE   (Numeric)
  cast(substr(LINE, 1, 12) as real)/1000.0,
-- Field: FLAGRXONLY   Start:  13 Length:   1 Type: TEXT     (Text)
  substr(LINE, 13, 1),
-- Field: RX           Start:  15 Length:  12 Type: DOUBLE   (Numeric)
  cast(substr(LINE, 15, 12) as real)/1000.0,
-- Field: F            Start:  29 Length:   1 Type: INTEGER  (Numeric)
  substr(LINE, 29, 1),
-- Field: RECID        Start:  31 Length:  11 Type: INTEGER  (Numeric)
  substr(LINE, 31, 11),
-- Field: LOCATION     Start:  43 Length:  35 Type: TEXT     (Text)
  substr(LINE, 43, 35),
-- Field: IC           Start:  79 Length:   2 Type: TEXT     (Text)
  substr(LINE, 79, 2),
-- Field: LAT          Start:  82 Length:   6 Type: DOUBLE   (Numeric)
  substr(LINE, 82, 6),
-- Field: LONG         Start:  89 Length:   7 Type: DOUBLE   (Numeric)
  substr(LINE, 89, 7),
-- Field: ERP          Start:  97 Length:   5 Type: DOUBLE   (Numeric)
  substr(LINE, 97, 5),
-- Field: GANT         Start: 103 Length:   5 Type: DOUBLE   (Numeric)
  substr(LINE, 103, 5),
-- Field: AZIM         Start: 109 Length:   6 Type: DOUBLE   (Numeric)
  substr(LINE, 109, 6),
-- Field: SITE         Start: 116 Length:   5 Type: INTEGER  (Numeric)
  substr(LINE, 116, 5),
-- Field: HANT         Start: 122 Length:   4 Type: INTEGER  (Numeric)
  substr(LINE, 122, 4),
-- Field: PARC         Start: 127 Length:   4 Type: TEXT     (Numeric)
  substr(LINE, 127, 4),
-- Field: C            Start: 132 Length:   1 Type: INTEGER  (Numeric)
  substr(LINE, 132, 1),
-- Field: Z            Start: 134 Length:   1 Type: TEXT     (Numeric)
  substr(LINE, 134, 1),
-- Field: LINKID       Start: 136 Length:   6 Type: TEXT     (Text)
  substr(LINE, 136, 6),
-- Field: FLAGMULTI    Start: 142 Length:   1 Type: TEXT     (Text)
  substr(LINE, 142, 1),
-- Field: E            Start: 144 Length:   1 Type: INTEGER  (Numeric)
  substr(LINE, 144, 1),
-- Field: P            Start: 146 Length:   1 Type: TEXT     (Text)
  substr(LINE, 146, 1),
-- Field: DO           Start: 148 Length:   2 Type: INTEGER  (Numeric)
  substr(LINE, 148, 2),
-- Field: LICENCE      Start: 150 Length:   7 Type: INTEGER  (Numeric)
  substr(LINE, 150, 7),
-- Field: L            Start: 159 Length:   1 Type: TEXT     (Text)
  substr(LINE, 159, 1),
-- Field: COCODE       Start: 162 Length:   9 Type: INTEGER  (Numeric)
  substr(LINE, 162, 9),
-- Field: LICENSEE     Start: 172 Length:  18 Type: TEXT     (Text)
  substr(LINE, 172, 18),
-- Field: CLASSNA      Start: 191 Length:   6 Type: TEXT     (Text)
  substr(LINE, 191, 6),
-- Field: CALLSIGN     Start: 204 Length:   6 Type: TEXT     (Text)
  substr(LINE, 204, 6),
-- Field: NOMOB        Start: 211 Length:   4 Type: INTEGER  (Numeric)
  substr(LINE, 211, 4),
-- Field: BW1EMMIS     Start: 216 Length:   9 Type: TEXT     (Text)
  substr(LINE, 216, 9),
-- Field: BW2EMMIS     Start: 226 Length:   4 Type: TEXT     (Text)
  substr(LINE, 226, 4),
-- Field: CL2EMMIS     Start: 230 Length:   5 Type: TEXT     (Text)
  substr(LINE, 230, 5),
-- Field: DATE         Start: 236 Length:   8 Type: DATE     (Numeric)
  substr(LINE, 236, 4)||'-'||substr(LINE, 240, 2)||'-'||substr(LINE, 242, 2),
-- Field: TLPT         Start: 246 Length:   5 Type: DOUBLE   (Numeric)
  substr(LINE, 246, 5),
-- Field: TXP          Start: 252 Length:   5 Type: DOUBLE   (Numeric)
  substr(LINE, 252, 5),
-- Field: PWRUNIT      Start: 257 Length:   3 Type: TEXT     (Text)
  substr(LINE, 257, 3),
-- Field: PANT         Start: 261 Length:   4 Type: INTEGER  (Numeric)
  substr(LINE, 261, 4),
-- Field: ELEV         Start: 266 Length:   4 Type: DOUBLE   (Numeric)
  substr(LINE, 266, 4),
-- Field: ICN          Start: 271 Length:   7 Type: INTEGER  (Numeric)
  substr(LINE, 271, 7)
from lines;
-- end TAFL table def

drop table lines;
vacuum;

-- clean out empty strings and set to null
begin;
UPDATE tafl SET FLAGRXONLY = NULL WHERE TRIM(FLAGRXONLY)='';
UPDATE tafl SET LOCATION = NULL WHERE TRIM(LOCATION)='';
UPDATE tafl SET LOCATION = TRIM(LOCATION);
UPDATE tafl SET IC = NULL WHERE TRIM(IC)='';
UPDATE tafl SET PARC = NULL WHERE TRIM(PARC)='';
UPDATE tafl SET Z = NULL WHERE TRIM(Z)='';
UPDATE tafl SET LINKID = NULL WHERE TRIM(LINKID)='';
UPDATE tafl SET FLAGMULTI = NULL WHERE TRIM(FLAGMULTI)='';
UPDATE tafl SET P = NULL WHERE TRIM(P)='';
UPDATE tafl SET L = NULL WHERE TRIM(L)='';
UPDATE tafl SET LICENSEE = NULL WHERE TRIM(LICENSEE)='';
UPDATE tafl SET CLASSNA = NULL WHERE TRIM(CLASSNA)='';
UPDATE tafl SET CALLSIGN = NULL WHERE TRIM(CALLSIGN)='';
UPDATE tafl SET BW1EMMIS = NULL WHERE TRIM(BW1EMMIS)='';
UPDATE tafl SET BW2EMMIS = NULL WHERE TRIM(BW2EMMIS)='';
UPDATE tafl SET CL2EMMIS = NULL WHERE TRIM(CL2EMMIS)='';
UPDATE tafl SET PWRUNIT = NULL WHERE TRIM(PWRUNIT)='';
UPDATE tafl SET DATE = NULL WHERE DATE='    -  -  ';
UPDATE tafl SET ICN = NULL WHERE TRIM(ICN)='';
UPDATE tafl set ERP = NULL where trim(ERP)='';
delete from tafl where trim(lat)='';
delete from tafl where trim(long)='';
commit;
-- these are not quite perfect yet FIXME CLEANUPS
-- but add geometry anyway
SELECT AddGeometryColumn('tafl','geom',4326,'POINT','XY');
UPDATE tafl SET geom = GeomFromText('POINT('||(0-(cast(substr(long,1,3) as real)+cast(substr(long,4,2) as real)/60+cast(substr(long,6,2) as real)/3600))||' '||(cast(substr(lat,1,2) as real)+cast(substr(lat,3,2) as real)/60+cast(substr(lat,5,2) as real)/3600)||')' ,4326);

-- now create links temporary table
CREATE TEMPORARY TABLE templinks AS
SELECT s.callsign||'-'||s.linkid AS NAME,
       s.PK_ROWID AS CALL_ROWID,
       e.PK_ROWID AS LINK_ROWID,
       s.licensee AS LICENSEE,
       s.location AS STARTLOC,
       e.location AS ENDLOC,
       s.rx AS RX,
       s.tx AS TX,
       x(s.geom) as STARTLONG,
       y(s.geom) as STARTLAT,
       x(e.geom) as ENDLONG,
       y(e.geom) as ENDLAT
FROM tafl AS s
LEFT OUTER JOIN tafl AS e ON s.linkid=e.callsign
WHERE s.callsign IS NOT NULL
  AND s.linkid IS NOT NULL
  AND s.callsign<>s.linkid
  AND s.TX>890
  AND s.TX>s.RX
  AND e.callsign IS NOT NULL
  AND e.linkid IS NOT NULL
  AND s.callsign=e.linkid
  AND s.L<>'R'
  AND e.L<>'R'
GROUP BY name, s.TX;

CREATE TABLE links(
  PK_ROWID INTEGER PRIMARY KEY,
  NAME TEXT,
  CALL_ROWID INT,
  LINK_ROWID INT,
  LICENSEE TEXT,
  STARTLOC TEXT,
  ENDLOC TEXT,
  RX REAL,
  TX REAL
);

SELECT AddGeometryColumn('links','geom',4326,'LINESTRING','XY');

INSERT INTO links (NAME, CALL_ROWID, LINK_ROWID, LICENSEE, 
       STARTLOC, ENDLOC, RX, TX, geom)
  SELECT NAME, CALL_ROWID, LINK_ROWID, LICENSEE, 
       STARTLOC, ENDLOC, RX, TX,
       GeomFromText('LINESTRING('||startlong||' '||startlat||','||endlong||' '||endlat||')',4326)
  FROM templinks;

drop table templinks;
select CreateSpatialIndex('tafl', 'geom');
select CreateSpatialIndex('links', 'geom');
vacuum;
