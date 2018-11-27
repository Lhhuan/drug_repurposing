## ----style, echo=FALSE, results="asis", message=FALSE----------------------
BiocStyle::markdown()
knitr::opts_chunk$set(tidy = FALSE,
                      warning = FALSE,
                      message = FALSE)

## ----echo=FALSE, results='hide', message=FALSE-----------------------------
library(DOSE)

## --------------------------------------------------------------------------
a <- c("DOID:14095", "DOID:5844", "DOID:2044", "DOID:8432", "DOID:9146",
       "DOID:10588", "DOID:3209", "DOID:848", "DOID:3341", "DOID:252")
b <- c("DOID:9409", "DOID:2491", "DOID:4467", "DOID:3498", "DOID:11256")
doSim(a[1], b[1], measure="Wang")
doSim(a[1], b[1], measure="Resnik")
doSim(a[1], b[1], measure="Lin")
s <- doSim(a, b, measure="Wang")
s

## --------------------------------------------------------------------------
simplot(s,
        color.low="white", color.high="red",
        labs=TRUE, digits=2, labs.size=5,
        font.size=14, xlab="", ylab="")

## ----warning=FALSE---------------------------------------------------------
g1 <- c("84842", "2524", "10590", "3070", "91746")
g2 <- c("84289", "6045", "56999", "9869")

geneSim(g1[1], g2[1], measure="Wang", combine="BMA")
gs <- geneSim(g1, g2, measure="Wang", combine="BMA")
gs

## --------------------------------------------------------------------------
clusterSim(g1, g2, measure="Wang", combine="BMA")

## --------------------------------------------------------------------------
g3 <- c("57491", "6296", "51438", "5504", "27319", "1643")
clusters <- list(a=g1, b=g2, c=g3)
mclusterSim(clusters, measure="Wang", combine="BMA")

