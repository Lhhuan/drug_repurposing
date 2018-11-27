## ----style, echo=FALSE, results="asis", message=FALSE----------------------
BiocStyle::markdown()
knitr::opts_chunk$set(tidy = FALSE,
                      warning = FALSE,
                      message = FALSE)

## ----echo=FALSE, results="hide", message=FALSE-----------------------------
library(MeSH.Hsa.eg.db)
library(MeSH.db)
library(DOSE)
library(meshes)

## --------------------------------------------------------------------------
library(meshes)
data(geneList, package="DOSE")
de <- names(geneList)[1:100]
x <- enrichMeSH(de, MeSHDb = "MeSH.Hsa.eg.db", database='gendoo', category = 'C')
head(x)

## --------------------------------------------------------------------------
y <- gseMeSH(geneList, MeSHDb = "MeSH.Hsa.eg.db", database = 'gene2pubmed', category = "G")
head(y)

## --------------------------------------------------------------------------
dotplot(x)
gseaplot(y, y[1,1], title=y[1,2])

## --------------------------------------------------------------------------
library(meshes)
## hsamd <- meshdata("MeSH.Hsa.eg.db", category='A', computeIC=T, database="gendoo")
data(hsamd)
meshSim("D000009", "D009130", semData=hsamd, measure="Resnik")
meshSim("D000009", "D009130", semData=hsamd, measure="Rel")
meshSim("D000009", "D009130", semData=hsamd, measure="Jiang")
meshSim("D000009", "D009130", semData=hsamd, measure="Wang")

meshSim(c("D001369", "D002462"), c("D017629", "D002890", "D008928"), semData=hsamd, measure="Wang")

## --------------------------------------------------------------------------
geneSim("241", "251", semData=hsamd, measure="Wang", combine="BMA")
geneSim(c("241", "251"), c("835", "5261","241", "994"), semData=hsamd, measure="Wang", combine="BMA")

## ----echo=FALSE------------------------------------------------------------
sessionInfo()

