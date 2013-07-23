taflmunge
=========

Simple code to parse and translate Canada's
[Technical and Administrative Frequency Lists](http://www.ic.gc.ca/eic/site/tafl-ltaf.nsf/eng/home
"Technical and Administrative Frequency Lists") (TAFL) for Radio
Communications. These data also available as Open Data from
[data.gc.ca](http://data.gc.ca/ "data.gc.ca"). 

Requirements
------------

* Perl (any 5.x version from the last decade will likely do)
* [Text::CSV_XS](http://search.cpan.org/perldoc?Text%3A%3ACSV_XS "Text::CSV_XS")

Usage
-----

    taflmunge.pl taflds-new.txt your_tafl_file > output.txt
	
Spits out a clean tab-delimited text file to stdout. Fields are as
[description](http://spectrum.ic.gc.ca/tafl/tafl/tafl.txt), except
with:

* LAT/LONG are converted from [D]DDMMSS text to decimal degrees.
* RX-only and Multiple Links flags have been retained as new fields
  FLAGRXONLY (= 1 if receive-only) and FLAGMULTI ('*' if part of a
  multi-station link path).
* "Class of Emission (2)" has been retained as CL2EMMIS (it was
  stripped out by the offical DOS-only DBF converter).
* Text fields have had blanks stripped, spacing normalized, and quote
  characters removed, as clearly some imports to the database had come
  straight from Excel.

Author
------

Stewart C. Russell - http://scruss.com/blog/

Licence
-------

WTFPL.
