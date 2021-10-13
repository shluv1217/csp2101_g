#!/bin/bash
#Name : Sunghoon Shin (David)
#Student Number : 10529950



declare -a filelist # Declare an array named filelist to hold server log files
# Set server log filename into filelist array
filelist=("serv_acc_log_03042020.csv" "serv_acc_log_12032020.csv" "serv_acc_log_14032020.csv" "serv_acc_log_17032020.csv" "serv_acc_log_21032020.csv") 



# Function for prompting field menu and returning user's choice
checkinputfield(){

  while true; do # Begin while loop
    echo ""
    echo ""
    echo "---------------- [Field Options] ----------------"
    echo "1)PROTOCOL" 
    echo "2)SRCIP" 
    echo "3)SRCPORT" 
    echo "4)DESTIP" 
    echo "5)DESTPORT" 
    echo "6)PACKETS" 
    echo "7)BYTES"  
    echo "------------------------------------------------"
    local fieldoption=0 # Set local variable fieldoption for sending back 
    read -p ">> Please enter the field you want to search for : " field # Prompt the user for the field option
    case $field in # Begin case statement 
      1) fieldoption=1 # In case of the inputvalue 1(PROTOCOL), set value 1 to a variable named filedoption and break the while loop
         break ;;
      2) fieldoption=2 # In case of the inputvalue 2(SRCIP), set value 2 to a variable named filedoption and break the while loop
         break ;;
      3) fieldoption=3 # In case of the inputvalue 3(SRCPORT), set value 3 to a variable named filedoption and break the while loop
         break ;;
      4) fieldoption=4 # In case of the inputvalue 4(DESTIP), set value 4 to a variable named filedoption and break the while loop
         break ;;
      5) fieldoption=5 # In case of the inputvalue 5(DESTPORT), set value 5 to a variable named filedoption and break the while loop
        break ;;
      6) fieldoption=6 # In case of the inputvalue 6(PACKETS), set value 6 to a variable named filedoption and break the while loop
        break ;; 
      7) fieldoption=7 # In case of the inputvalue 7(BYTES), set value 7 to a variable named filedoption and break the while loop
        break ;;
      *) echo -e "![Error] Choose field among above selection\n";; # In case of the others, print error message and resume the loop
    esac           
  done 
  return $fieldoption # Return the variable filedoption to main 
}



# Function for prompting range option menu and returning user's choice
checkrangeoption(){

  echo ">> You selected range option field, please choose range options" # Print the message this function is for range option field

  while true; do # Begin while loop
    echo ""
    echo ""
    echo "---------------- [Range Options] ----------------"
    echo "1) Greater Than" 
    echo "2) Less Than" 
    echo "3) Equal To" 
    echo "4) Not Equal To"   
    echo "------------------------------------------------"
    local rangeoption=0 # Set local variable rangeoption for sending back
    read -p ">> Please enter the field you want to search for : " range # Prompt the user for the range option
    case $range in 
      1) rangeoption=1 # In case of the inputvalue 1(Greater Than), set value 1 to a variable named rangeoption and break the while loop
         break ;;
      2) rangeoption=2 # In case of the inputvalue 1(Less Than), set value 2 to a variable named rangeoption and break the while loop
         break ;;
      3) rangeoption=3 # In case of the inputvalue 1(Equal To), set value 3 to a variable named rangeoption and break the while loop
         break ;;
      4) rangeoption=4 # In case of the inputvalue 1(Not Equal To), set value 4 to a variable named rangeoption and break the while loop
         break ;;
      *) echo -e "![Error] Choose option among above selections\n";; # In case of the others, print error message and resume the loop
    esac           
  done 
  return $rangeoption # Return the variable rangeoption to main
}



# Function for prompting server log file list and returning user's choice
inputfilelist(){

    while true; do 
      echo ""
      echo ""
      echo "---------------- [Log File List] ----------------"
      len=${#filelist[*]} # get the total of elements in the filelist array for file list loop
      for (( i=0; i<${len}; i++)); do # set counter to 1, set end condition to lengh of array, increment by 1
        echo -e "$(($i+1))) ${filelist[$i]}" # echo the file name in the defined filelist array
      done
      echo "-------------------------------------------------"
      local filenumber=0 # Set local variable filenumber for sending back
      read -p ">> Please enter the field you want to search for : " filenumber # Prompt the user for the file for searching
      case $filenumber in 
        1) filenumber=0 # In case of the inputvalue 1(filelist(0)), set value 0 to a variable named filenumber and break the while loop
          break ;;
        2) filenumber=1 # In case of the inputvalue 2(filelist(1)), set value 1 to a variable named filenumber and break the while loop
          break ;;
        3) filenumber=2 # In case of the inputvalue 3(filelist(2)), set value 2 to a variable named filenumber and break the while loop
          break ;;
        4) filenumber=3 # In case of the inputvalue 4(filelist(3)), set value 3 to a variable named filenumber and break the while loop
          break ;;
        5) filenumber=4 # In case of the inputvalue 5(filelist(4)), set value 4 to a variable named filenumber and break the while loop
          break ;;
        *) echo -e "![Error] Choose file number among above selections\n";; # In case of the others, print error message and resume the loop
      esac           
    done 
    return $filenumber # Return the variable filenumber to main

}



