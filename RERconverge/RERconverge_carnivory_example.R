library(RERconverge)

# Read in gene trees
mammalia.trees <- readTrees(file"path/to/genetrees.txt", minTreesAll = 60)

# Read in diet data
diet.data <- read.csv("carnivory_scores.csv")
diet.value.mammalia <- diet.data$carnivory_score
names(diet.value.mammalia) <- diet.data$species

# Estimate RERs
RER.mammalia <- getAllResiduals(mammalia.trees, transform = "sqrt", weighted = T, scale = T, min.sp=60)

# Correlate RERs with carnivory score
charpaths=char2Paths(diet.value.mammalia, mammalia.trees)

res=correlateWithContinuousPhenotype(RER.mammalia, charpaths, min.sp = 60, 
                                     winsorizeRER = 3, winsorizetrait = 3)
stats=getStat(res)

# Read in gene sets
# (in this example, gene sets = gene pathways from MSigDB)
# (gene sets made for this study are in the CustomGeneSets folder)
annots=read.gmt("c2.all.v7.5.1.symbols.gmt") # file source = MSigDB
annotlist=list(annots)
names(annotlist)="MSigDBpathways"

# Subset pathway database to only REACTOME and KEGG databases #
annotlist$MSigDBpathways$genesets <- annotlist$MSigDBpathways$genesets[grep(paste(c("REACTOME", "KEGG"),collapse="|"), annotlist$MSigDBpathways$geneset.names)]
annotlist$MSigDBpathways$geneset.names <- annotlist$MSigDBpathways$geneset.names[grep(paste(c("REACTOME", "KEGG"),collapse="|"), annotlist$MSigDBpathways$geneset.names)]
annotlist$MSigDBpathways$geneset.descriptions <- annotlist$MSigDBpathways$geneset.descriptions[grep(paste(c("REACTOME", "KEGG"),collapse="|"), annotlist$MSigDBpathways$geneset.names)]

# Run enrichment analysis
enrichment=fastwilcoxGMTall(stats, annotlist, outputGeneVals=T, num.g=10)

# Run permulations
# First, extract masterTree from mammalia.trees and make sure the outgroup is set correctly
mt=mammalia.trees$masterTree
mt=root.phylo(mt, outgroup=c("Monodelphis_domestica", "Sarcophilus_harrisii", "Antechinus_flavipes", "Phalanger_gymnotis", "Macropus_fuliginosus", "Gymnobelideus_leadbeateri"), resolve.root=T)

# Second, run permulations
perms=RERconverge::getPermsContinuous(100000, diet.value.mammalia, RER.mammalia, annotlist, calculateenrich = T, trees = mammalia.trees, mastertree = mt, winR = 3, winT = 3)
corpermpvals=RERconverge::permpvalcor(res, perms)
enrichpermpvals=RERconverge::permpvalenrich(enrichment, perms)

# Add permulations to real results
res$permpval=corpermpvals[match(rownames(res), names(corpermpvals))]
res$permpvaladj=p.adjust(res$permpval, method="BH")

count=1
while(count<=length(enrichment)){
  enrichment[[count]]$permpval=enrichpermpvals[[count]][match(rownames(enrichment[[count]]),
                                                              names(enrichpermpvals[[count]]))]
  enrichment[[count]]$permpvaladj=p.adjust(enrichment[[count]]$permpval, method="BH")
  count=count+1
}

