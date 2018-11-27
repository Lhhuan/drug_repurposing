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
gene <- names(geneList)[abs(geneList) > 1.5]
head(gene)
x <- enrichDO(gene          = gene,
              ont           = "DO",
              pvalueCutoff  = 0.05,
              pAdjustMethod = "BH",
              universe      = names(geneList),
              minGSSize     = 5,
              maxGSSize     = 500,
              qvalueCutoff  = 0.05,
              readable      = FALSE)
head(x)

## --------------------------------------------------------------------------
x <- setReadable(x, 'org.Hs.eg.db')
head(x)

## --------------------------------------------------------------------------
gene2 <- names(geneList)[abs(geneList) < 3]
ncg <- enrichNCG(gene2)
head(ncg)

## --------------------------------------------------------------------------
dgn <- enrichDGN(gene)
head(dgn)

snp <- c("rs1401296", "rs9315050", "rs5498", "rs1524668", "rs147377392",
         "rs841", "rs909253", "rs7193343", "rs3918232", "rs3760396",
         "rs2231137", "rs10947803", "rs17222919", "rs386602276", "rs11053646",
         "rs1805192", "rs139564723", "rs2230806", "rs20417", "rs966221")
dgnv <- enrichDGNv(snp)
head(dgnv)

## ----fig.height=6, fig.width=7---------------------------------------------
barplot(x, showCategory=10)

## ----fig.width=6-----------------------------------------------------------
dotplot(x)

## ----fig.width=18, fig.height=18, eval=FALSE-------------------------------
#  cnetplot(x, categorySize="pvalue", foldChange=geneList)

## ----fig.width=10, fig.height=6, eval=FALSE--------------------------------
#  upsetplot(x)

## ----fig.height=10, fig.width=10, eval=FALSE-------------------------------
#  enrichMap(x)

## ----fig.width=7, fig.height=7---------------------------------------------
library(clusterProfiler)
data(gcSample)
cdo <- compareCluster(gcSample, fun="enrichDO")
plot(cdo)

