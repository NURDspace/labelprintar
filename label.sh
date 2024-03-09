#!/bin/bash
# Takes arguments and puts it as text in a templated label for our labelprinter
if [[ $# -eq 0 ]] ; then
    echo 'No arguments given, exiting...'
    exit 0
fi
echo $*
if [ "$(echo $1 | awk '{print substr($0,0,2)}')" == "0x" ] ; then
#This is a sanitised input from nurdbot.
INPUT=$(python3 -c "print(bytes.fromhex('$1'.strip()[2:]).decode('utf8'))")
#INPUT=$(python -c "print('$1'[2:].decode('hex'))")
else
INPUT="$*"
fi
echo $INPUT
cd /home/labelprinter/nurdbotlabelprinting/
cp empty.png output.png
convert output-noline.png output.gif
convert output.gif -background none -font "Garuda.ttf"  -gravity Center\
 -size 734x367 caption:"$INPUT" -layers flatten output.gif

convert output.gif -rotate 90 output.gif

# print!
lp -d SII_SLP650 output.gif

# print linefeed (newline)
# echo `>|` > echo.lp
#lp -d SII_SLP650 echo.lp

# view output
# qiv output.gif

#log
echo $INPUT >> label.log

#code for moving to next empty label but it's not reliable
#printf "\f" |lpr -P SII_SLP650
