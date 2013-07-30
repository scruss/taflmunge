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
  "SpatiaLite") - tested with version 3.1.0-RC2 (based on SQLite
  version 3.7.15.2) on Ubuntu x86_64.

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

will eliminate duplicates, merge and rename in one step.

This script/process has only been tested on the command-line version
of SpatiaLite, and can be run as:

    echo '.read taflmunge.sql CP1252' | spatialite tafl.sqlite
	
After a short while and some very confusing output, this creates a
database file with two tables: "tafl" (point geometry) and "links" (for
clearly identifiable microwave links; linestring geometry). Other
fields are as
[description](http://spectrum.ic.gc.ca/tafl/tafl/tafl.txt), except
with:

* LAT/LONG are kept as [D]DDMMSS text. We have real geometry fields,
  so why retain redundant float fields?
* RX-only and Multiple Links flags have been retained as new fields
  FLAGRXONLY (= 1 if receive-only) and FLAGMULTI ('*' if part of a
  multi-station link path).
* (TX field should probably be nulled if FLAGRXONLY is set.)
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

* The frequency conversion looks a few orders of magnitude off.
* Emits lots of cryptic output while running. I mean, what's with all
  the '1's?

To Do
-----

* Null some more empty fields.
* Make this useful under the SpatiaLite GUI.

Author
------

Stewart C. Russell - http://scruss.com/blog/

Original Perl Data parsing method strongly influenced by [dave0/Parse-SpectrumDirect-RadioFrequency](https://github.com/dave0/Parse-SpectrumDirect-RadioFrequency "dave0/Parse-SpectrumDirect-RadioFrequency").

Licence
-------

WTFPL. (Srsly; see COPYING.)
