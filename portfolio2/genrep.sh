#!/bin/bash
#Name : Sunghoon Shin (David)
#Student Number : 10529950

inputfile=attacks.html # set a variable named inpufile to attack.html

cat $inputfile | grep -E '(DDOS)|(MALWARE)|(XSS)|(SQL-INJ)|(MitM)' | sed -E 's/<[^>]+>/ /g' | awk 'BEGIN {FS=" "; print "Attacks\t\tInstances(Q3)"}
NR>0{totalsum=$1+$2+$3+$4; printf ""$1"\t\t%.0f \n", totalsum;}'
#By using piping
#1. Capture contents of inputfile
#2. Grep lines which contain the words namely DDOS, MALWARE, XSS, SQL - INJ, MitM
#3. Replace tags in html to " "(space)
#4. Split each line by " "(space) and print header. Subsequently, calculate sum of each field except for line 0 
#   and, print the line 0 and the caculated sum

exit 0 # exit program
