#!/bin/bash

# Requires a directory of gene alignments in fasta format, with species names as headers

# Run codeml via BASE on gene alignments using the species tree
# Foreground species must be removed from the alignments and tree
# (if you want to use gene trees instead, replace "--s_tree mammalia_species.nwk" with "--g_tree"

sh ./BASE_test.sh --analyze --input path/to/alignments_background/ --output output_site/ --s_tree mammalia_species_treewide.nwk --cores 40 --model_g codeml_m1.ctl --model_a codeml_m2.ctl --replicates 10