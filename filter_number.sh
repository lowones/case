#!/bin/bash


CASES="/home/lowk/cases"
filter='*'

num_regx='^[0-9]+$'
CURRENT_DIR=${PWD}

if [ "$#" -gt 1 ];
then
   echo -e "\nUsage: ${FUNCNAME[0]} CASE_NAME (optional)\n\n"
   return 1
elif [ "$#" -eq 1 ]
then
   if [[ ${1} =~ ${num_regx} ]];
   then
      if [ "${1}" -lt 1000000 ];
      then
         echo "filter"
         filter="*${1}*"
      fi
   fi
fi

cd ${CASES}
ls -dFtr ${filter} 
cd ${CURRENT_DIR}
