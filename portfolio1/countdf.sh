#!/bin/bash
#Name : Sunghoon Shin (David)
#Student Number : 10529950

nonemptyFilecnt=0 # set a variable named nonemptyFilecnt to 0
emptyFileCnt=0 # set a variable named emptyFileCnt to 0
nonemptyDircnt=0 # set a variable named nonemptyDircnt to 0
emptyDirCnt=0 # set a variable named emptyDirCnt to 0
for item in $1/* $1.*; do # read in each file or directory into for loop variable item
    if [ -f $item ]; then # check if current item is file
        if [ -s $item ]; then # if the item is file, check whether file size is not zero
            ((nonemptyFilecnt++)) # if the file is not empty, increment counter nonemptyFilecnt by 1
        else
            ((emptyFileCnt++)) # if the file is empty, increment counter emptyFileCnt by 1
        fi
    elif [ -d $item ]; then # check if current item is directory
        if [ "$(ls -A $item)" ]; then # if the item is file, check whether the directory is not empty
            ((nonemptyDircnt++)) # if the directory is not empty, increment counter nonemptyDircnt by 1
        else
            ((emptyDirCnt++)) # if the file is empty, increment counter emptyDirCnt by 1
        fi
    fi
done
echo -e "The $1 directory contains: 
        \n$nonemptyFilecnt files that contain data
        \n$emptyFileCnt files that are empty
        \n$nonemptyDircnt non-empty directories
        \n$emptyDirCnt empty directories" 
        # print the current value of $1, $nonemptyFilecnt, $emptyFileCnt, $nonemptyDircnt, $emptyDirCnt to terminal
exit 0 # exit program


