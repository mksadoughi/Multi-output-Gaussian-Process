%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code has been written by Mohammad Kazem Sadoughi at SRSL, Iowa State
% University. The purpose of this code is to demostrated who to run the
% multi-response surrogate modeling (MRSM) code on a sample problem with
% three ojective functions. For more information on MRSM, please see our
% recent publication: 
%       Sadoughi, Mohammadkazem, Meng Li, and Chao Hu. "Multivariate system reliability analysis
%       considering highly nonlinear and dependent safety events." Reliability Engineering & System
%       Safety 180 (2018): 189-200.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function example()
% NOTE: EXECUTE THIS EXAMPLE FROM THIS DIRECTORY. RELATIVE PATHS ARE USED
% IN THE EXAMPLES.
% This example considers three highly correlated response surfaces.

%% Design variables definition
% Generating sample data: 16 uniform distributed points is considered as
% the training data. This training data can be changed or chosen from any
% other algorithm like LHS
n0      = 4;                             % number of samples along each direction (variable)
input1  = linspace(0,1,n0);          % generating the uniform samples along the first direction
input2  = linspace(0,1,n0);          % generating the uniform samples along the second direction
[INPUT1,INPUT2] = meshgrid(input1,input2);
INPUT11 = reshape(INPUT1,n0*n0,1);  % generating mesh grids of data (will be used for ploting)
INPUT22 = reshape(INPUT2,n0*n0,1);  % generating mesh grids of data (will be used for ploting)
INPUT   = [INPUT11,INPUT22];          % combine the two dimensions (variables)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate the output of the three functions at the generated initial
% points using multivariate Gaussian process. Please read our published
% article for more information on multivariate Gaussian process:
%       Sadoughi, Mohammadkazem, Meng Li, and Chao Hu. "Multivariate system reliability analysis
%       considering highly nonlinear and dependent safety events." Reliability Engineering & System
%       Safety 180 (2018): 189-200.

OUTPUT=[bmfun1(INPUT),bmfun2(INPUT),bmfun3(INPUT)];
k = MRSM(INPUT,OUTPUT );  % Building the model using MRSM function

% k is the summary of the trained model containing all the optimized hyperparameters

%% %%%%%%%%%%%%%%%%%  Prediction   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now, we want to use the trained model to do prediction on a new set of data
% Generating testing points
n = 100;
x = linspace(0,1,n);  % generating testing points uniformly along the firt direction
y = linspace(0,1,n);  % generating testing points uniformly along the second direction
[X,Y] = meshgrid(x,y);  % generate the 2d samples by combining the generated unidirectional points

for i=1:n
    for j=1:n
        
        % NOTE: z_true is the true output at the testing points and "z_pred" is
        % the prediction at testing points based on the MRSM method
        z_true(i,j,1) = bmfun1([x(i),y(j)]);
        z_true(i,j,2) = bmfun2([x(i),y(j)]);
        z_true(i,j,3) = bmfun3([x(i),y(j)]);
        
        % Prediction at testing points
        [z_pred(i,j,:) std_pred] = predict_resp(k,[x(i),y(j)]);
        % NOTE: Our MRSM not only can provides us with the mean of
        % prediction, but also the uncertainty in the precistion. this
        % uncertainty can be very useful since it quantifies how much we
        % expect our prediction is really acccurate!
    end
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now, that we the true and predicted output, we can calcualte the prediction error. 
error = (((sum(sum(abs(z_true-z_pred))))).^1)/(n*n);  % error calcualtion using MAE(mean absolute error)
error = sum(error)/3;                                 % calculate the mean of error


%% Plot the b th responses and the corresponding training points
b = 3;
z_true = reshape(z_true(:,:,b),n,n);
z_pred = reshape(z_pred(:,:,b),n,n);
figure
surf(X,Y,z_true');
hold on
surf(X,Y,z_pred');
hold on
plot3 (INPUT(:,1),INPUT(:,2),OUTPUT(:,b),'ob', 'MarkerFaceColor','b');
xlabel('x1'); ylabel('x2'); zlabel('out');
end

%% the objective functions... you can customize them and see the effect! 
function response = bmfun1(x)
response = 0.8*(1+x(:,1).^2+x(:,2).^2).*( 1+sin(2*pi*(x(:,1)-0.25)).*sin(2*pi*(x(:,2)-0.25)) );
end
function response = bmfun2(x)
response = 0+0.8*(1+x(:,1).^2+x(:,2).^2).*( 1+sin(2*pi*(x(:,1)-0.25)).*sin(2*pi*(x(:,2)-0.25)) );
end
function response = bmfun3(x)
response = 0.8*(1+x(:,1).^2+x(:,2).^2).*( 1+sin(2*pi*(x(:,1)-0.25)).*sin(2*pi*(x(:,2)-0.25)) );
end




