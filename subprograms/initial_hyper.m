function model=initial_hyper(model)

% This function gives the initial values to all hyperparameters used in this algorithm.

model.hyper.teta=ones(model.m,model.d);
model.hyper.A=[1 0.05 0.03 0.01;0.05,1,0.02,0.01;0.03,0.02,1,0.04;0.01,0.01,0.04,1];

model.zigma0=diag(ones(model.m,1));
[V, D]=eig(model.zigma0);
model.hyper.A=V*(D^0.5)*V';

end