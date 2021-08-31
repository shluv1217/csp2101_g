#!/bin/bash
#Name : Sunghoon Shin (David)
#Student Number : 10529950

let sum=$1+$2+$3 # assign sum calculation of three input arguments to the variable sum
if [ $sum -gt 30 ]; then # if the sum is greater than 30, print the message which the limit is exceeded 
    echo "Sum exceeds maximum allowable"
else # if the sum is less than 30 or equal to 30, print the input arguments and the variable sum
    echo "The sum of $1 and $2 and $3 is $sum"
fi
exit 0 # exit program
