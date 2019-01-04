function K= covSEard(hyp, x, z)
n=size(x,1);
m=size(z,1);
for i=1:n
    for j=1:m
        K(i,j)=exp(-sum( hyp.*((x(i,:)-z(j,:)).^2) ));
    end
end
% K= A+A'-diag(diag(A));
end