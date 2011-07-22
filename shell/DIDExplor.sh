#!/bin/sh

cd /bgc/data/psych/dae
list=`ls -rt` # /bgc/data/psych/dae`

for f in $list
do
    c=`grep -c or=90 $f`
    if [ "$c" -gt "0" ]; then
	echo "file is $f and it has $c"
    fi
done

cd -