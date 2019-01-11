TITLE : K-fold Cross Validation

Author: Wayne Ng

Affiliation: Graduate Certificate Candidate, Harvard Extension School 

#


K-fold Cross Validation

![Alt Text](WayneNg_artifact.gif)


Code:https://github.com/wayneng2010/CrossValidation/blob/master/WayneNg_code.R


Explanation: 
This visualization demonstrates on how K-fold Cross Validation(K-fold CV) works. It is important because in a prediction problem, we want to determining the accuracy of our prediction model. K-fold Cross Validation is a good re-sampling method and can measure model prediction performance in practice. In this submission, I created a linear random samples and fit a linear model for prediction. To perform K-fold CV, I divide the set of observations into k groups, or folds, of equal size. The first fold is treated as a validation set(test set), and the linear method is fit on the remaining k - 1 folds(training set). The mean squared error(MSE) is computed on both the training set and test set separately. To simulate, I have select K-fold as 3,5,10,20,100. The choice of K-fold is to demonstrate that the MSE can go up when we have larger K-fold. The best K-fold is 10-fold in this simulation. 
