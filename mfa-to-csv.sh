#!/bin/bash

#----------------------------------------------------

#AUTHOR: Andrew Buultjens

#ABOUT:
#Converts a multi fasta alignment into a csv file with header and index columns

#USAGE:
# sh mfa-to-csv.sh [ALIGNMENT] [fofn.txt] [OUTFILE]

#----------------------------------------------------

ALIGNMENT=${1}
OUTFILE=${3}

#----------------------------------------------------

# generate random prefix for all tmp files
RAND_1=`echo $((1 + RANDOM % 100))`
RAND_2=`echo $((100 + RANDOM % 200))`
RAND_3=`echo $((200 + RANDOM % 300))`
RAND=`echo "${RAND_1}${RAND_2}${RAND_3}"`

#----------------------------------------------------

samtools faidx ${ALIGNMENT}
echo "INDEX" > ${RAND}_fofn.txt

#----------------------------------------------------

if ls ${OUTFILE} 1> /dev/null 2>&1; then
	rm ${OUTFILE}
fi

#----------------------------------------------------

for TAXA in $(cat $2); do


	samtools faidx ${ALIGNMENT} ${TAXA} | grep -v ">" | tr -d '\n' >> ${RAND}_tmp1.txt
	echo '' >> ${RAND}_tmp1.txt

	echo "${TAXA}" >> ${RAND}_fofn.txt

done

#----------------------------------------------------

tr '-' 'N' < ${RAND}_tmp1.txt | sed 's/./&,/g' > ${RAND}_tmp2.txt

#----------------------------------------------------

# get len of aln
LEN=`head -1 ${RAND}_tmp2.txt | tail -1 | tr ',' '\n' | wc -l | awk '{print $1}'`
ONE=1
let COUNT=${LEN}-${ONE}

seq 1 ${COUNT} | tr '\n' ',' > ${RAND}_seq_1-${LEN}.tr.csv
echo '' >> ${RAND}_seq_1-${LEN}.tr.csv

#----------------------------------------------------

cat ${RAND}_seq_1-${LEN}.tr.csv ${RAND}_tmp2.txt | sed 's/.$//' > ${RAND}_tmp3.txt
paste ${RAND}_fofn.txt ${RAND}_tmp3.txt | tr '\t' ',' > ${OUTFILE}

#----------------------------------------------------

rm ${RAND}_fofn.txt
rm ${RAND}_tmp1.txt
rm ${RAND}_tmp2.txt
rm ${RAND}_tmp3.txt
rm ${RAND}_seq_1-${LEN}.tr.csv

#----------------------------------------------------



		