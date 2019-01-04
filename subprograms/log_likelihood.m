function [lml] = log_likelihood(hyper_param, model,i)

% This function estimates the restricted likelihood.

y=model.Y(:,i);
fn=reshape(model.fn,model.m,model.n,model.p);
f=reshape(fn(i,:,:), model.n,model.p);

K = model.cov_model(hyper_param, model.X, model.X);
Kchol = chol(K);

alpha1=y-f*model.beta;
alpha2 = (Kchol\(Kchol'\alpha1));
sigma2=alpha1'*alpha2/model.n;

lml=0.5*model.n*(sigma2)+0.5*log(det(K));

end