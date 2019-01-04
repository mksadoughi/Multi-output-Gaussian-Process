function Mchol=poschol(M)
M=abs(M);
M= triu(M)+triu(M)'-diag(diag(M));    
[V,D]=eig(M);
d=diag(D);
d(d<=10e-10)=10e-10;
Mchol= V*diag(d)*V';
Mchol=chol(Mchol);
end