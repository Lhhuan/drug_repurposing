library(readxl)
library(dplyr)
library(stringr)
library(igraph)


setwd ("~/All_result/")
drug_target <- read_tsv("huan_target_drug_indication_final_symbol.txt")
symbol <-drug_target$Gene_symbol%>%unique()%>%data.frame()
network <- read_tsv("FIsInGene_022717_with_annotations.txt")#%>%as.data.frame()#%>%as.igraph()

n <- network[,1:2]
gg <- graph_from_data_frame(n)k
x <- random_walk(gg, start="AATK", steps=10)

xg<-network%>%dplyr::select(Gene1,Gene2,Direction)
g <- network$Gene1()



g<-make_directed_graph(network, n = max(network))
k<-random_walk(network , star = symbol , steps = 10000, mode = c("out"), stuck = c("return"))



g <- make_ring(10, directed = TRUE) %u% make_star(11, center = 11) + edge(11, 1)
  

ec <- eigen_centrality(g, directed = TRUE)$vector
pg <- page_rank(g, damping = 0.999)$vector
w <- random_walk(g, start = 1, steps = 10)
cor(table(w), ec)
cor(table(w), pg)
s <-w %>%data.frame()

g <- make_(ring(10), with_vertex_(name = LETTERS[1:10])) +   vertices('X', 'Y')
random_walk(g,start="A",steps = 10)
edge_connectivity(gg, "ATR", "A1CF")

