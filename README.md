(so this totally doesn't work any more. TAFL is no longer available, and any open data set of radio transmitters on Canada Open Data is much reduced.)

taflmunge
=========

Simple SpatiaLite SQL code to parse and translate Canada's
[Technical and Administrative Frequency Lists](http://www.ic.gc.ca/eic/site/tafl-ltaf.nsf/eng/home
"Technical and Administrative Frequency Lists") (TAFL) for Radio
Communications. These data also available as Open Data from
[data.gc.ca](http://data.gc.ca/ "data.gc.ca"). 

Requirements
------------

* [SpatiaLite](http://www.gaia-gis.it/gaia-sins/index.html
  "SpatiaLite") - tested with version 3.1.0-RC2 and 4.1.0 on Ubuntu x86_64.

Usage
-----

Get one or more (large, be warned) TAFL text files from:
* [Atlantic Region](http://spectrum.ic.gc.ca/pub/gcopendata/ltaf_atl_tafl.txt)
* [Central Region](http://spectrum.ic.gc.ca/pub/gcopendata/ltaf_cen_tafl.txt)
* [Ontario](http://spectrum.ic.gc.ca/pub/gcopendata/ltaf_ont_tafl.txt)
* [Pacific Region](http://spectrum.ic.gc.ca/pub/gcopendata/ltaf_pac_tafl.txt)
* [Quebec](http://spectrum.ic.gc.ca/pub/gcopendata/ltaf_que_tafl.txt)

These are open data, and can be used under the
[data.gc.ca](http://data.gc.ca/ "data.gc.ca") licence.

Merge them into one file called "tafl.txt". If you're using
Unix/Linux,

    sort -u ltaf*txt > tafl.txt

will eliminate duplicates, merge and rename in one step. Note that the
SQL script will attempt to remove duplicates, too.

This script/process has only been tested on the command-line version
of SpatiaLite, and can be run as:

    echo '.read taflmunge.sql CP1252' | spatialite tafl.sqlite
	
After a short while (and some *very* confusing output), this creates a
database file with two tables: "tafl" (point geometry) and "links" (for
clearly identifiable microwave links; linestring geometry). Other
fields are as
[description](http://spectrum.ic.gc.ca/tafl/tafl/tafl.txt), except
with:

* LAT/LONG are kept as [D]DDMMSS text. We have real geometry fields,
  so why retain redundant float fields?
* RECID is a number stored as a string to get around OGR's integer limits.
* Added RADIUSKM for mobile sites (classna like 'M%')
* RX-only and Multiple Links flags have been retained as new fields
  FLAGRXONLY (= 1 if receive-only) and FLAGMULTI ('*' if part of a
  multi-station link path).
* DATE is reformatted as an ISO-standard YYYY-MM-DD format.
* "Class of Emission (2)" has been retained as CL2EMMIS (it was
  stripped out by the offical DOS-only DBF converter).
* Transmission power units (for those rated in watts) is stored in PWRUNIT.
* Text fields have had quote characters removed, as clearly some
  imports to the database had come straight from Excel. 

Each table has unique ID fields. The database should work with
anything that can talk to SpatiaLite. It was tested with Quantum GIS
1.8 under Linux and Windows 7.

Bugs
----

* Still may include duplicate rows; seems that there's some
  relationship between RECID, L and F that I haven't fully worked out.
* Emits lots of cryptic output while running. I mean, what's with all
  the '1's?

To Do
-----

* Null some more empty fields.
* Make this useful under the SpatiaLite GUI.

Author
------

Stewart C. Russell - http://scruss.com/blog/

Original Perl Data parsing method strongly influenced by
[dave0/Parse-SpectrumDirect-RadioFrequency](https://github.com/dave0/Parse-SpectrumDirect-RadioFrequency
"dave0/Parse-SpectrumDirect-RadioFrequency"). The code in the “perl/”
folder merely extracts tab-separated values from the columns, and
doesn't take all the data columns (such as mobile radius) into account.

Licence
-------

WTFPL. (Srsly; see COPYING.)
