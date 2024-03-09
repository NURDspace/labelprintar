#!/bin/bash
# Takes arguments and puts it as text in a templated label for our labelprinter
if [[ $# -eq 0 ]] ; then
    echo 'No arguments given, exiting...'
    exit 0
fi
echo $*
if [ "$(echo $1 | awk '{print substr($0,0,3)}')" == "0x" ] ; then
#This is a sanitised input from nurdbot.
#INPUT=$(python3 -c "print(bytes.fromhex('$1'.strip()[2:]).decode('utf8'))")
INPUT=$(python -c "print('$1'[2:].decode('hex'))")
else
INPUT="$*"
fi
echo $INPUT
cd /home/labelprinter/nurdbotlabelprinting/
cp emptybc.png outputbc.png
convert outputbc.png outputbc.gif
convert outputbc.gif -background none -font "Garuda.ttf"  -gravity South\
 -size 734x367 -pointsize 45 caption:"BCID: $INPUT" -layers flatten outputbc.gif

convert outputbc.gif -rotate 90 outputbc.gif

# print!
lp -d SII_SLP650 outputbc.gif

# print linefeed (newline)
# echo `>|` > echo.lp
#lp -d SII_SLP650 echo.lp

# view output
#qiv outputbc.gif

#log
echo $INPUT >> bclabel.log

#code for moving to next empty label but it's not reliable
printf "\f" |lpr -P SII_SLP650
