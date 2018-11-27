## ----echo=F, message=F---------------------------------------------------
library(fgsea)
library(data.table)
library(ggplot2)

## ------------------------------------------------------------------------
data(examplePathways)
data(exampleRanks)

## ------------------------------------------------------------------------
fgseaRes <- fgsea(pathways = examplePathways, 
                  stats = exampleRanks,
                  minSize=15,
                  maxSize=500,
                  nperm=10000)

## ------------------------------------------------------------------------
head(fgseaRes[order(pval), ])

## ------------------------------------------------------------------------
sum(fgseaRes[, padj < 0.01])

## ---- fig.width=7, fig.height=4------------------------------------------
plotEnrichment(examplePathways[["5991130_Programmed_Cell_Death"]],
               exampleRanks) + labs(title="Programmed Cell Death")


## ---- fig.width=7, fig.height=8, fig.retina=2----------------------------
topPathwaysUp <- fgseaRes[ES > 0][head(order(pval), n=10), pathway]
topPathwaysDown <- fgseaRes[ES < 0][head(order(pval), n=10), pathway]
topPathways <- c(topPathwaysUp, rev(topPathwaysDown))
plotGseaTable(examplePathways[topPathways], exampleRanks, fgseaRes, 
              gseaParam = 0.5)

## ----message=F-----------------------------------------------------------
pathways <- reactomePathways(names(exampleRanks))
fgseaRes <- fgsea(pathways, exampleRanks, nperm=1000, maxSize=500)
head(fgseaRes)

## ------------------------------------------------------------------------
rnk.file <- system.file("extdata", "naive.vs.th1.rnk", package="fgsea")
gmt.file <- system.file("extdata", "mouse.reactome.gmt", package="fgsea")

## ------------------------------------------------------------------------
ranks <- read.table(rnk.file,
                    header=TRUE, colClasses = c("character", "numeric"))
ranks <- setNames(ranks$t, ranks$ID)
str(ranks)

## ------------------------------------------------------------------------
pathways <- gmtPathways(gmt.file)
str(head(pathways))

## ------------------------------------------------------------------------
fgseaRes <- fgsea(pathways, ranks, minSize=15, maxSize=500, nperm=1000)
head(fgseaRes)

