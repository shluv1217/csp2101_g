#!/bin/bash
#Name : Sunghoon Shin (David)
#Student Number : 10529950

checkinputfield(){

  while true; do 
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
    local fieldoption=0
    read -p ">> Please enter the column you want to search for : " field
    case $field in 
      1) fieldoption=1
         break ;;
      2) fieldoption=2
         break ;;
      3) fieldoption=3
         break ;;
      4) fieldoption=4
         break ;;
      5) fieldoption=5
        break ;;
      6) fieldoption=6
        break ;;
      7) fieldoption=7
        break ;;
      8) fieldoption=8
        break ;;
      *) echo -e "![Error] Choose option among above selection\n";;
    esac           
  done 
  return $fieldoption
}


checkrangeoption(){
   echo ">> You selected range column, please choose range options"

  while true; do 
    echo ""
    echo ""
    echo "---------------- [Range Options] ----------------"
    echo "1) Greater Than" 
    echo "2) Less Than" 
    echo "3) Equal To" 
    echo "4) Not Equal To"   
    echo "------------------------------------------------"
    local rangeoption=0
    read -p ">> Please enter the field you want to search for : " range
    case $range in 
      1) rangeoption=1
         break ;;
      2) rangeoption=2
         break ;;
      3) rangeoption=3
         break ;;
      4) rangeoption=4
         break ;;
      *) echo -e "![Error] Choose option among above selections\n";;
    esac           
  done 
  return $rangeoption
}


singfilelesearchlog(){ #single file search function
  
  echo "Params : $1,$2,$3,$4,$5,$6,$7,$8,$9"

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
  esac

  logvalue="$(echo -e "${value}" | tr -d '[:space:]')"
  keywordvalue="$(echo -e "$3" | tr -d '[:space:]')"
  class="$(echo -e "$CLASS" | tr -d '[:space:]')"


  if [ ! "$class" = "normal" ];then # Any log file records in which the CLASS field is set to normal are to be filtered
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
  done < <(tail -n +2 $2) > $5
  IFS=$OLDIFS

  
  if [ "$9" = "N" -a $8 = 1 ];then #advance all file option first file
    { echo -e "DATE,DURATION,PROTOCOL,SRCIP,SRCPORT,DESTIP,DESTPORT,PACKETS,BYTES,FLOWS,FLAGS,TOS,CLASS"; cat $5; } > $7
  elif [ "$9" = "N" -a ! $8 = 1 ];then #advance all file option not first file
    { cat $5; } >> $7
  else #advance single file, basic option
    { echo -e "DATE,DURATION,PROTOCOL,SRCIP,SRCPORT,DESTIP,DESTPORT,PACKETS,BYTES,FLOWS,FLAGS,TOS,CLASS"; cat $5; } > $7
  fi

}


