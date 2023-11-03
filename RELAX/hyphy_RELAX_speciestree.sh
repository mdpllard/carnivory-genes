#!/bin/bash

# Requires a list of genes in a text file
# Requires a directory of gene alignments in fasta format, with species names as headers


while read GENE
do
  NAME=$(echo "$GENE" | sed 's/.fa//g')
  
# get list of species in alignment  
  cat /path/to/alignments/$NAME.fa | grep ">" | sed 's/>//g' > $NAME.carnivory.species_list.txt
  
# make R script that will prune any species in the species tree that are missing from the alignment
  printf 'library(ape) \n' >> $NAME.carnivory.prune.R
  printf 'tre<-read.tree("mammalia_carnivory_species.tre") \n' >> $NAME.carnivory.prune.R
  printf 'tip<-scan("%s.carnivory.species_list.txt", character()) \n' $NAME >> $NAME.carnivory.prune.R
  printf 'tre <- drop.tip(tre, tre$tip.label[-match(tip, tre$tip.label)]) \n' >> $NAME.carnivory.prune.R
  printf 'write.tree(tre, file = "%s.carnivory.species_tree_pruned.tre") \n' $NAME >> $NAME.carnivory.prune.R
  
  Rscript $NAME.carnivory.prune.R
  
# set certain species as foreground (in this example, the most carnivorous species)
  cat $NAME.carnivory.species_tree_pruned.tre | sed 's/Canis_lupus/Canis_lupus{test}/g' | sed 's/Cryptoprocta_ferox/Cryptoprocta_ferox{test}/g' | sed 's/Mustela_putorius/Mustela_putorius{test}/g' | sed 's/Lutra_lutra/Lutra_lutra{test}/g' | sed 's/Felis_catus/Felis_catus{test}/g' | sed 's/Ursus_maritimus/Ursus_maritimus{test}/g' | sed 's/Zalophus_californianus/Zalophus_californianus{test}/g' | sed 's/Suricata_suricatta/Suricata_suricatta{test}/g' | sed 's/Antechinus_flavipes/Antechinus_flavipes{test}/g' | sed 's/Balaenoptera_edeni/Balaenoptera_edeni{test}/g' | sed 's/Carlito_syrichta/Carlito_syrichta{test}/g' | sed 's/Dasypus_novemcinctus/Dasypus_novemcinctus{test}/g' | sed 's/Manis_javanica/Manis_javanica{test}/g' | sed 's/Megaderma_lyra/Megaderma_lyra{test}/g' | sed 's/Microgale_talazaci/Microgale_talazaci{test}/g' | sed 's/Molossus_molossus/Molossus_molossus{test}/g' | sed 's/Noctilio_leporinus/Noctilio_leporinus{test}/g' | sed 's/Onychomys_torridus/Onychomys_torridus{test}/g' | sed 's/Pipistrellus_pipistrellus/Pipistrellus_pipistrellus{test}/g' | sed 's/Pteronotus_parnellii/Pteronotus_parnellii{test}/g' | sed 's/Sarcophilus_harrisii/Sarcophilus_harrisii{test}/g' | sed 's/Sorex_araneus/Sorex_araneus{test}/g' | sed 's/Tamandua_tetradactyla/Tamandua_tetradactyla{test}/g' | sed 's/Tonatia_saurophila/Tonatia_saurophila{test}/g' | sed 's/Tupaia_belangeri/Tupaia_belangeri{test}/g' | sed 's/Tursiops_truncatus/Tursiops_truncatus{test}/g' > $NAME.carnivory.tre  
  
  hyphy relax --alignment /path/to/alignments/$NAME.fa --tree $NAME.carnivory.tre --test test --output $NAME.json
  
  rm $NAME.carnivory.tre
  rm $NAME.carnivory.species_tree_pruned.tre
  rm $NAME.carnivory.species_list.txt
  rm $NAME.carnivory.prune.R

done < /path/to/list_of_genes.txt