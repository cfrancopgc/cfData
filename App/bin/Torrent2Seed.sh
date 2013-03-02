HOST=eut12.seed.st
USER=cfjunik	
PASS=pi31416
LOG=/Users/admin/Dropbox/upload.log

JNAME=$(basename "$1")

echo "$1" -- watch/"$JNAME" >> $LOG

ftp -inv $HOST << EOF
user $USER $PASS
put "$1" watch/"$JNAME"
EOF
>> $LOG 2>&1

echo "$1" -- watch/"$JNAME" >> $LOG