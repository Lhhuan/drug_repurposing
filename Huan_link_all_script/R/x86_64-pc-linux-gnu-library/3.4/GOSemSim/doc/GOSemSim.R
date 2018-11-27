## ----style, echo=FALSE, results="asis", message=FALSE--------------------
knitr::opts_chunk$set(tidy = FALSE,
                      warning = FALSE,
                      message = FALSE)

## ----echo=FALSE, results="hide", message=FALSE---------------------------
library(org.Hs.eg.db)
library(GO.db)
library(GOSemSim)

## ----eval=FALSE----------------------------------------------------------
#  library(AnnotationHub)
#  hub <- AnnotationHub()
#  q <- query(hub, "Cricetulus")
#  id <- q$ah_id[length(q)]
#  Cgriseus <- hub[[id]]

## ------------------------------------------------------------------------
library(GOSemSim)
hsGO <- godata('org.Hs.eg.db', ont="MF")

## ------------------------------------------------------------------------
goSim("GO:0004022", "GO:0005515", semData=hsGO, measure="Jiang")
goSim("GO:0004022", "GO:0005515", semData=hsGO, measure="Wang")
go1 = c("GO:0004022","GO:0004024","GO:0004174")
go2 = c("GO:0009055","GO:0005515")
mgoSim(go1, go2, semData=hsGO, measure="Wang", combine=NULL)
mgoSim(go1, go2, semData=hsGO, measure="Wang", combine="BMA")

## ------------------------------------------------------------------------
geneSim("241", "251", semData=hsGO, measure="Wang", combine="BMA")
mgeneSim(genes=c("835", "5261","241", "994"),
         semData=hsGO, measure="Wang",verbose=FALSE)
mgeneSim(genes=c("835", "5261","241", "994"),
       semData=hsGO, measure="Rel",verbose=FALSE)

## ------------------------------------------------------------------------
hsGO2 <- godata('org.Hs.eg.db', keytype = "SYMBOL", ont="MF", computeIC=FALSE)
genes <- c("CDC45", "MCM10", "CDC20", "NMU", "MMP1")
mgeneSim(genes, semData=hsGO2, measure="Wang", combine="BMA", verbose=FALSE)

## ------------------------------------------------------------------------
gs1 <- c("835", "5261","241", "994", "514", "533")
gs2 <- c("578","582", "400", "409", "411")
clusterSim(gs1, gs2, semData=hsGO, measure="Wang", combine="BMA")

library(org.Hs.eg.db)
x <- org.Hs.egGO
hsEG <- mappedkeys(x)
set.seed <- 123
clusters <- list(a=sample(hsEG, 20), b=sample(hsEG, 20), c=sample(hsEG, 20))
mclusterSim(clusters, semData=hsGO, measure="Wang", combine="BMA")

## ----echo=FALSE----------------------------------------------------------
sessionInfo()

