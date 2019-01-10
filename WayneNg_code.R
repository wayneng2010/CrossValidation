# Name: Wayne Ng
# Date: Jan 10, 2019
# Title: k-fold cross validation
#
# This code uses code from the example "Placing Animations side-by-side with magick"
# submitted by Matt Crump
# Here is the Reference: https://github.com/thomasp85/gganimate/wiki/Animation-Composition
#
# This code uses code from CSCI-E63C for MSE calculation
#
#rm(list=ls())
library(ggplot2)
library(gganimate)
library(dplyr)
library(magick)

# input data  
X=seq(-1,1,length=1000)
#Y=1+2*X+X^2+rnorm(length(X), sd=0.6)
Y=1+2*X+rnorm(length(X), sd=0.5)
plot(X,Y, pch=19, cex=0.7)
a=as.data.frame(cbind(X,Y))

# K-fold cross-validation
# testing K=5
for (k in c(3,5,10,20,100)){
mse.test=numeric()
mse.train=numeric()
for (j in 1:100){
  residuals=numeric()
  grps=sample((1:nrow(a)) %% k+1)
  for (i in 1:k){
    data.test = a[grps==i,]
    data.train = a[grps!=i,]
    M=lm(Y~X, data=data.train, na.action = "na.exclude")
    M.predicted=predict(M, newdata=data.test)
    r=M.predicted - data.test
    mse.test  = c(mse.test, sum(r^2, na.rm = T)/sum(!is.na(r)))
    mse.train = c(mse.train, sum(M$residuals^2, na.rm = T)/sum(!is.na(M$residuals)))
  }
}

#prepare data for animations - MSE
M_test<-as.data.frame(mse.test)
M_test$DataSet<-as.factor("Test")
colnames(M_test)[colnames(M_test) == 'mse.test'] <- 'MSE'
M_train<-as.data.frame(mse.train)
M_train$DataSet<-as.factor("Train")
colnames(M_train)[colnames(M_train) == 'mse.train'] <- 'MSE'
M1<-as.data.frame(rbind(M_test,M_train))
M1$sims<-k

#prepare data for animations - MSE
D_train<-data.train
D_train$DataSet<-"Train"
D_test<-data.test
D_test$DataSet<-"Test"
D1<-as.data.frame(rbind(D_train,D_test))
D1$sims<-k

# prepare data for animations - combine all
if (k==3){
  df=M1
  rawPt=D1
} else {
  df=rbind(df, M1)
  rawPt=rbind(rawPt,D1)
}
}

# prepare mean
means_df <- df %>%
  group_by(sims,DataSet) %>%
  summarize(means=mean(MSE),
            sem = sd(MSE)/sqrt(length(MSE)))

# prepare mean squre error 
a <- ggplot(means_df, aes(x = DataSet,y = means, fill = DataSet)) +
  ggtitle("Mean Squre Error") +
  ylab("Mean Squre Error") +
  geom_bar(stat = "identity") +
  geom_point(aes(x = DataSet, y = MSE), data = df, alpha = .25) +
  geom_errorbar(aes(ymin = means - sem, ymax = means + sem), width = .2) +
  theme_classic() +
  transition_states(
    states = sims,
    transition_length = 2,
    state_length = 1
  ) + 
  enter_fade() + 
  exit_shrink() +
  ease_aes('sine-in-out') 

a_gif <- animate(a, width = 360, height = 360)

# prepare raw data graph
b<-ggplot(rawPt, aes(x=X, y=Y, color=DataSet)) +
  ggtitle("Raw data") +
  geom_point() +
  theme_classic() +
  transition_states(
    states = sims,
    transition_length = 2,
    state_length = 1,
    wrap = FALSE
  ) + 
  enter_fade() + 
  exit_fade() +
  ease_aes('sine-in-out')

b_gif <- animate(b, width = 360, height = 360)

a_mgif <- image_read(a_gif)
b_mgif <- image_read(b_gif)

new_gif <- image_append(c(b_mgif[1], a_mgif[1]))
for(i in 2:100){
  combined <- image_append(c(b_mgif[i], a_mgif[i]))
  new_gif <- c(new_gif, combined)
}

new_gif