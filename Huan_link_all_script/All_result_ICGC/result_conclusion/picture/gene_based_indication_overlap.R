library(VennDiagram)
library(dplyr)

setwd("~/All_result_ICGC/result_conclusion/picture")

A<-c(1:1944)
B<-c(1:1539)

T<-venn.diagram(list(reported=A,prediction=B),filename=NULL
                #,lwd=1,lty=2,col=c('#6495ED','#5CACEE')
                ,lwd=1,lty=2,col=c('#A4D3EE','#76EEC6')
                ,fill=c('#A4D3EE','#76EEC6')
                ,cat.col=c('#A4D3EE','#76EEC6')
                ,reverse=TRUE)
grid.draw(T)


#B8860B
#CD0000
#63B8FF
#6495ED
#1E90FF