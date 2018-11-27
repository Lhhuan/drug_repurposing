library("randomForest")
testset <- read.delim("02_duplicate.txt")

#testset <- read.delim("02_feature_oncodriverule_unique.txt")
rownames(testset) <- testset$sym
load("OncodriveROLE.RData") 
result <- oncodriveROLE.classify(testset)


setwd ("~/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/COSMIC/cosmic/v84/v84_classify2/oncodriverole")
write.table(result,'oncodriverole_perdiction_result_1.txt',row.names = T, col.names = T,  quote = F,sep = "\t")

