#!/bin/bash
#Name : Sunghoon Shin (David)
#Student Number : 10529950

getprop(){ # declare fucntion named getprop
    wordcount=`wc --word < $1` # set word count of the input file $1 into the variable wordcount
    filesize=$(wc -c $1 | awk '{print $1}') #calculate the file size as default(bytes) and save the value as the variable filesize
    kbsize=$(bc <<<"scale=3; $filesize / 1024") #convert bytes file size to Kbytes file size and save the value as the variable kbsize
    date=$(date -r $1 +"%d-%m-%Y %H:%M:%S") # set last modified date of the input file $1 into the variable date
    echo "The file $1 contains $wordcount words and is $kbsize K in size and was last modified $date" # print wordcount, filesize, last modified date
}

read -p "Plase enter the filename: " filename # prompt the user for the file name
getprop $filename # invoke the function named getprop, and set input argument as $filename
exit 0 # exit program
