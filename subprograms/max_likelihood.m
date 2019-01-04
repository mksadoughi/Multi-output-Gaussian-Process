function model= max_likelihood(model)

% This function is used when we only want to tune the decay parameters in each single response separately.

for i=1:model.m
    problem.f = @(x) log_likelihood(x,model,i);
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    lb= 0.01*ones(1,model.d);
    ub= 100*ones(1,model.d);
    x0 = model.hyper.teta(i,:);
    options = optimset('Display', 'off') ;
    nonlcon=[];
    model.hyper.teta(i,:) = fmincon(problem.f,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);
end

end