function beta=find_beta(model)

zchol=poschol(model.z_mn);

alpha1 = (zchol\(zchol'\model.ymn));
alpha2=(zchol\(zchol'\model.fn));
alpha3=model.fn'*alpha2;
alpha3chol=chol(alpha3);
alpha4=(alpha3chol\(alpha3chol'\model.fn'));
beta=alpha4*alpha1;


end