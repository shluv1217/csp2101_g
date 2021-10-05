#!/bin/bash
#Name : Sunghoon Shin (David)
#Student Number : 10529950

checkinputcolumn(){

  while true; do 
    echo "---------------- Column Options ----------------"
    echo "1)PROTOCOL" 
    echo "2)SRCIP" 
    echo "3)SRCPORT" 
    echo "4)DESTIP" 
    echo "5)DESTPORT" 
    echo "6)PACKETS" 
    echo "7)BYTES"  
    echo "8)CLASS"
    echo "------------------------------------------------"
    local columnoption=0
    read -p ">> Please enter the column you want to search for : " column
    case $column in 
      1) columnoption=1
         break ;;
      2) columnoption=2
         break ;;
      3) columnoption=3
         break ;;
      4) columnoption=4
         break ;;
      5) columnoption=5
        break ;;
      6) columnoption=6
        break ;;
      7) columnoption=7
        break ;;
      8) columnoption=8
        break ;;
      *) echo -e "![Error] Choose the above column options \n";;
    esac           
  done 
  return $columnoption
}


singfilelesearchlog(){ #single file search function
  
  echo "Params : $1,$2,$3,$4,$5,$6,$7,$8"


  OLDIFS=$IFS
  IFS=','
  while read -r DATE DURATION PROTOCOL SRCIP SRCPORT DESTIP DESTPORT PACKETS BYTES FLOWS FLAGS TOS CLASS
  do
  case $1 in 
      1) value=$PROTOCOL;; # set value of protocol field in case of 1 (PROTOCOL)
      2) value=$SRCIP;; # set value of srcip field in case of 1 (SRCIP)
      3) value=$SRCPORT;; # set value of srcport field in case of 1 (SRCPORT)
      4) value=$DESTIP;; # set value of destip field in case of 1 (DESTIP)
      5) value=$DESTPORT;; # set value of destport field in case of 1 (DESTPORT)
      6) value=$PACKETS;; # set value of packets field in case of 1 (PACKETS)
      7) value=$BYTES;; # set value of bytes field in case of 1 (BYTES)
      #8) value=$CLASS;;
  esac

  logvalue="$(echo -e "${value}" | tr -d '[:space:]')"
  keywordvalue="$(echo -e "$3" | tr -d '[:space:]')"
  class="$(echo -e "$CLASS" | tr -d '[:space:]')"


  if [ "$class" = "normal" ];then # Any log file records in which the CLASS field is set to normal are to be filtered
    if [ $1 = 6 -o  $1 = 7 ];then   
      if [ $4 -eq 1 ];then
          if [ $logvalue -gt $keywordvalue ];then
            echo "$DATE,$DURATION,$PROTOCOL,$SRCIP,$SRCPORT,$DESTIP,$DESTPORT,$PACKETS,$BYTES,$FLOWS,$FLAGS,$TOS,$CLASS"
          fi
      elif [ $4 -eq 2 ];then
          if [ $logvalue -lt $keywordvalue ];then
            echo "$DATE,$DURATION,$PROTOCOL,$SRCIP,$SRCPORT,$DESTIP,$DESTPORT,$PACKETS,$BYTES,$FLOWS,$FLAGS,$TOS,$CLASS"
          fi
      elif [ $4 -eq 3 ];then
          if [ $logvalue -eq $keywordvalue ];then
            echo "$DATE,$DURATION,$PROTOCOL,$SRCIP,$SRCPORT,$DESTIP,$DESTPORT,$PACKETS,$BYTES,$FLOWS,$FLAGS,$TOS,$CLASS"
          fi
      elif [ $4 -eq 4 ];then
          if [ ! $logvalue -eq $keywordvalue ];then
            echo "$DATE,$DURATION,$PROTOCOL,$SRCIP,$SRCPORT,$DESTIP,$DESTPORT,$PACKETS,$BYTES,$FLOWS,$FLAGS,$TOS,$CLASS"
          fi
      fi
    elif [ $1 = 2 -o  $1 = 4 ];then
        if [[ $logvalue == *"$keywordvalue"* ]];then
          echo "$DATE,$DURATION,$PROTOCOL,$SRCIP,$SRCPORT,$DESTIP,$DESTPORT,$PACKETS,$BYTES,$FLOWS,$FLAGS,$TOS,$CLASS"
        fi
    else
      if [ "$logvalue" = "$keywordvalue" ];then
        echo "$DATE,$DURATION,$PROTOCOL,$SRCIP,$SRCPORT,$DESTIP,$DESTPORT,$PACKETS,$BYTES,$FLOWS,$FLAGS,$TOS,$CLASS"
      fi
    fi
  fi

  # Read all the records from chosen input file except for header row
  # Subsequently, save the all the filered records into selected output file
  done < <(tail -n +2 "./serv_acc/"$2) > $5 
  IFS=$OLDIFS

  if [ "$6" = "Y" -a ! $8 = 3 ];then # In case of advanced search option and not last field, save the records into temporal file
    { echo -e "DATE,DURATION,PROTOCOL,SRCIP,SRCPORT,DESTIP,DESTPORT,PACKETS,BYTES,FLOWS,FLAGS,TOS,CLASS"; cat $5; } > $7
  fi
}


