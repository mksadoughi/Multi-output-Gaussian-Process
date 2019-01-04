function [f p]=trend_fun(model,X)

% This file has been written by Mohammadkazem Sadoughi, at Iowa State
% University (4/05/2017). This file defines different type of trend function
% based on the degree of polynomials

n=size(X,1);
model.ss=1;
f=[];


switch model.degree
    
    case 0  % f(x)= 1
        p=1;
        for i=1:n;
            for j=1:model.m
                supplement=[1];
                f=[f;supplement];
            end
        end  
        
    case 1  % f(x)= 1,  x       
        p=1+model.d;
        for i=1:n;
            for j=1:model.m
                supplement=[1,X(i,:)];
                f=[f;supplement];
            end
        end
        
    case 2  % f(x)= 1 , x , x2   
        p=1+model.d*(model.d+3)/2;
        for i=1:n;
            for j=1:model.m
                supplement=[1,X(i,:)];
                for k=1:model.d
                    for l=k:model.d 
                        supplement=[supplement,X(i,k)*X(i,l)];
                    end
                end
                f=[f;supplement];
            end
            
        end
        
    case 7   % f(x)= 1 , x , y , xy, x2, y2, x2y     
    case 8   % f(x)= 1 , x , y , xy, x2, y2, x2y, xy2
    case 9   % f(x)= 1 , x , y , xy, x2, y2, x2y, xy2, x3       
    case 10  % f(x)= 1 , x , y , xy, x2, y2, x2y, xy2, x3, y3        

    otherwise
    disp('other value for p')
end

end