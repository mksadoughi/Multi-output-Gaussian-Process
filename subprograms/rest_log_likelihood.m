function [lml] = rest_log_likelihood(x, model)

% This function calculates the restricted likelihod at each set of hyperparametrs

n1=model.m*(model.m-1)/2;
n2=model.m*model.d;

k=1;

for i=1: model.m
    for j=i+1:model.m
    z0(i,j)=x(k);
    k=k+1;
    end
end

if model.m==1;
    z0=[];
end

z0=[z0;zeros(1,model.m)];
z0=z0+z0'+diag(ones(model.m,1));

[V, D]=eig(z0);
model.hyper.A=V*(D^0.5)*V';
teta=x(n1+1:end);
teta=reshape(teta,model.m,model.d);
y=model.ymn;
f=model.fn;

model.hyper.teta=teta;
model.z_mn=define_covmatrix(model,model.X,model.X); % update the value of model. zmn
model.beta=find_beta(model); % update beta values

%% Determine the restricted likelihood function
zmnchol = poschol(model.z_mn);
alpha1=y-f*model.beta;
alpha2 = (zmnchol\(zmnchol'\alpha1));
sigma2=alpha1'*alpha2;
alpha3=(zmnchol\(zmnchol'\f));
alpha4=f'*alpha3;

% RMLE
lml=0.5*(sigma2)+0.5*log(det(model.z_mn))+0.5*log(det(alpha4));
% MLE
% lml=0.5*(sigma2)+0.5*log(det(model.z_mn));
end