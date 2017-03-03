#!/bin/bash
#used to clean the log files
#Current version : 1.1
cd /var/log/ ; cat /dev/null | tee * > /dev/null 2>1&
find /var/log/ -type f > /tmp/test
output=/tmp/test
tes=/tmp/test1
for d in `cat $output`
do 
cat /dev/null > $d
done
echo "all the files are nulled in /var/log/ directory"
year=`date |awk '{print $6}'`
egrep -i '$year|old|bak' $output >> /tmp/test1
rm -rf *$year*
for i in `cat $tes`
do
rm -rf $i
done
echo "Removed all the old log files"
rm -rf $output
