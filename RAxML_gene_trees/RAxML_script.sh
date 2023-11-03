#!/bin/bash

# make sure to be in the directory with the gene alignments
cd /path/to/alignments/

# for loop to make a gene tree for each gene
for FILE in *.fa
do

  NAME=$(echo "$FILE" | sed 's/.fa//g')

  raxmlHPC -s $FILE -n $NAME -m GTRGAMMAI -w /path/to/tmp/ -p 123
  mv /path/to/tmp/RAxML_bestTree.* /path/to/final_directory/$NAME.tre
  rm /path/to/tmp/*

done