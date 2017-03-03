#!/bin/bash
echo "
#########################################################################
#                                                                       #
#                                                                       #
#   This script is used to change the permission of files or directory  #
#                                                                       #
#    This should be run with the root privillage for proper execution   #
#                                                                       # 
#                                                                       #
#       This was written by rijojose@ihna.edu.au                        #
#                                                                       #
#                                                                       #
#                                                                       #
#########################################################################"

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
outputfile=/tmp/chkscript
if [ ! -f $outputfile ]; then
touch /tmp/chkscript
else 
cat /dev/null > $outputfile
fi
echo "Please enter the path to be searched"
read "output"
echo "The path is $output"
if [ ! -d $output ];then
 echo "The path is invalid" 1>&2
rm -rf $outputfile
exit 1
else
pathv=$output
fi
echo "what needs to be checked select d for directory, f for file <d or f> ?"
read SELECT
echo
if [ $SELECT = "d" ] ; then
echo "you chose directory, searching for directories under $pathv"
find $pathv -type d >>$outputfile
echo "Directory search completed please see the outputfile $outputfile"
elif [ $SELECT = "f" ] ; then
echo "you chose file, searching for files under $pathv"
find $pathv -type f >>$outputfile
echo "File search completed please see the outputfile $outputfile"
else 
echo "Sorry, Please select the correct option."
rm -rf $outputfile
exit 1
fi
echo "Do you wish to proceed <y or n>"
read "WISH"
if [ $WISH = "y" ]; then
echo "Enter the permisssion you need to grant to"
read "PERMISSION"
echo "Please re-enter the permission"
read "PERMISSION2"
elif [ $WISH = "n" ]; then
echo "you selected to exist the script"
exit 
else 
echo "Input is invalid"
exit 1
fi
if [ $PERMISSION = $PERMISSION2 ]; then
perm=$PERMISSION
else
echo "The given permissions does not match"
exit 1
fi
for i in `cat $outputfile`
do
chmod $perm $i
done
echo "The permission has changed as you requested"
cp /tmp/chkscript /home/jobin/"chkperm_$(date +%Y%m%d_%H%M%S)" 
rm -rf $outputfile
ls /home/jobin/chkperm_* | tail -1 >/tmp/test
clear
echo "please see the files/folders for which the permission is changed `cat /tmp/test`"
rm -rf /tmp/test
exit