allfilesearchlog(){

  OLDIFS=$IFS
  IFS=','
  while read -r DATE DURATION PROTOCOL SRCIP SRCPORT DESTIP DESTPORT PACKETS BYTES FLOWS FLAGS TOS CLASS
  do

  case $1 in 
      1) value=$PROTOCOL;;
      2) value=$SRCIP;;
      3) value=$SRCPORT;;
      4) value=$DESTIP;;
      5) value=$DESTPORT;;
      6) value=$PACKETS;;
      7) value=$BYTES;;
      #8) value=$CLASS;;
  esac

  logvalue="$(echo -e "${value}" | tr -d '[:space:]')"
  keywordvalue="$(echo -e "$3" | tr -d '[:space:]')"
  class="$(echo -e "$CLASS" | tr -d '[:space:]')"


  if  [ ! "$class" = "normal" ];then # Any log file records in which the CLASS field is set to normal are to be filtered
    if [ $1 = 6 -o  $1 = 7 ];then   
      if [ $4 -eq 1 ];then
          if [ $logvalue -gt $keywordvalue ];then
            echo "$DATE,$DURATION,$PROTOCOL,$SRCIP,$SRCPORT,$DESTIP,$DESTPORT,$PACKETS,$BYTES,$FLOWS,$FLAGS,$TOS,$CLASS"
          fi
      elif [ $4 -eq 2 ];then
          if [ $logvalue -lt $keywordvalue ];then
            echo "$DATE,$DURATION,$PROTOCOL,$SRCIP,$SRCPORT,$DESTIP,$DESTPORT,$PACKETS,$BYTES,$FLOWS,$FLAGS,$TOS,$CLASS"
          fi
      elif [ $4 -eq 3 ];then
          if [ $logvalue -eq $keywordvalue ];then
            echo "$DATE,$DURATION,$PROTOCOL,$SRCIP,$SRCPORT,$DESTIP,$DESTPORT,$PACKETS,$BYTES,$FLOWS,$FLAGS,$TOS,$CLASS"
          fi
      elif [ $4 -eq 4 ];then
          if [ ! $logvalue -eq $keywordvalue ];then
            echo "$DATE,$DURATION,$PROTOCOL,$SRCIP,$SRCPORT,$DESTIP,$DESTPORT,$PACKETS,$BYTES,$FLOWS,$FLAGS,$TOS,$CLASS"
          fi
      fi
    elif [ $1 = 2 -o  $1 = 4 ];then
        if [[ $logvalue == *"$keywordvalue"* ]];then
          echo "$DATE,$DURATION,$PROTOCOL,$SRCIP,$SRCPORT,$DESTIP,$DESTPORT,$PACKETS,$BYTES,$FLOWS,$FLAGS,$TOS,$CLASS"
        fi
    else
      if [ "$logvalue" = "$keywordvalue" ];then
        echo "$DATE,$DURATION,$PROTOCOL,$SRCIP,$SRCPORT,$DESTIP,$DESTPORT,$PACKETS,$BYTES,$FLOWS,$FLAGS,$TOS,$CLASS"
      fi
    fi
  fi

  done < <(tail -n +2 $2) >> output.csv
  IFS=$OLDIFS


}


