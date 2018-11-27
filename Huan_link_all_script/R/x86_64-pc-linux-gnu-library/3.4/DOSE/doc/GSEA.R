## ----style, echo=FALSE, results="asis", message=FALSE----------------------
BiocStyle::markdown()
knitr::opts_chunk$set(tidy = FALSE,
                      warning = FALSE,
                      message = FALSE)

## ----echo=FALSE, results='hide', message=FALSE-----------------------------
library(DOSE)
library(org.Hs.eg.db)
library(clusterProfiler)

## --------------------------------------------------------------------------
library(DOSE)
data(geneList)
y <- gseDO(geneList, 
           nPerm         = 100, 
           minGSSize     = 120,
           pvalueCutoff  = 0.2, 
           pAdjustMethod = "BH",
           verbose       = FALSE)
head(y, 3)

## --------------------------------------------------------------------------
ncg <- gseNCG(geneList,
              nPerm         = 100, 
              minGSSize     = 120,
              pvalueCutoff  = 0.2, 
              pAdjustMethod = "BH",
              verbose       = FALSE)
ncg <- setReadable(ncg, 'org.Hs.eg.db')
head(ncg, 3)

## --------------------------------------------------------------------------
dgn <- gseDGN(geneList,
              nPerm         = 100, 
              minGSSize     = 120,
              pvalueCutoff  = 0.2, 
              pAdjustMethod = "BH",
              verbose       = FALSE)
dgn <- setReadable(dgn, 'org.Hs.eg.db')
head(dgn, 3)

## ----fig.width=18, fig.height=18, eval=FALSE-------------------------------
#  cnetplot(ncg, categorySize="pvalue", foldChange=geneList)

## ----fig.height=10, fig.width=10, eval=FALSE-------------------------------
#  enrichMap(y, n=20)

## ----fig.height=6, fig.width=8---------------------------------------------
gseaplot(y, geneSetID = y$ID[1], title=y$Description[1])