# Function for searching the log and saving the selected records into target file
searchlogfile(){ 
  
  #echo "Params : $1,$2,$3,$4,$5,$6,$7,$8,$9"

  OLDIFS=$IFS # Save the default IFS to a variable $orig_ifs
  IFS=',' # Set $IFS value to comma(,)
  # Read the line and save the records to defined field variables 
  while read -r DATE DURATION PROTOCOL SRCIP SRCPORT DESTIP DESTPORT PACKETS BYTES FLOWS FLAGS TOS CLASS
  do
  case $1 in 
      1) value=$PROTOCOL;; # set value of protocol field in case of 1 (PROTOCOL)
      2) value=$SRCIP;; # set value of srcip field in case of 2 (SRCIP)
      3) value=$SRCPORT;; # set value of srcport field in case of 3 (SRCPORT)
      4) value=$DESTIP;; # set value of destip field in case of 4 (DESTIP)
      5) value=$DESTPORT;; # set value of destport field in case of 5 (DESTPORT)
      6) value=$PACKETS;; # set value of packets field in case of 6 (PACKETS)
      7) value=$BYTES;; # set value of bytes field in case of 7 (BYTES)
  esac

  logvalue="$(echo -e "${value}" | tr -d '[:space:]' | tr [:lower:] [:upper:])" # After trim and swtiching letters to uppercase, set value to the variable logvalue
  keywordvalue="$(echo -e "$3" | tr -d '[:space:]' | tr [:lower:] [:upper:])" # After trim and swtiching letters to uppercase, set inputkeyword to the variable keywordlvalue
  class="$(echo -e "$CLASS" | tr -d '[:space:]')" # Trim the field CLASS value 


  if [ ! "$class" = "normal" ];then # Any log file records in which the CLASS field is set to normal are to be filtered
    if [ $1 = 6 -o  $1 = 7 ];then  # If field option is either packets or bytes
      if [ $4 -eq 1 ];then # If range option is 1 (Greater Than)
          if [ $logvalue -gt $keywordvalue ];then # Filter the record which is greater than input keyword
            echo "$DATE,$DURATION,$PROTOCOL,$SRCIP,$SRCPORT,$DESTIP,$DESTPORT,$PACKETS,$BYTES,$FLOWS,$FLAGS,$TOS,$CLASS"
          fi
      elif [ $4 -eq 2 ];then # If range option is 2 (Less Than)
          if [ $logvalue -lt $keywordvalue ];then # Filter the record which is less than input keyword
            echo "$DATE,$DURATION,$PROTOCOL,$SRCIP,$SRCPORT,$DESTIP,$DESTPORT,$PACKETS,$BYTES,$FLOWS,$FLAGS,$TOS,$CLASS"
          fi
      elif [ $4 -eq 3 ];then # If range option is 3 (Equal To)
          if [ $logvalue -eq $keywordvalue ];then # Filter the record which is equal to input keyword
            echo "$DATE,$DURATION,$PROTOCOL,$SRCIP,$SRCPORT,$DESTIP,$DESTPORT,$PACKETS,$BYTES,$FLOWS,$FLAGS,$TOS,$CLASS"
          fi
      elif [ $4 -eq 4 ];then # If range option is 4 (Not Equal To)
          if [ ! $logvalue -eq $keywordvalue ];then # Filter the record which is not equal to input keyword
            echo "$DATE,$DURATION,$PROTOCOL,$SRCIP,$SRCPORT,$DESTIP,$DESTPORT,$PACKETS,$BYTES,$FLOWS,$FLAGS,$TOS,$CLASS"
          fi
      fi
    elif [ $1 = 2 -o  $1 = 4 ];then # If field option is either srcip or destip
        if [[ $logvalue == *"$keywordvalue"* ]];then # Filter the record which is partially equal to input keyword
          echo "$DATE,$DURATION,$PROTOCOL,$SRCIP,$SRCPORT,$DESTIP,$DESTPORT,$PACKETS,$BYTES,$FLOWS,$FLAGS,$TOS,$CLASS"
        fi
    else
      if [ "$logvalue" = "$keywordvalue" ];then # For remaining fields, filter the record which is equal to input keyword
        echo "$DATE,$DURATION,$PROTOCOL,$SRCIP,$SRCPORT,$DESTIP,$DESTPORT,$PACKETS,$BYTES,$FLOWS,$FLAGS,$TOS,$CLASS"
      fi
    fi
  fi

  # Read all the records from chosen input file except for header row
  # Subsequently, save the all the filered records into the temporal file
  done < <(tail -n +2 $2) > $5
  IFS=$OLDIFS #Set IFS with its original value 

  
  if [ "$9" = "N" -a $8 = 1 ];then # Advance all file option first file
    # If option is advance search and file is first file, write header and contents of the temporal files to chosen outputfile
    { echo -e "DATE,DURATION,PROTOCOL,SRCIP,SRCPORT,DESTIP,DESTPORT,PACKETS,BYTES,FLOWS,FLAGS,TOS,CLASS"; cat $5; } > $7
  elif [ "$9" = "N" -a ! $8 = 1 ];then #Advance all file option not first file
    # If option is advance search and file is not first file, append contents of the temporal files to chosen outputfile
    { cat $5; } >> $7
  else #Advance single file and basic option
    # If option is for single file, write contents of the temporal files to chosen outputfile
    { echo -e "DATE,DURATION,PROTOCOL,SRCIP,SRCPORT,DESTIP,DESTPORT,PACKETS,BYTES,FLOWS,FLAGS,TOS,CLASS"; cat $5; } > $7
  fi

}



