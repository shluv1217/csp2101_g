#!/bin/bash
#Name : Sunghoon Shin (David)
#Student Number : 10529950

getprop(){ # declare fucntion named getprop
    wordcount=`wc --word < $1` # set word count of the input file $1 into the variable wordcount
    filesize=$(du -k "$1" | cut -f 1) # set file size of the input file $1 into the variable filesize
    date=$(date -r $1 +"%m-%-d-%Y %H:%M:%S") # set last modified date of the input file $1 into the variable date
    echo "The file $1 contains $wordcount words and is $filesize K in size and was last modified $date" # print wordcount, filesize, last modified date
}

read -p "Plase enther the filename: " filename # prompt the user for the file name
getprop $filename # invoke the function named getprop, and set input argument as $filename
exit 0 # exit program