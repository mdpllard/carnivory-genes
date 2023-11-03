#!/bin/bash

# Requires a list of genes in a text file
# Requires a directory of gene alignments in fasta format, with species names as headers
# Requires a directory of gene trees (produced by RAxML--see RAxML_gene_trees code)

while read GENE
do
  NAME=$(echo "$GENE" | sed 's/.fa//g')

# set certain species as foreground (in this example, the most carnivorous species)
  cat /path/to/RAxML_gene_trees/$NAME.tre | sed 's/Canis_lupus/Canis_lupus{Foreground}/g' | sed 's/Cryptoprocta_ferox/Cryptoprocta_ferox{Foreground}/g' | sed 's/Mustela_putorius/Mustela_putorius{Foreground}/g' | sed 's/Lutra_lutra/Lutra_lutra{Foreground}/g' | sed 's/Felis_catus/Felis_catus{Foreground}/g' | sed 's/Ursus_maritimus/Ursus_maritimus{Foreground}/g' | sed 's/Zalophus_californianus/Zalophus_californianus{Foreground}/g' | sed 's/Suricata_suricatta/Suricata_suricatta{Foreground}/g' | sed 's/Antechinus_flavipes/Antechinus_flavipes{Foreground}/g' | sed 's/Balaenoptera_edeni/Balaenoptera_edeni{Foreground}/g' | sed 's/Carlito_syrichta/Carlito_syrichta{Foreground}/g' | sed 's/Dasypus_novemcinctus/Dasypus_novemcinctus{Foreground}/g' | sed 's/Manis_javanica/Manis_javanica{Foreground}/g' | sed 's/Megaderma_lyra/Megaderma_lyra{Foreground}/g' | sed 's/Microgale_talazaci/Microgale_talazaci{Foreground}/g' | sed 's/Molossus_molossus/Molossus_molossus{Foreground}/g' | sed 's/Noctilio_leporinus/Noctilio_leporinus{Foreground}/g' | sed 's/Onychomys_torridus/Onychomys_torridus{Foreground}/g' | sed 's/Pipistrellus_pipistrellus/Pipistrellus_pipistrellus{Foreground}/g' | sed 's/Pteronotus_parnellii/Pteronotus_parnellii{Foreground}/g' | sed 's/Sarcophilus_harrisii/Sarcophilus_harrisii{Foreground}/g' | sed 's/Sorex_araneus/Sorex_araneus{Foreground}/g' | sed 's/Tamandua_tetradactyla/Tamandua_tetradactyla{Foreground}/g' | sed 's/Tonatia_saurophila/Tonatia_saurophila{Foreground}/g' | sed 's/Tupaia_belangeri/Tupaia_belangeri{Foreground}/g' | sed 's/Tursiops_truncatus/Tursiops_truncatus{Foreground}/g' > $NAME.tre  
  
# run BUSTED
  hyphy busted --alignment /path/to/alignments/$NAME.fa --tree $NAME.tre --branches Foreground --output $NAME.json
  
  rm $NAME.tre
  
done < /path/to/list_of_genes.txt
