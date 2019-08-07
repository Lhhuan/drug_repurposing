require(xgboost)
data(agaricus.train, package='xgboost')
data(agaricus.test, package='xgboost')
train <- agaricus.train
test <- agaricus.test
xgb = xgboost(data=train$data, label=train$label, max_depth=2, eta=1, objective='binary:logistic', nrounds=2)


library(xgboost)
library(readr)
library(stringr)
library(caret)
#(car)
