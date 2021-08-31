#!/bin/bash
#Name : Sunghoon Shin (David)
#Student Number : 10529950


while true; do # Begin loop
    read -p "Please enter two digit numberic code (20 or 40): " var # Prompt user for two digit number (20 or 40)
        if [ "$var" = 20 -o "$var" = 40 ]; then # If the number is 20 or 40, exit loop
            break
        elif [ -z $var ]; then # If the number is null, echo null error message to terminal
            echo "The value should not be empty!"
        elif [[ ! $var =~ ^-?[0-9]+$ ]]; then  # If the number is not integer, echo type error message to terminal
            echo "The value should be integer!"
        else  # If the number is not 20 or 40, echo the valid number error message to terminal
            echo "Invalid Input,try again!"
        fi
done

echo "You successfuly entered correct digit number : $var" # Echo the input number to terminal
exit 0 # exit program
