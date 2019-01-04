function model=MRSM(input,output,option)

% This code has been written by Mohammadkazem Sadoughi at Iowa State
% University (4/05/2017). This file is the main code for building the multi-variate
% Gaussian process. The inputs are the training data and based on that the
% hyperparametrs is tuned and the regression coefficient, trend function and
% covariance matrix will be defined. 

if exist( 'option', 'var' )
    
    if isempty(option.s)              % Upper bound for matrix A elements. Setting this parameter to a very small value means we do not consider any correlation amng the responses
        model.s=0.6;               
    else
        model.s=option.s;
    end
    
    if isempty(option.degree)         % Degree of polynomial functions: can be zero, one, two or....    
        model.degree=2;        
    else
        model.degree=option.degree;
    end
    
    if isempty(option.optim)           %  Optimization method   
        model.optim='fmincon';        
    else
        model.optim=option.optim;
    end   
else
        model.s=0.6;  
        model.degree=0;  
        model.optim='fmincon';  
end

model.X=input;
model.Y=output;                  % Matrix of (model.n by model.m )

model.d=size(input,2);           % Dimesntion of input variables
model.n=size(input,1);           % Number of training points
model.m=size(output,2);          % Number of responses

model.ymn=reshape(output',model.m*model.n,1);             % Reshape the output to a vector of (model.m * model.n by 1)

model.cov_model = @(hyp, x, z, i)covSEard(hyp, x, z);     % Define the covariance model (hbere we used the SEARD)

[model.fn, model.p]=trend_fun(model,model.X);             % Define the shape of trend function and Fn

model=initial_hyper(model);                               % Initialize hyperparametrs

model=tune_hyper(model);                                  % Tune hyperparametrs
end