inputfilelist(){
    echo ""
    echo ""
    echo "---------------- [Log File List] ----------------"
    for entry in "$searchdir"/*
    do
      echo "$entry"
    done
    echo "--------------------------------------------"
}


packetbytecal(){
  awk -F "," '{PacketTotal=PacketTotal+$8} END{print "PacketTotal : " PacketTotal}' $1 >> $1
  awk -F "," '{BytesTotal=BytesTotal+$9} END{print "BytesTotal : " BytesTotal}' $1 >> $1
}



#Main 
while true; do
  paramInputfile=""
  searchoption=""
  fieldoption=0
  rangeoption=0
  searchorder=0
  fileoption=""
  calculationyn="N"
  singlefileyn="Y"
  advanceyn=""
  searchdir="./serv_acc/" # set log location directory "./serv_acc" to the variable searchdir
  tmpfilename="temp.csv"

  echo "---------------- [Begin Search Process] ----------------"
  echo ""
  echo ""
  #Check whether the file selected by user exists and save the output file name as outputfilename
  while true; do
    echo "---------------- [Outputfile] ----------------"
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
    echo "---------------- [Search Options] ----------------"
    echo "1) Basic Search 2) Advance Search "
    echo "------------------------------------------------"
    read -p ">> Please enter the search option : " searchoption
    echo -e "\n"
    case $searchoption in 
      1) searchoption="general" 
         break ;;
      2) searchoption="advance" 
         break ;;
      *) echo -e "![Error] Choose search option among above selections\n";;
    esac
  done 

   
  #Advance search option 
  if [ "$searchoption" = "advance"  ]; then
    advanceyn="Y"
    while true; do
      echo "---------------- [Advance Search Options] ----------------"
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

      echo ">> You selected a single file option. You can set maximum three(3) fields for searching" 
      inputfilelist #List up file list that user can choose for searching    

      while true; do
        read -p ">> Please enter the filename you want to search for : " inputfile
        if ! [ -f ./serv_acc/"$inputfile"  ]; then 
          echo -e "![Error] The file doesn't exist, please enter a correct file name\n"
          continue
        else
          break
        fi
      done 

      while true; do
        checkinputfield
        fieldoption=$?
        searchorder=$((searchorder+1)) 
        paramInputfile="./serv_acc/$inputfile"
        if [ $fieldoption = 6 -o  $fieldoption = 7 ]; then
            checkrangeoption
            rangeoption=$?
            calculationyn="Y"
        fi
        read -p ">> Please enter the keyword you want to search for : " keyword

        if  [ $searchorder = 1  ]; then
          echo "---------------- [Processing.....] ----------------"
          singfilelesearchlog $fieldoption $paramInputfile $keyword $rangeoption $tmpfilename $advanceyn $outputfilename $searchorder $singlefileyn       
        else 
          singfilelesearchlog $fieldoption $outputfilename $keyword $rangeoption $tmpfilename $advanceyn $outputfilename $searchorder $singlefileyn
        fi


        if ! [ $searchorder = 3  ]; then
          read -p ">> Do you want to add more field for the current search (y/n)? : " morefieldYN
          if [ "$morefieldYN" = "y"  ]; then 
            continue      
          else
            break
          fi
        else
            break
        fi
      done 
      
      if [ "$calculationyn" = "Y" ]; then
        packetbytecal $outputfilename #Invoke the packetbytecal function
      fi 
      echo "$(<$outputfilename)" #Print all the contents of outputfile
    
    #Advance option for All Files
    else 
      checkinputfield
      fieldoption=$?
      if [ $fieldoption = 6 -o  $fieldoption = 7 ]; then
            checkrangeoption
            rangeoption=$?
            calculationyn="Y"
      fi
      read -p ">> Please enter the keyword you want to search for : " keyword
      singlefileyn="N"
      
      echo ""
      echo ""
      echo "---------------- [Processing.....] ----------------"
      

      for inputfile in ./serv_acc/*
      do
        searchorder=$((searchorder+1))
        singfilelesearchlog $fieldoption $inputfile $keyword $rangeoption $tmpfilename $advanceyn $outputfilename $searchorder $singlefileyn
      done
      if [ "$calculationyn" = "Y" ]; then
        packetbytecal $outputfilename #Invoke the packetbytecal function
      fi 
    fi

  #Basic search option 
  else 
    advanceyn="N" # Set the variable advanceyn to "N" (Basic Search Option)
    singfileyn="N" # Set the variable singfileyn to "N" 
    inputfilelist # Invoke the function inputfilelist for listing up file list that user can choose for searching 
    while true; do
      read -p ">> Please enter the filename you want to search for : " inputfile
      #outputfilenameyn="Y"
      if ! [ -f ./serv_acc/"$inputfile"  ]; then 
        echo -e "![Error] The file doesn't exist, please enter a correct file name\n"
        inputfilelist
        continue
      else
        break
      fi
    done  
    checkinputfield # Invoke checkinputfield function to get the column for search from user
    fieldoption=$? # Save the chosen column as the variable fieldoption
    if [ $fieldoption = 6 -o  $fieldoption = 7 ]; then
      checkrangeoption
      rangeoption=$?
      calculationyn="Y"
    fi

    read -p ">> Please enter the keyword you want to search for : " keyword # prompt the user for the keyword relevant to the chosen field
    paramInputfile="./serv_acc/$inputfile"
    searchorder=1

    #Invoke the singfilelesearchlog for searching log with input parameters
    # 1.Field, 2.Inputfile, 3.Keyword, 4.Rangeoption, 5.Outputfile, 6.AdvancedYN, 7.Tempfilename, 8.Order of Chosen Fileds(Adavnce)
    echo ""
    echo ""
    echo "---------------- [Processing.....] ----------------"
    singfilelesearchlog $fieldoption $paramInputfile $keyword $rangeoption $tmpfilename $advanceyn $outputfilename $searchorder $singlefileyn
    if [ "$calculationyn" = "Y" ]; then #If the column is packet or bytes, calculate the total number of each column and save and print it
        packetbytecal $outputfilename #Invoke the packetbytecal function
    fi 
    echo "$(<$outputfilename)" #Print all the contents of outputfile 
  fi # Gerneral/Advance Option Closing


  rm $tmpfilename # Delete temporal file after search job is finished
  echo ">> Search finished, please check the result in $outputfilename!!"
  echo ""


  echo "---------------- Resume Option ----------------"
  echo "If you want to exit search proccess, press 'n' "
  echo ", otherwise searching will be resuming"
  echo "------------------------------------------------"
  read -p ">> Do you want to continue searching (y/n)? : " continueYN
  echo ""
  echo ""

  if [ "$continueYN" = "n" ]; then 
    echo "---------------- Thank you for searching, Goody Bye!! ----------------"
    echo ""
    echo ""
    break
  fi
  
done 

exit 0



















