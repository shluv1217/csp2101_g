#!/bin/bash
#Name : Sunghoon Shin (David)
#Student Number : 10529950


while true; do # begin loop
    echo -e "1)Whole Match\n2)Any Match\n3)Inverted Match" # print options for searching
    read -p "Please enter the option for searching: " option # prompt the user for an option for searching 
    read -p "Please enter the search keyword: " keyword # prompt the user for a keyword for searching
    matchcnt=0 # create a match coutner and initialize to 0
    case $option in # begin case in the input argument option
        1) # whole match case
            orig_ifs=IFS # save the default IFS to a variable $orig_ifs
            IFS=$'\n' # set $IFS value to newline \n
            cnt=1 # create a line counter and initialize to 1
            for line in $(cat access_log.txt); do # read in each line of access_log.txt into for loop variable $line
                if [[ $line == "$keyword" ]]; then # check if current line contains the whole match word with the input argument $keyword
                    echo "Line $cnt: $line" # if yes, print the linenumber and line itself
                    ((matchcnt++)) # increment match counter by 1
                fi
                ((cnt++)) # increment line counter by 1
            done
            IFS=orig_ifs;; # restite #IFS with its original value 
        2) # any match case
            orig_ifs=IFS
            IFS=$'\n'
            cnt=1
            for line in $(cat access_log.txt); do
                if [[ $line == *"$keyword"* ]]; then # check if current line contains the substring the input argument $keyword
                    echo "Line $cnt: $line"
                    ((matchcnt++))
                fi
                ((cnt++))
            done
            IFS=orig_ifs;;
        3) # inverted match case
            orig_ifs=IFS
            IFS=$'\n'
            cnt=1
            for line in $(cat access_log.txt); do
                if [[ ! $line == *"$keyword"* ]]; then # check if current line doesn't contain the substring the input argument $keyword
                    echo "Line $cnt: $line"
                    ((matchcnt++))
                fi
                ((cnt++))
            done
            IFS=orig_ifs;;
    esac # exit case 
    echo "matched count : $matchcnt" # print total matched count

    if [ $matchcnt = 0 ]; then echo "No matches found" # if there are no matched word, print "no found" message
    fi

    read -p "Do you want to continue[y/n]" yn # prompt the user whether countiuing the search
    if [ $yn = 'n' ]; then break # if no, break the loop
    else continue # if yes, repeat the search process
    fi
done 
exit 0 # exit program