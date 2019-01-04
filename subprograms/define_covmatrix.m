function z_mn=define_covmatrix(model,X1,X2)
% This function uses Non-separable Linear Model of Coregionalization (NLMC) to build the covariance among each set of points.

for i=1:model.m  
    L(:,:,i) = model.cov_model(model.hyper.teta(i,:), X1, X2);
end
z_mn=[];
for i=1:size(X1,1)
    supplement=[];
    for j=1:size(X2,1)
        model.cov{i,j}=model.hyper.A*diag(reshape(L(i,j,:),model.m,1))*model.hyper.A';  
        supplement=[supplement, model.cov{i,j}];
    end
    z_mn=[z_mn;supplement];   
end

if isequal(X1,X2)==1
    z_mn= triu(z_mn)+triu(z_mn)'-diag(diag(z_mn));    
    [V,D]=eig(z_mn);
    d=diag(D);
    d(d<=.001)=0.001;
    z_mn= V*diag(d)*V';
end

end