inputfilelist(){
    echo ""
    echo ""
    echo "---------------- Log File List ----------------"
    for entry in "$searchdir"/*
    do
      echo "$entry"
    done
    echo "--------------------------------------------"
}


packetbytecal(){
  #awk -F "," '{PacketTotal=PacketTotal+$8} END{print "PacketTotal : " PacketTotal}' $1
  awk -F "," '{PacketTotal=PacketTotal+$8} END{print "PacketTotal : " PacketTotal}' $1 >> $1
  #awk -F "," '{BytesTotal=BytesTotal+$9} END{print "BytesTotal : " BytesTotal}' $1
  awk -F "," '{BytesTotal=BytesTotal+$9} END{print "BytesTotal : " BytesTotal}' $1 >> $1
}




searchoption=""
columnoption=0
fileoption=""
calculationyn="N"
advanceyn=""
searchdir="./serv_acc/" # set log location directory "./serv_acc" to the variable searchdir
tmpfilename="temp.csv"



#Check whether the file selected by user exists and save the output file name as outputfilename
while true; do
  echo "---------------- [Begin Search Process] ----------------"
  echo ""
  echo ""
  while true; do
    echo "---------------- [STEP1] Outputfile ----------------"
    echo " You need to choose unique file name in the current directory"
    echo "----------------------------------------------------"
    read -p ">> Please enter the outputfile name you want to save the result : " outputfilename 
    #outputfilenameyn="Y"
    if [ -f "$outputfilename" ]; then 
      echo -e "![Error] The file name exist, please enter unique file name in current directory\n"
      continue
    else
      break
    fi
  done  

  while true; do 
    echo ""
    echo ""
    echo "---------------- [STEP2] Search Options ----------------"
    echo "1) Basic Search 2) Advance Search "
    echo "------------------------------------------------"
    read -p ">> Please enter the search option : " searchoption
    echo -e "\n"
    case $searchoption in 
      1) searchoption="general" 
         break ;;
      2) searchoption="advance" 
         break ;;
      *) echo -e "![Error] Choose the search options above\n";;
    esac
  done 

   
  #Advance search option 
  if [ "$searchoption" = "advance"  ]; then
    advanceyn="Y"
    while true; do
      echo "---------------- [STEP3] Advance Search Options ----------------"
      echo "1) Single File 2) All Files "
      echo "------------------------------------------------"
      read -p ">> Please enter the advance search option : " advanceoption
      case $advanceoption in 
      1) fileoption="single" 
          break ;;
      2) fileoption="all" 
          break ;;
      *) echo -e "![Error] Choose the advance search options above\n";;
      esac
    done                  
    #Advance option for Single File
    if [ "$fileoption" = "single" ]; then 

      echo ">> You selected single option. You can set 3 fields for searching" 
      inputfilelist #List up file list that user can choose for searching    

      while true; do
        read -p ">> Please enter the filename you want to search for : " inputfile
        #outputfilenameyn="Y"
        if ! [ -f ./serv_acc/"$inputfile"  ]; then 
          echo -e "![Error] The file doesn't exist, please enter a correct file name\n"
          continue
        else
          break
        fi
      done 

      #Searching log for Column1
      checkinputcolumn
      columnoption=$?
      columnorder=1
      rangeoption=0
      read -p ">> Please enter the keyword you want to search for : " keyword
      if [ $columnoption = 6 -o  $columnoption = 7 ]; then
        read -p "---------------- Range Options ---------------- `echo $'\n '`1) greater than 2) less than 3) equalto 4) not equalto `echo $'\n '`----------------------------------------------- `echo $'\n '`>> Please enter the range option : " rangeoption
        calculationyn="Y"
      fi
      singfilelesearchlog $columnoption $inputfile $keyword $rangeoption $outputfilename $advanceyn $tmpfilename $columnorder
    

      #Searching log for Column2
      checkinputcolumn
      columnoption=$?
      columnorder=2
      read -p ">> Please enter the keyword you want to search for : " keyword
      if [ $columnoption = 6 -o  $columnoption = 7 ]; then
        read -p "---------------- Range Options ---------------- `echo $'\n '`1) greater than 2) less than 3) equalto 4) not equalto `echo $'\n '`----------------------------------------------- `echo $'\n '`>> Please enter the range option : " rangeoption
        calculationyn="Y"
      fi
      singfilelesearchlog $columnoption $tmpfilename $keyword $rangeoption $outputfilename $advanceyn $tmpfilename $columnorder

      #Searching log for Column3
      checkinputcolumn
      columnoption=$?
      columnorder=3
      read -p ">> Please enter the keyword you want to search for : " keyword
      if [ $columnoption = 6 -o  $columnoption = 7 ]; then
        read -p "---------------- Range Options ---------------- `echo $'\n '`1) greater than 2) less than 3) equalto 4) not equalto `echo $'\n '`----------------------------------------------- `echo $'\n '`>> Please enter the range option : " rangeoption
        calculationyn="Y"
      fi
      singfilelesearchlog $columnoption $tmpfilename $keyword $rangeoption $outputfilename $advanceyn $tmpfilename $columnorder
      if [ "$calculationyn" = "Y" ]; then
        packetbytecal $outputfilename #Invoke the packetbytecal function
      fi 
      echo "$(<$outputfilename)" #Print all the contents of outputfile
    fi
  fi

  echo ">> Search finished!!"
  echo ""


  echo "---------------- Resume Option ----------------"
  echo "If you want to exit search proccess, press 'n', otherwise searching will be resuming"
  echo "------------------------------------------------"
  read -p ">> Do you want to continue searching (y/n) : " continueYN
  echo ""
  echo ""

  if [ "$continueYN" = "n" ]; then 
    break
  fi

  
done  






  #Advance option for Single File
  if [ "$fileoption" = "single" ]; then 

    inputfilelist #List up file list that user can choose for searching    
    while true; do
      read -p ">> Please enter the filename you want to search for : " inputfile
      #outputfilenameyn="Y"
      if ! [ -f ./serv_acc/"$inputfile"  ]; then 
        echo -e "![Error] The file doesn't exist, please enter a correct file name\n"
        continue
      else
        break
      fi
    done 

    echo ">> You selected single option. You can set 3 fields for searching" 

    #Searching log for Column1
    checkinputcolumn
    columnoption=$?
    columnorder=1
    rangeoption=0
    read -p ">> Please enter the keyword you want to search for : " keyword
    if [ $columnoption = 6 -o  $columnoption = 7 ]; then
      read -p "---------------- Range Options ---------------- `echo $'\n '`1) greater than 2) less than 3) equalto 4) not equalto `echo $'\n '`----------------------------------------------- `echo $'\n '`>> Please enter the range option : " rangeoption
      calculationyn="Y"
    fi
    singfilelesearchlog $columnoption $inputfile $keyword $rangeoption $outputfilename $advanceyn $tmpfilename $columnorder
   

    #Searching log for Column2
    checkinputcolumn
    columnoption=$?
    columnorder=2
    read -p ">> Please enter the keyword you want to search for : " keyword
    if [ $columnoption = 6 -o  $columnoption = 7 ]; then
      read -p "---------------- Range Options ---------------- `echo $'\n '`1) greater than 2) less than 3) equalto 4) not equalto `echo $'\n '`----------------------------------------------- `echo $'\n '`>> Please enter the range option : " rangeoption
      calculationyn="Y"
    fi
    singfilelesearchlog $columnoption $tmpfilename $keyword $rangeoption $outputfilename $advanceyn $tmpfilename $columnorder

    #Searching log for Column3
    checkinputcolumn
    columnoption=$?
    columnorder=3
    read -p ">> Please enter the keyword you want to search for : " keyword
    if [ $columnoption = 6 -o  $columnoption = 7 ]; then
      read -p "---------------- Range Options ---------------- `echo $'\n '`1) greater than 2) less than 3) equalto 4) not equalto `echo $'\n '`----------------------------------------------- `echo $'\n '`>> Please enter the range option : " rangeoption
      calculationyn="Y"
    fi
    singfilelesearchlog $columnoption $tmpfilename $keyword $rangeoption $outputfilename $advanceyn $tmpfilename $columnorder
    if [ "$calculationyn" = "Y" ]; then
      packetbytecal $outputfilename #Invoke the packetbytecal function
    fi 
    echo "$(<$outputfilename)" #Print all the contents of outputfile

  #Advance option for All Files
  else 
    checkinputcolumn
    columnoption=$?
    read -p ">> Please enter the keyword you want to search for : " keyword
    if [ $columnoption4 = 6 -o  $columnoption4 = 7 ]; then
      read -p "---------------- Range Options ---------------- `echo $'\n '`1) greater than 2) less than 3) equalto 4) not equalto `echo $'\n '`----------------------------------------------- `echo $'\n '`>> Please enter the range option : " rangeoption
      calculationyn="Y"
    fi

    for file in ./serv_acc/*
    do
      allfilesearchlog $columnoption $file $keyword $rangeoption
    done
    if [ "$calculationyn" = "Y" ]; then
      packetbytecal $outputfilename #Invoke the packetbytecal function
    fi 
  fi

#Basic search option 
else 
  advanceyn="N" # Set the variable advanceyn to "N" (Basic Search Option)
  inputfilelist # Invoke the function inputfilelist for listing up file list that user can choose for searching 
  read -p ">> Please enter the filename you want to search for : " inputfile # prompt the user for one inputfile name among log files
  
  checkinputcolumn # Invoke checkinputcolumn function to get the column for search from user
  columnoption=$? # Save the chosen column as the variable columnoption
  rangeoption=0
  read -p ">> Please enter the keyword you want to search for : " keyword # prompt the user for the keyword relevant to the chosen field
  if [ $columnoption = 6 -o  $columnoption = 7 ]; then
    echo ">> You selected range column, please choose range options"
    read -p "---------------- Range Options ---------------- `echo $'\n '`1) greater than 2) less than 3) equalto 4) not equalto `echo $'\n '`----------------------------------------------- `echo $'\n '`>> Please enter the range option : " rangeoption
    calculationyn="Y"
  fi
  columnorder=1
  #Invoke the singfilelesearchlog for searching log with input parameters
  # 1.Field, 2.Inputfile, 3.Keyword, 4.Rangeoption, 5.Outputfile, 6.AdvancedYN, 7.Tempfilename, 8.Order of Chosen Fileds(Adavnce)
  singfilelesearchlog $columnoption $inputfile $keyword $rangeoption $outputfilename $advanceyn $tmpfilename $columnorder
  if [ "$calculationyn" = "Y" ]; then #If the column is packet or bytes, calculate the total number of each column and save and print it
      packetbytecal $outputfilename #Invoke the packetbytecal function
  fi 
  echo "$(<$outputfilename)" #Print all the contents of outputfile
fi

echo "Searching process finished, the output file is saved in $outputfilename"

exit 0









