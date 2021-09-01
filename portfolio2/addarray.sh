#!/bin/bash
#Name : Sunghoon Shin (David)
#Student Number : 10529950
declare -a ass1 # declare an array named ass1 to hold assignment1 scores
declare -a ass2 # declare an array named ass2 to hold assignment2 scores
ass1=(12 18 20 10 12 16 15 19 8 11) # set assignment1 scores into ass1 array
ass2=(22 29 30 20 18 24 25 26 29 30) # set assigment scores into ass2 array
len=${#ass1[*]} # get the total of elements in the ass1 array for calculation loop
let sum=0 # initialize a variable to hold sum of assignment1 score and assignment2 score
for (( i=0; i<${len}; i++)); do # set counter to 1, set end condition to lengh of array, increment by 1
    sum=$((${ass1[$i]} + ${ass2[$i]})) # assign sum calculation of values in ass1 array and ass2 array to the variable sum
    echo -e "Student_$(($i+1)) Result:\t$sum" # echo the each caculated sum
done
exit 0 # exit program


