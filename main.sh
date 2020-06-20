#!/bin/bash

# Show column names (-n, --names)
csvcut --names VoterRegOpenData.csv
#   1: VUIDNO
#   2: VRCNUM
#   3: PCTCOD
#   4: EDRDAT
#   5: GENDER

# Check for errors
csvclean VoterRegOpenData.csv --dry-run

# Format CSV output
csvcut -c FSTNAM,MIDNAM,LSTNAM VoterRegOpenData.csv | csvlook
# | FSTNAM   | MIDNAM    | LSTNAM      |
# | -------- | --------- | ----------- |
# | JENNIFER | KAYE      | ASTON       |
# | ELAINE   | FAYE      | FORTENBERRY |
# | KEVIN    | LOY       | ASTON       |
# | JESSICA  | ELIZABETH | SCALES      |

# Select columns (-c, --columns). Use column index or name
csvcut -c 2-3,EDRDAT VoterRegOpenData.csv
# |    VRCNUM | PCTCOD |     EDRDAT |
# | --------- | ------ | ---------- |
# | 1,228,304 |    308 | 2019-05-10 |
# | 1,303,514 |    203 | 2020-03-27 |
# | 1,228,303 |    308 | 2019-05-10 |
# |   937,649 |    414 | 2016-04-30 |

# Select other columns (-C, --not-columns)
csvcut -C 1,5-55 VoterRegOpenData.csv
# |    VRCNUM | PCTCOD |     EDRDAT |
# | --------- | ------ | ---------- |
# | 1,228,304 |    308 | 2019-05-10 |
# | 1,303,514 |    203 | 2020-03-27 |
# | 1,228,303 |    308 | 2019-05-10 |
# |   937,649 |    414 | 2016-04-30 |

# Show statistics
csvcut -c RZIPCD VoterRegOpenData.csv | csvstat
#   1. "RZIPCD"

# 	Type of data:          Number
# 	Contains null values:  False
# 	Unique values:         63
# 	Smallest value:        76,574
# 	Largest value:         78,759
# 	Sum:                   10,492,044,730
# 	Mean:                  78,721.234
# 	Median:                78,735
# 	StDev:                 39.256
# 	Most common values:    78,660 (10565x)
# 	                       78,745 (7319x)
# 	                       78,748 (6870x)
# 	                       78,704 (5722x)
# 	                       78,749 (5126x)
# Row count: 133281

# Search for matches (-m match)
csvgrep -c GENDER -e latin-1 --match M VoterRegOpenData.csv | csvcut -c GENDER,FSTNAM,MIDNAM,LSTNAM
# | GENDER | FSTNAM  | MIDNAM  | LSTNAM   |
# | ------ | ------- | ------- | -------- |
# | M      | KEVIN   | LOY     | ASTON    |
# | M      | JEREMY  | RICHARD | HOLLAWAY |
# | M      | CHARLES | KIRKHAM | FREEMAN  |
# | M      | RODNEY  | CLARK   | FRALIN   |

# Search with regular expression (-r, --regex)
csvgrep -c GENDER -e latin-1 --regex "(?i)m" VoterRegOpenData.csv | csvcut -c GENDER,FSTNAM,MIDNAM,LSTNAM | head
# | GENDER | FSTNAM  | MIDNAM  | LSTNAM   |
# | ------ | ------- | ------- | -------- |
# | M      | KEVIN   | LOY     | ASTON    |
# | M      | JEREMY  | RICHARD | HOLLAWAY |
# | M      | CHARLES | KIRKHAM | FREEMAN  |
# | M      | RODNEY  | CLARK   | FRALIN   |

# Invert matches (-i, --invert-match)
csvgrep -c GENDER -e latin-1 --invert-match --match F VoterRegOpenData.csv | csvcut -c GENDER,FSTNAM,MIDNAM,LSTNAM
# | GENDER | FSTNAM  | MIDNAM  | LSTNAM   |
# | ------ | ------- | ------- | -------- |
# | M      | KEVIN   | LOY     | ASTON    |
# | M      | JEREMY  | RICHARD | HOLLAWAY |
# | M      | CHARLES | KIRKHAM | FREEMAN  |
# | M      | RODNEY  | CLARK   | FRALIN   |

# Sort
csvsort -c LSTNAM,FSTNAM -e latin-1 VoterRegOpenData.csv | csvcut -c FSTNAM,MIDNAM,LSTNAM
# | FSTNAM   | MIDNAM  | LSTNAM  |
# | -------- | ------- | ------- |
# | ASHLEY   | NICOLE  | AARONS  |
# | CELESTIN | RYAN    | ADAM    |
# | SANDRA   | BRANNAN | ADCOCK  |
# | MICAELA  | CAMACHO | AGUILAR |

# SQL. Uses an in-memory database, so it can be very slow.
csvsql -e latin-1 --query "SELECT COUNT(*) FROM VoterRegOpenData" VoterRegOpenData.csv
# COUNT(*)
# 1000

head -n 101 VoterRegOpenData.csv | csvsql --query "SELECT COUNT(*) FROM stdin"
# COUNT(*)
# 100

# Convert CSV to JSON
csvjson VoterRegOpenData.csv > VoterRegOpenData.json
