#### Gene Volcano Plot ####
library(qvalue)
library(ggforce)
library(scales
rerconverge_genes <- read.csv(file="~/path/to/RERconverge_gene_results.csv")

# add small value to SLC13A2 and SLC14A2 permpvals to make them non-zero, then rerun q-value function
rerconverge_genes[1:2,]$permpval <- 0.000001
rerconverge_genes$permqval <- qvalue(rerconverge_genes$permpval)$qvalues
rerconverge_genes$significant <- 0; rerconverge_genes$significant[which(rerconverge_genes$permqval<0.05)] <- 1

rerconverge_genes$color <- "gray"; rerconverge_genes$color[which(rerconverge_genes$significant==1 & rerconverge_genes$Rho > 0)] <- "#5E4FA2";rerconverge_genes$color[which(rerconverge_genes$significant==1 & rerconverge_genes$Rho < 0)] <- "#9E0142"
rerconverge_genes$shape <- 1; rerconverge_genes$shape[which(rerconverge_genes$significant==1)] <- 19

reverselog_trans <- function(base = exp(1)) {
  trans <- function(x) -log(x, base)
  inv <- function(x) base^(-x)
  trans_new(paste0("reverselog-", format(base)), trans, inv, 
            log_breaks(base = base), 
            domain = c(1e-100, Inf))
}

p <- ggplot(data=rerconverge_genes, aes(x=Rho, y=permqval)) +
  geom_point(size = 4, alpha = 0.75, color=rerconverge_genes$color, shape=rerconverge_genes$shape) +
  theme_classic() +
  scale_y_continuous(trans=reverselog_trans(10)) + coord_cartesian(xlim = c(-0.45, 0.45)) +
  xlab("Rho") + ylab("q-value") + geom_hline(aes(yintercept=0.05), linetype="dashed")
p


#### Enrichment Volcano Plots ####
library(ggplot2)
library(qvalue)

rerconverge_tissues <- read.csv(file="~/path/to/tissue_enrichment_results.csv")
rerconverge_tissues$slow <- "Carnivore Slow"; rerconverge_tissues$slow[which(rerconverge_tissues$stat>0)] <- "Herbivore Slow"
rerconverge_tissues$dataset <- "Tissues"

rerconverge_pathways <- read.csv(file="~/path/to/pathway_enrichment_results.csv")[,1:8]
# add small value to Biologival Oxidations permpval to make them non-zero, then rerun q-value function
rerconverge_pathways[which(rerconverge_pathways$X == "REACTOME_BIOLOGICAL_OXIDATIONS"),]$permpval <- 0.00001
rerconverge_pathways$permqval <- qvalue(rerconverge_pathways$permpval)$qvalues
rerconverge_pathways$slow <- "Carnivore Slow"; rerconverge_pathways$slow[which(rerconverge_pathways$stat>0)] <- "Herbivore Slow"
rerconverge_pathways$dataset <- "Gene Pathways"

rerconverge_phenotypes <- read.csv(file="~/path/to/phenotype_enrichment_results.csv")
rerconverge_phenotypes$slow <- "Carnivore Slow"; rerconverge_phenotypes$slow[which(rerconverge_phenotypes$stat>0)] <- "Herbivore Slow"
rerconverge_phenotypes$dataset <- "Phenotypes"

tissues.condensed <- rerconverge_tissues[,c(1:2,10:12)]; tissues.condensed$significant <- 0; tissues.condensed$significant[which(tissues.condensed$permqval<0.05)] <- 1
pathways.condensed <- rerconverge_pathways[,c(1:2,8:10)]; pathways.condensed$significant <- 0; pathways.condensed$significant[which(pathways.condensed$permqval<0.05)] <- 1
phenotypes.condensed <- rerconverge_phenotypes[2:nrow(rerconverge_phenotypes),c(1:2,10:12)]; phenotypes.condensed$significant <- 0; phenotypes.condensed$significant[which(phenotypes.condensed$permqval<0.1)] <- 1
enrichment.combined <- rbind(tissues.condensed, pathways.condensed, phenotypes.condensed); enrichment.combined$significant <- as.factor(enrichment.combined$significant)

enrichment.combined$color <- "gray"; enrichment.combined$color[which(enrichment.combined$significant==1 & enrichment.combined$stat > 0)] <- "#5E4FA2";enrichment.combined$color[which(enrichment.combined$significant==1 & enrichment.combined$stat < 0)] <- "#9E0142"
enrichment.combined$shape <- 1; enrichment.combined$shape[which(enrichment.combined$significant==1)] <- 19

data.line <- data.frame(dataset = unique(enrichment.combined$dataset), hline = c(0.05, 0.05, 0.1))

p <- ggplot(data=enrichment.combined, aes(x=stat, y=permqval, group=dataset, color=slow, fill=slow)) +
  geom_point(size = 4, color=enrichment.combined$color, shape=enrichment.combined$shape, alpha = 0.75) +
  theme_classic() + theme(legend.position="none", strip.background = element_blank(), strip.placement = "outside") +
  scale_y_continuous(trans=reverselog_trans(10)) + scale_color_manual(values=c("#9E0142", "#5E4FA2")) +
  xlab("Rho") + ylab("q-value")
p + facet_wrap(. ~ factor(dataset, level=c("Tissues", "Gene Pathways", "Phenotypes")), strip.position = "bottom") +
  coord_cartesian(xlim = c(-0.36, 0.36)) + geom_hline(data = data.line, aes(yintercept = hline), linetype="dashed")




