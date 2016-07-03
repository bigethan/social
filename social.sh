#!/usr/bin/env bash

# put this somewhere in your bash setup
# and name it what you
# function your-social-alias() {
#   ~/path/to/this/file.sh $@
#   #if you want to delete the command from history
#   # history -d $((HISTCMD-1))
# }
#
# now the options are:
# ]$ social ethan
# enter note when prompted
#
# ]$ social show ethan
# shows notes for friend
#
# ]$ social show
# shows all notes for all friends
#
# ]$ social done ethan N
# deletes the line from the log with the id N
#

# choose your own logfile if you want
LOGFILE_BASE=~/.friendlog/
TEMPFILE=~/.friendtmp

# done [friend] [id]
if [ "$1" = "done" ] && [ "$2" != "" ] && [ "$3" != "" ]; then
  LOGFILE=$LOGFILE_BASE$2
  grep -v "^$3 |" $LOGFILE > $TEMPFILE && mv $TEMPFILE $LOGFILE
# show [friend]
elif [ "$1" = "show" ] && [ "$2" != "" ]; then
  cat $LOGFILE_BASE$2
# show
elif [ "$1" = "show" ]; then
  for f in $LOGFILE_BASE*; do
    NAME=${f##*/}
    echo "** $NAME"
    cat $f
    echo "--------"
  done
# [friend]
elif [ $# -eq 1 ]; then
  LOGFILE=$LOGFILE_BASE$1
  ID=`grep -o "^[0-9]\{1,\} |" $LOGFILE | tail -1 | cut -d' ' -f1`
  # if [ "$ID" = "" ]; then ID=1; fi
  NOW=`date "+ | %Y-%m-%d %H:%M:%S |"`
  echo -n "$1:: "
  read MSG
  LOG=`echo $(($ID + 1)) $NOW $MSG`
 if [ ! -f "$LOGFILE" ]; then
     mkdir -p "`dirname \"$LOGFILE\"`" 2>/dev/null
 fi
  echo $LOG >> $LOGFILE
fi
