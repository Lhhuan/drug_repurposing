library("randomForest")
testset <- read.delim("dataset.txt") 
rownames(testset) <- testset$sym
load("OncodriveROLE.RData") 
result <- oncodriveROLE.classify(testset)
setwd ("~/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/COSMIC/cosmic/v84/test_oncodriveROLE")
write.table(result,'perdiction_result.txt',row.names = T, col.names = T,  quote = F,sep = "\t")
        