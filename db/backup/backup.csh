#! /bin/csh -f

set dumpprefix = "rdcc_prod_"
set uniq = `date +%Y%m%d`
set dumpfile = "$dumpprefix$uniq.sqlite3.bak"

openssl des3 -salt -k d4t4b4s3syst3m -in ../production.sqlite3 -out $dumpfile

uuencode $dumpfile $dumpfile | mailx -s "[rdcc] production db backup" streamlineux@gmail.com

