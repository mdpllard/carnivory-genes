#!/bin/bash

# Requires a directory of gene alignments in fasta format, with species names as headers

# Run codeml via BASE on gene alignments using the species tree
# (if you want to use gene trees instead, replace "--s_tree mammalia_species.nwk" with "--g_tree"

sh ./BASE.sh --analyze --input path/to/alignments/ --output output_branch_site/ --s_tree mammalia_species.nwk --cores 40 --model_g codeml_null.ctl --model_a codeml_alternate.ctl --labels tag_branch_site.label --labels_2 tag_branch_site.label --replicates 10

# Extract the output
sh ./BASE.sh --extract --input output_branch_site/ --labels clade_of_interest.label --min_spp 60