# Function for formatting the contents of outputfile 
outputfileformatting(){

  #echo "outputfileformatting param : $1, $2, $3"

  #If the field option is either packet or bytes, print all the fields of outputfile formally and caculate the sum of packets and bytes
  #Then print total packets and bytes at the end of contents 
  if [ "$2" = "Y"  ]; then
    awk 'BEGIN {FS=","; packettotal=0; bytestotal=0} 
          NR>0{
            { 
              printf "%-10s %-10s %-10s %-10s %-10s %-10s %-10s %-10s %-10s %-10s %-10s %-10s %-10s \n", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13;
              packettotal=packettotal+$8;
              bytestotal=bytestotal+$9;

            }
          }
          END {
            print "Packet Total : "packettotal;
            print "Bytes Total : "bytestotal;
          }
        ' $1 
  #If the field option is normal field, print all the fields of outputfile formally
  else 
    awk 'BEGIN {FS=",";} 
            NR>0{
              { 
                printf "%-10s %-10s %-10s %-10s %-10s %-10s %-10s %-10s %-10s %-10s %-10s %-10s %-10s \n", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13;
              }
            }
        ' $1 
  fi
  
}



#Main 
while true; do
  paramInputfile="" # Initialize the variable paramInputfile for intput file name for searching
  searchoption="" # Initialize the variable searchoption for search option (Basic / Advance)
  inputfileoption=0 # Initialize the variable inputfileoption for file list array
  fieldoption=0 # Initialize the variable fieldoption for search field option 
  rangeoption=0 # Initialize the variable rangeoption for range field(Packets, Bytes)
  searchorder=0 # Initialize the variable searchorder for advance single file search option (Maximum 3 fields are possible)
  fileoption="" # Initialize the variable fileoption for file option (Single File / All Files)
  calculationyn="N" # Initialize the variable calculationyn for selective printing sum of range field(Packets, Bytes)
  singlefileyn="Y" # Initialize the variable singlefileyn for selective saving records to outputfile
  advanceyn="" # Initialize the variable advanceyn for selective search operation (Basic / Advance)
  searchdir="./serv_acc/" # set log location directory "./serv_acc" to the variable searchdir
  tmpfilename="temp.csv" # Initialize the variable tmpoutputfilename for saving search records temporally 
  # Initialize the variable progressmsg for substitution of repetitive common message
  progressmsg='echo ---------------- [Processing.....] ----------------' 

  echo "---------------- [Begin Search Process] ----------------"
  echo ""
  echo ""
  #Check whether the file selected by user exists and save the output file name as outputfilename
  while true; do #Begin while loop
    echo "---------------- [Outputfile] --------------------------------"
    echo " You need to choose unique file name in the current directory"
    echo "--------------------------------------------------------------"
    read -p ">> Please enter the outputfile name you want to save the result : " outputfilename # Prompt the user for the outputfile name
    #If the outputfile name exists, prompt error message and resume the process
    if [ -f "$outputfilename" ]; then 
      echo -e "![Error] The file name exist, please enter unique file name in current directory\n"
      continue
    #If the outputfile name doesn't exists, break the while loop
    else
      break
    fi
  done  

  #Check the search option (Basic / Advance)
  while true; do #Begin while loop
    echo ""
    echo ""
    echo "---------------- [Search Options] ----------------"
    echo "1) Basic Search 2) Advance Search "
    echo "--------------------------------------------------"
    read -p ">> Please enter the search option : " searchoption # Prompt the user for the search option
    echo -e "\n"
    case $searchoption in 
      1) searchoption="basic" # In case of 1(Basic), set value basic to a variable named searchoption and break the while loop
         break ;;
      2) searchoption="advance" # In case of 2(Advance), set value advance to a variable named searchoption and break the while loop
         break ;;
      *) echo -e "![Error] Choose search option among above selections\n";; # In case of the others, print error message and resume the loop
    esac
  done 

   
  #Advance search option 
  if [ "$searchoption" = "advance"  ]; then
    advanceyn="Y"
    while true; do #Begin while loop
      echo "---------------- [Advance Search Options] ----------------"
      echo "1) Single File 2) All Files "
      echo "----------------------------------------------------------"
      read -p ">> Please enter the advance search option : " advanceoption # Prompt the user for the advence search option
      case $advanceoption in 
      1) fileoption="single" # In case of 1(single), set value single to a variable named fileoption and break the while loop
          break ;;
      2) fileoption="all"  # In case of 2(all), set value all to a variable named fileoption and break the while loop
          break ;;
      *) echo -e "![Error] Choose the advance search options above\n";; # In case of the others, print error message and resume the loop
      esac
    done  


    #Advance option for Single File
    if [ "$fileoption" = "single" ]; then 

      echo ">> You selected a single file option. You can set maximum three(3) fields for searching" 

      inputfilelist # Invoke the function inputfilelist for listing up file list that user can choose for searching
      inputfileoption=$? # Set selected number of array filelist to the variable named inputfileoption
      inputfile=${filelist[$inputfileoption]} # Set value of array filelist(selected file name) to the variable named inputfile

      while true; do #Begin while loop
        checkinputfield # Invoke the function checkinputfield for field for searching
        fieldoption=$? # Set the selected field to variable named fieldoption
        searchorder=$((searchorder+1)) # Set order of this search for advance single file search
        paramInputfile="./serv_acc/$inputfile" # Set the selected intpufile name to the variable named paramInputfile

        # In case of range field(Packets or Bytes)
        if [ $fieldoption = 6 -o  $fieldoption = 7 ]; then
            checkrangeoption # Invoke the function for choosing range option
            rangeoption=$? # Set the selected range option to the variable named rangeoption
            calculationyn="Y" # Set the "Y" to the variable named calculationyn for caculation action
        fi

        read -p ">> Please enter the keyword you want to search for : " keyword # Prompt the user for search keyword


        # If it is first field, 
        if  [ $searchorder = 1  ]; then
          # Invoke searchlogfile function with selected input log file as input file 
          # 1.Field, 2.Inputfile, 3.Keyword, 4.Rangeoption, 5.TemporamFile, 6.AdvancedYN, 7.Outputfile, 8.SearchOrder, 9.Single/All File
          searchlogfile $fieldoption $paramInputfile $keyword $rangeoption $tmpfilename $advanceyn $outputfilename $searchorder $singlefileyn       
        else 
          # Invoke searchlogfile function with result outputfile of first field as input file 
          # 1.Field, 2.Inputfile, 3.Keyword, 4.Rangeoption, 5.TemporamFile, 6.AdvancedYN, 7.Outputfile, 8.SearchOrder, 9.Single/All File
          searchlogfile $fieldoption $outputfilename $keyword $rangeoption $tmpfilename $advanceyn $outputfilename $searchorder $singlefileyn
        fi


        # If it is not last field, ask users weather other fieds need to add for searching
        if ! [ $searchorder = 3  ]; then
          read -p ">> Do you want to add more field for the current search (y/n)? : " morefieldYN # Prompt the user for extra field search 
          # If user chosen to add more field, repeat the current process 
          if [ "$morefieldYN" = "y"  ]; then 
            continue     
          # Otherwise, break the while loop
          else
            break
          fi
        # If it is last field, break the while loop
        else
            break
        fi
      done 

      $progressmsg #Progress Bar

      #Outputfile formatting and calculation in case of packet and bytes field
      outputfileformatting $outputfilename $calculationyn
    
    #Advance option for All Files
    else 
      checkinputfield # Invoke the function checkinputfield for field for searching
      fieldoption=$? # Set the selected field to variable named fieldoption

      # In case of range field(Packets or Bytes)
      if [ $fieldoption = 6 -o  $fieldoption = 7 ]; then
          checkrangeoption # Invoke the function for choosing range option
          rangeoption=$? # Set the selected range option to the variable named rangeoption
          calculationyn="Y" # Set the "Y" to the variable named calculationyn for caculation action
      fi
      read -p ">> Please enter the keyword you want to search for : " keyword # Prompt the user for search keyword
      singlefileyn="N"
      
      echo ""
      echo "" 
      $progressmsg #Progress Bar
      
      #Begin for loop for all log files in serv_acc directory
      for inputfile in ./serv_acc/*
      do
        searchorder=$((searchorder+1)) # Set order of this search for advance single file search
        # Invoke searchlogfile function with the variable named inputfile as input file name
        # 1.Field, 2.Inputfile, 3.Keyword, 4.Rangeoption, 5.TemporamFile, 6.AdvancedYN, 7.Outputfile, 8.SearchOrder, 9.Single/All File
        searchlogfile $fieldoption $inputfile $keyword $rangeoption $tmpfilename $advanceyn $outputfilename $searchorder $singlefileyn
      done

      #Outputfile formatting and calculation in case of packet and bytes field
      outputfileformatting $outputfilename $calculationyn

    fi

  #Basic search option 
  else 
    advanceyn="N" # Set the variable advanceyn to "N" (Basic Search Option)
    singfileyn="N" # Set the variable singfileyn to "N" 

    inputfilelist # Invoke the function inputfilelist for listing up file list that user can choose for searching
    inputfileoption=$? # Set selected number of array filelist to the variable named inputfileoption
    inputfile=${filelist[$inputfileoption]} # Set value of array filelist(selected file name) to the variable named inputfile

    checkinputfield # Invoke checkinputfield function to get the column for search from user
    fieldoption=$? # Save the chosen column as the variable fieldoption

    # In case of range field(Packets or Bytes)
    if [ $fieldoption = 6 -o  $fieldoption = 7 ]; then
      checkrangeoption # Invoke the function for choosing range option
      rangeoption=$? # Set the selected range option to the variable named rangeoption
      calculationyn="Y" # Set the "Y" to the variable named calculationyn for caculation action
    fi

    read -p ">> Please enter the keyword you want to search for : " keyword # prompt the user for the keyword relevant to the chosen field
    paramInputfile="./serv_acc/$inputfile" # Set the selected intpufile name to the variable named paramInputfile
    searchorder=1 # Set order of this search for advance single file search

    #Invoke the searchlogfile for searching log with input parameters
    # 1.Field, 2.Inputfile, 3.Keyword, 4.Rangeoption, 5.TemporamFile, 6.AdvancedYN, 7.Outputfile, 8.SearchOrder, 9.Single/All File
    echo ""
    echo ""
    $progressmsg #Progress Bar
    searchlogfile $fieldoption $paramInputfile $keyword $rangeoption $tmpfilename $advanceyn $outputfilename $searchorder $singlefileyn

    #Outputfile formatting and calculation in case of packet and bytes field
    outputfileformatting $outputfilename $calculationyn
  
  fi # Basic/Advance Option Closing


  rm $tmpfilename # Delete the used temporal file after search job is finished
  # Print finish message, and let user know the filename contains records
  echo ""
  echo ""
  echo ">> Search finished, please check the result in $outputfilename!!"
  echo ""


  # Serch Resume Option
  echo "---------------- Search Resume Option ----------------"
  echo "If you want to exit the search process, press 'n'     "
  echo ",otherwise searching will be resuming"
  echo "------------------------------------------------------"
  read -p ">> Do you want to continue searching (y/n)? : " continueYN # Prompt users whether contueing search process
  echo ""
  echo ""

  # If user dont want to continue search proccess, break the while loop
  # Otherwise continue the search process
  if [ "$continueYN" = "n" ]; then 
    echo "---------------- Thank you for searching, Goody Bye!! ----------------"
    echo ""
    echo ""
    break
  fi
  
done 

exit 0 # exit program
