#!/bin/bash

# show 80 newest cases first,  provide option to view older,   grouped into pages of 80
#PAGE_CASES=92  # full page
PAGE_CASES=44 
CASES="/home/lowk/cases"

function display_batch(){
   select DATE in "${DATES[@]}"
   do
      counter=0
      while [ "${DATE}" != "${DATES[${counter}]}" ]
      do
         counter=$((counter+1))
      done
      p_end=${BATCHES[${counter}]}
      p_begin=$((p_end - PAGE_CASES))
      if [ "${p_begin}" -lt "1" ]
      then
         p_begin=1
      fi
      break
   done
}

function break_down_cases(){
   CASES_GROUPED=${PAGE_CASES}
   counter=0
   while [ "${older_cases}" -gt "0" ]
   do
      BATCHES[counter]="${older_cases}"
      newest=`ls -Ftr -- ${CASES}| grep / | head -n -${CASES_GROUPED} | tail -1`
      MODDATE=$(stat -c %y "${CASES}/${newest}")
      DATES[counter]=${MODDATE%% *}
      counter=$((counter+1))
      CASES_GROUPED=$((CASES_GROUPED+PAGE_CASES))
      older_cases=`ls -Ftr -- ${CASES} | grep / | head -n -${CASES_GROUPED}|wc -l`
   done
   display_batch
}

#touch ~/cases/OLDER
touch ${CASES}/OLDER
clear
select DIR in `ls -Ftr -- ${CASES} | grep / | tail -${PAGE_CASES}`
do
   if [ "${DIR}" == "OLDER/" ]
   then
      clear
      echo -e "\t\t\t\tOLDER CASES"
      older_cases=`ls -Ftr -- ${CASES} | grep / | head -n -${PAGE_CASES}|wc -l`
      if [ "${older_cases}" -gt ${PAGE_CASES} ]
      then
            break_down_cases
            select DIR in `ls -Ftr -- ${CASES} | grep / | sed -n "${p_begin},${p_end}p"`
            do
               break
            done
      else
         select DIR in `ls -Ftr -- ${CASES} | grep / | head -n -${PAGE_CASES}`
         do
            break
         done
      fi
   else
      true
   fi 
   break
done

echo ${DIR}
