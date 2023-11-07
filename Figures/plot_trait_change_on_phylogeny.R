#### Example code to find change in trait on each branch of a phylogeny ####
#Using RERconverge to convert a continuous paths object to a tree
#Example using data from the online RERconverge walkthrough (i.e., not data from this study)
library(RERconverge)
rerpath=find.package('RERconverge')
toytreefile="subsetMammalGeneTrees.txt"
toyTrees=readTrees(paste(rerpath,"/extdata/",toytreefile,sep=""),max.read=200)

#Creating the paths vector - contains inferred changes on all possible paths
#through the master tree
charpaths=char2Paths(logAdultWeightcm,toyTrees)

#The "report" within the trees object shows which species are present in which
#gene tree. We want to find a gene tree with all species present.
toyTrees$maxSp #62 species total

head(rowSums(toyTrees$report))

# CEP290         DNAH5         DNAH6         DNAH7         DNAH9 Em:AC008101.5 
#62            62            62            60            60            49 

#To use plotRersAsTree, we need an index for a gene with all species present.
#Then we need to make a matrix with at least as many rows as the gene index.
#Here let's use the 3rd gene.
geneindex = 3
pathsmat <- matrix(replicate(geneindex, charpaths), nrow=geneindex, byrow=TRUE)

#Now we can use the plotRersAsTree function to extract the relevant columns
#from this matrix and use them as branch lengths on a tree.
charpathstree <- returnRersAsTree(toyTrees, pathsmat,
                                  index=geneindex)


#### Example code to plot change in trait using a heatmap color scheme ####
# The branches of charpathstree (see above) represent change in the trait of interest
# We want to color the branches with those values, but we do not want the branch lengths to be based on them
# So I will color the branches of one tree based on the branch lengths of another

# Using the walkthrough data, one of the species included in the trees doesn't have trait data
# This means that charpathstree has branch lengths of NA because that species is still included in the phylogeny
# For the purposes of this example, I will replace the NA branch lengths with the median branch length
# This was not a problem for the data in our study, so this step was not necessary
charpathstree$edge.length[is.na(charpathstree$edge.length)] <- median(charpathstree$edge.length, na.rm=TRUE)

# Extract the master tree from toyTrees (should be same topology as charpathstree, but with appropriate branch lengths)
mt <- toyTrees$masterTree

# Ensure that mt topology matches charpathstree by rotating the trees in a cophylo
cophylo.trees <- cophylo(charpathstree, mt)

# plot change in trait (from charpathstree) to tree with reasonable branch lengths (mt)
library(viridis)
colors.viridis <- colorRampPalette(magma(n=100))
plotBranchbyTrait(cophylo.trees$trees[[2]], cophylo.trees$trees[[1]]$edge.length, palette = colors.viridis)