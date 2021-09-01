#!/bin/bash
#Name : Sunghoon Shin (David)
#Student Number : 10529950

while true; do # begin loop
    read -p "Plase enter the search pattern: " keyword # prompt the user for an option for searching pattern
    read -p "Do you want a whole match?(y(whole)/n(any)): " wholeyn # prompt the user for an option for a whole match 
    read -p "Do you want an inverted match?(y/n): " invertyn # prompt the user for a keyword for an inverted match
    orig_ifs=IFS # save the default IFS to a variable $orig_ifs
    IFS=$'\n' # set $IFS value to newline \n
    cnt=1 # create a line counter and initialize to 1
    matchcnt=0 # create a match coutner and initialize to 0
    for line in $(cat access_log.txt); do # read in each line of access_log.txt into for loop variable $line
        if [[ $invertyn == "y" ]]; then # check if user's option is an inverted match
            if [[ $wholeyn == "y" ]]; then # if it is an inverted match option, check a whole match option
                if [[ ! $line == "$keyword" ]]; then # if options are an inverted and whole match option, find all line not whole-matched with the keyword
                    echo "Line $cnt: $line" # if yes, print the linenumber and line itself
                    ((matchcnt++)) # increment match counter by 1
                fi
                ((cnt++)) # increment line counter by 1
            else 
                if [[ ! $line == *"$keyword"* ]]; then # if options are an inverted and not whole match option, find all line not partially-matched with the keyword                   echo "Line $cnt: $line" # if yes, print the linenumber and line itself
                    echo "Line $cnt: $line" # if yes, print the linenumber and line itself
                    ((matchcnt++)) # increment match counter by 1
                fi
                ((cnt++)) # increment line counter by 1
            fi
        else 
            if [[ $wholeyn == "y" ]]; then #if it is an not inverted match option, check a whole match option
                if [[ $line == "$keyword" ]]; then # if options are an not inverted and whole match option, find all line whole-matched with the keyword
                    echo "Line $cnt: $line" # if yes, print the linenumber and line itself
                    ((matchcnt++)) # increment match counter by 1
                fi
                ((cnt++)) # increment line counter by 1
            else 
                if [[ $line == *"$keyword"* ]]; then # if options are an not inverted and not whole match option, find all line partially-matched with the keyword 
                    echo "Line $cnt: $line" # if yes, print the linenumber and line itself
                    ((matchcnt++)) # increment match counter by 1
                fi
                ((cnt++)) # increment line counter by 1
            fi
        fi
    done
    IFS=orig_ifs # restite #IFS with its original value 

    echo "matched count : $matchcnt" # print total matched count

    if [ $matchcnt = 0 ]; then echo "No matches found" # if there are no matched lines, print "no found" message
    fi

    read -p "Do you want to continue[y/n]" yn # prompt the user whether countiuing the search
    if [ $yn = 'n' ]; then break # if no, break the loop
    else continue # if yes, repeat the search process
    fi
done 
exit 0 # exit program