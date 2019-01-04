function model=tune_hyper(model)

% This file has been written by Mohammadkazem Sadoughi, at Iowa State
% University (4/05/2017). This file tunes the hyperparameters used in
% covariance metrix of multivariate Gaussian process

model = max_restr_likelihood(model);                  % Using MLE technique to tune the matrix A and hyperparametrs teta. 

model.z_mn=define_covmatrix(model,model.X,model.X);   % Define the covariance matrix between training points

model.beta=find_beta(model);                          % Define the trend function coefficients
end