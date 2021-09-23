#!/bin/bash
#Name : Sunghoon Shin (David)
#Student Number : 10529950

inputfile=usrpwords.txt # set a variable named inpufile to usrpwords.txt

awk 'BEGIN {FS="\t"} 
    NR>1{
            if ((length($2))-1 >= 8) 
                {
                    if($2 !~ /[[:upper:]]/ || $2 !~ /[[:digit:]]/){
                        print "does NOT meet password strength requirements - " $2
                    }else{
                        print "meet password strength requirements\t- " $2
                    }
                }
            else
            {
                print "does NOT meet password strength requirements\t- " $2
            }  
    }
' $inputfile
#By using piping
#1. Capture contents of inputfile
#2. Split each line by "\t"(tab)
#3. Skip the first record line
#4. If password length is more than 8 and it contains upper charactor and number, print user and the message "meets password strength requirements"
#5. Else print the message "no meet password strength requirements" 


exit 0 # exit program
