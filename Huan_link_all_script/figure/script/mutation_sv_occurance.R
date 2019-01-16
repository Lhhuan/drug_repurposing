library(ggplot2)
library(Rcpp)
library(readxl)
library(dplyr)
library(stringr)
library(ggpubr)
library(gcookbook)
library(GenomicRanges)



setwd("/f/mulinlab/huan/figure/script/")

install.packages('RCircos')
library(RCircos)

data(UCSC.HG38.Human.CytoBandIdeogram)
cyto.info <- UCSC.HG38.Human.CytoBandIdeogram
RCircos.Set.Core.Components(cyto.info, chr.exclude=NULL,tracks.inside=10, tracks.outside=0 )
#--------------------
RCircos.Set.Plot.Area()
RCircos.Chromosome.Ideogram.Plot()
