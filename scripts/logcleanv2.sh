#!/bin/bash
#used to clean the log files
#Current version : 1.2
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
ls /var/log |grep -i xorg* |egrep -iv 'xorg.0|xorg.log' >>/tmp/test1
rm -rf *$year*
for i in `cat $tes`
do
rm -rf $i
done
echo "Removed all the old log files"
rm -rf $output
echo "checking for Images,Audio and Video files"
find /home -type f \( -iname "*.mp3" -o -iname "*.mp4" -o -iname "*.m4a" -o -iname "*.rm" -o -iname "*.ogg" -o -iname "*.aac"  \)  >> /tmp/audio
find /home -type f \( -iname "*.wmv" -o -iname "*.mov" -o -iname "*.avi" -o -iname "*.ogv" \)  >> /tmp/video   
find /home -type f \( -iname "*.jpg" \) >> /tmp/image

echo "Audio files" >>/tmp/avi
cat /tmp/audio >> /tmp/avi
echo "=========================================================" >> /tmp/avi
echo " " >> /tmp/avi
echo "Video files" >>/tmp/avi
cat /tmp/video >> /tmp/avi
echo "=========================================================" >> /tmp/avi
echo " " >> /tmp/avi
echo "images" >> /tmp/avi
cat /tmp/image >> /tmp/avi
echo "=========================================================" >> /tmp/avi
cat /tmp/avi | grep -vE 'ibm|lotus|Workspace|SametimeMeetings|SametimeRooms|.eclipse|workspace|gimp-|.thumbnails|Trash|SametimeTranscripts|Same
timeFileTransfers|.icon|.theme|.ILC|workplace-tmp' >> /tmp/output
echo "Files need attention"
cat /tmp/output
rm -rf /tmp/*
exit
