# Multi-output-Gaussian-Process

## Multi-output regression 

In multi-output regression (multi-target, multi-variate, or multi-response regression), we aim to predict multiple real valued output variables. One simple approach may be using combination of single output regression models. But this approach has some drawbacks and limitations [[1](https://towardsdatascience.com/regression-models-with-multiple-target-variables-8baa75aacd)]: 

  * Training several single-output models take long times.
  * Each single output model is trained and optimized for one specific target, not the combination of all target. 
  * In many cases, there is a strong interdependency and correlation among the targets. The single output models cannot capture this relation. 

To address this drawbacks and limitations, we look for multi-output regression methods that can model the multi-output datasets by considering not only the relationships between the input factors and the corresponding targets but also the relationships between the targets. Several regression methods have been developed for multi-output problems. Click [here](http://cig.fi.upm.es/articles/2015/Borchani-2015-WDMKD.pdf) for a great review of these methods. For example, multi-target SVM or Random forest are two of the most popular ones. 

In this research, I am proposing and implementing a new technique for multi-output regression using Gaussian process (GP) model. 

## Univariate GP
Let’s first start with introducing univariate GP.  Univariate GP defines a Gaussian distributions on functions which can be used for nonlinear regression, classification, ranking, preference learning, or ordinal regression. Univariate GP has several advantages over other regression techniques: 

1.	It outperforms other methods on the problems with limited by computationally expensive datasets.
2.	It provides not only the mean value of prediction, but also the uncertainty of prediction. The prediction uncertainty can be used to define the confidence level for our prediction accuracy. 

[PyKrige](https://github.com/bsmurphy/PyKrige) is a Toolkit for Python which implements the univariate GP model. Also, you can use [fitrgp](https://www.mathworks.com/help/stats/fitrgp.html) to implement univariate GP model in MATLAB. 

## Multivariate GP

In this research, I extended the univariate GP to multivariate GP to handle the problems with multiple interdependent targets. The key point for this extension, is redefining the covariance matrix to be able to capture the correlation among the targets. To this end, I used the nonseparable covariance structure explained by [Thomas E. Fricker](https://amstat.tandfonline.com/doi/abs/10.1080/00401706.2012.715835#.XC5jpVxKi70). The conventional univariate GP models, builds the spatial covariance matrix over the features data. Then the kernel’s hyper parameters are learned by maximizing the likelihood of observations. However, in multivariate GP, we extend the covariance matrix to cover the correlation between both features and targets. Therefore, it involves a larger number of hyperparameters to be optimized. As such the optimization process takes a little longer. For the mathematical description of multivariate GP, please see our recent publication [click here]. 

You can train a multivariate GP model using the MSRM function.

```matlab
MGP = fitrgp(X,Y, option)
```

Here,  MGP is the trained model, ```X``` is the matrix of input factors and ```Y``` is the matrix of targets. Option can have one or several attributes:

* ```Option.s``` : defines the upper bound for the correlation matrix among the targets. Setting this number to a very small value means we are removing all the possible correlation between the targets in building the multivariate GP model. 

* ```Option.degree```: defines the digress of polynomial function which is used as the trend function for the multivariate GP model. It can be any integer between zero to 4.  The default value is zero.    

* ```Option.optim```: defines the optimization method that is used during the training process. The default is ```‘fmincon’```. You also have the option of ```'Global'``` which uses a global optimization algorithm. This option is more accurate, however the optimization process takes longer. 
    
After training the model, we can use predict_resp function for performing the prediction on the new dataset. 
```matlab
[y_ S_] = predict_resp(MGP, X_);
```

Where ```X_``` is the new dataset.  ```Y_``` is mean value of prediction and ```S_``` is the uncertainty of the prediction. 

## Simple example

Now let’s try to implement a simple example: 

1.	Defines a simple input matrix with 4 samples and two features : 
```matlab
>> X = [1,2; 2, 1; 2, 3; 3, 4]
X =
     1     2
     2     1
     2     3
     3     4
```
2.	Define the corresponding output matrix with 4 samples and 2 targets. 
```matlab
>> Y = [3, 4; 2, 3; 1, 2; 4, 5]
Y =
     3     4
     2     3
     1     2
     4     5
```
3.	Build a MRSM model over the data (here I am  letting the code uses the default options).
```matlab
>> MGP = MRSM (X, Y);
```
4.	Predict the response at a new input point using the trained model. 
```matlab
>> X_ = [2.5, 3.5]
X_ =
    2.5000    3.5000
>> [Y_, S_] = predict_resp(MGP, X_)
Y_ =
    2.2442    3.0326
S_ =
    0.3581    0.4193
    0.4193    1.0432
```
Y_ is the mean value of prediction for the two targets and S_ is the covariance matrix summarizing the uncertainty of prediction and also the correlation between the two targets at this specific test point. For instance this result shows that the correlation between the two targets at this point is 0.4193. 
