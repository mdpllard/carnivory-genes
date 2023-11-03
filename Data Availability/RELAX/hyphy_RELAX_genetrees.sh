#!/bin/bash

# Requires a list of genes in a text file
# Requires a directory of gene alignments in fasta format, with species names as headers
# Requires a directory of gene trees (produced by RAxML--see RAxML_gene_trees code)

while read GENE
do
  NAME=$(echo "$GENE" | sed 's/.fa//g')
  
# set certain species as foreground (in this example, the most carnivorous species)
  cat /path/to/RAxML_gene_trees/$NAME.tre | sed 's/Canis_lupus/Canis_lupus{test}/g' | sed 's/Cryptoprocta_ferox/Cryptoprocta_ferox{test}/g' | sed 's/Mustela_putorius/Mustela_putorius{test}/g' | sed 's/Lutra_lutra/Lutra_lutra{test}/g' | sed 's/Felis_catus/Felis_catus{test}/g' | sed 's/Ursus_maritimus/Ursus_maritimus{test}/g' | sed 's/Zalophus_californianus/Zalophus_californianus{test}/g' | sed 's/Suricata_suricatta/Suricata_suricatta{test}/g' | sed 's/Antechinus_flavipes/Antechinus_flavipes{test}/g' | sed 's/Balaenoptera_edeni/Balaenoptera_edeni{test}/g' | sed 's/Carlito_syrichta/Carlito_syrichta{test}/g' | sed 's/Dasypus_novemcinctus/Dasypus_novemcinctus{test}/g' | sed 's/Manis_javanica/Manis_javanica{test}/g' | sed 's/Megaderma_lyra/Megaderma_lyra{test}/g' | sed 's/Microgale_talazaci/Microgale_talazaci{test}/g' | sed 's/Molossus_molossus/Molossus_molossus{test}/g' | sed 's/Noctilio_leporinus/Noctilio_leporinus{test}/g' | sed 's/Onychomys_torridus/Onychomys_torridus{test}/g' | sed 's/Pipistrellus_pipistrellus/Pipistrellus_pipistrellus{test}/g' | sed 's/Pteronotus_parnellii/Pteronotus_parnellii{test}/g' | sed 's/Sarcophilus_harrisii/Sarcophilus_harrisii{test}/g' | sed 's/Sorex_araneus/Sorex_araneus{test}/g' | sed 's/Tamandua_tetradactyla/Tamandua_tetradactyla{test}/g' | sed 's/Tonatia_saurophila/Tonatia_saurophila{test}/g' | sed 's/Tupaia_belangeri/Tupaia_belangeri{test}/g' | sed 's/Tursiops_truncatus/Tursiops_truncatus{test}/g' > $NAME.carnivory.tre  
  
  hyphy relax --alignment /path/to/alignments/$NAME.fa --tree $NAME.carnivory.tre --test test --output $NAME.json
  
  rm $NAME.carnivory.tre
  
done < /path/to/list_of_genes.txt
