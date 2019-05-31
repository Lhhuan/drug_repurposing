
library(ggplot2)
library(pROC)
library(plotROC)

# I start by creating an example data set. There are 2 markers, 
# one that is moderately predictive and one that is not as predictive.

set.seed(2529)
D.ex <- rbinom(200, size = 1, prob = .5)
M1 <- rnorm(200, mean = D.ex, sd = .65)
M2 <- rnorm(200, mean = D.ex, sd = 1.5)

test <- data.frame(D = D.ex, D.str = c("Healthy", "Ill")[D.ex + 1], 
                   M1 = M1, M2 = M2, stringsAsFactors = FALSE)

# The Roc Geom
# Next I use the ggplot function to define the aesthetics, and 
# the geom_roc function to add an ROC curve layer. 

p1 <- ggplot(test, aes(d = D, m = M1)) + geom_roc(n.cuts = 0)
p1<-p1+annotate("text", x = .75, y = .25, 
         label = paste("AUC =", round(calc_auc(p1)$AUC, 2))) 

p1<-p1+ geom_rocci(linetype = 1)
p1
basicplot


#-----------------------------------
D.ex <- rbinom(50, 1, .5)
rocdata <- data.frame(D = c(D.ex, D.ex),
                      M = c(rnorm(50, mean = D.ex, sd = .4), rnorm(50, mean = D.ex, sd = 1)),
                      Z = c(rep("A", 50), rep("B", 50)))
ggplot(rocdata, aes(m = M, d = D)) + geom_roc() + geom_rocci()
ggplot(rocdata, aes(m = M, d = D)) + geom_roc() + style_roc()
ggplot(rocdata, aes(m = M, d = D, color = Z)) + geom_roc() + geom_rocci()
ggplot(rocdata, aes(m = M, d = D, color = Z)) + geom_roc() + geom_rocci(sig.level = .01)
ggplot(rocdata, aes(m = M, d = D)) + geom_roc(n.cuts = 0) +
  geom_rocci(ci.at = quantile(rocdata$M, c(.1, .25, .5, .75, .9)))
ggplot(rocdata, aes(m = M, d = D, color = Z)) + geom_roc() + geom_rocci(linetype = 1)
rocplot <- ggplot(rocdata, aes(m = M, d = D)) + geom_roc()
plot_interactive_roc(rocplot)
plot_interactive_roc(rocplot + aes(color = Z))
plot_interactive_roc(rocplot + facet_wrap( ~ Z))




#---------------------------------------
library(pROC)

data(aSAH)



plot.roc(
  aSAH$outcome, aSAH$s100b,
         
         main="Confidence interval of a threshold", percent=TRUE,
         
         ci=TRUE, of="thresholds", # compute AUC (of threshold)
         
         thresholds="best", # select the (best) threshold
         
         print.thres="best") # also highlight this threshold on the plot


