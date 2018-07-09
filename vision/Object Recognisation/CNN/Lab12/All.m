clear all;
clc;

load('X.mat');
load('Y.mat');  

X=StandardizeData(X);

Y=StandardizeData(Y);
architecture=[336 100 20];
nn = InitializeNetwork(architecture);
random_feature=rand(1,336);
random_label=rand(1,20);
nn = ForwardPass(nn, random_feature);
nn = BackwardPass(nn, random_label);


[train_x, train_y, test_x, test_y] = splitData(X, Y);
nn=TrainNetwork(train_x,train_y);
preds=PredictNetwork(nn,test_x);


function Y=StandardizeData(X)
   % standardizes data
   %
   % Input:
   % - X: an n x d dimensional feature matrix where n is the number of observations, and d is the number of features.
   % Output:
   % - X_new: an n x d dimensional normalized feature matrix.
   
   
%Number of observations
N=length(X(:,1));
%Number of variables
M=length(X(1,:));
% output array of normalised values
Y=zeros(N,M);
   
   
   Y=X-repmat(mean(X),N,1);
        %normalize each observation by the standard deviation of that variable
        Y=Y./repmat(std(X,0,1),N,1);
   
end


function nn = InitializeNetwork(architecture)
    % initialize the network
    %
    % Input:
    % - architecture: an 1 x l dimensional vector indicating a number of nodes at each layer of a network. For instance, architecture(1) is the feature dimensionality, architecture(2) is the number of nodes in the first hidden layer, and so on.
    % Output:
    % - nn: a neural network structure storing randomly initialized parameters of a network in the variables nn.W{1},nn.W{2},etc.
    
    rand('state',0)  
    for i = 2 : size(architecture,2)
        if i==2
            rows = 100; %specificy the number of rows for the parameter matrix;
            cols = 336; %specify the number of columns in the parameter matrix;
            nn.W{i-1}= (rand(rows, cols) - 0.5) * 2 * 4 * sqrt(6 / (rows + cols));
        else
            rows = 20; %specificy the number of rows for the parameter matrix;
            cols = 100; %specify the number of columns in the parameter matrix;
            nn.W{i-1}= (rand(rows, cols) - 0.5) * 2 * 4 * sqrt(6 / (rows + cols));
        end
    end
end





function nn = ForwardPass(nn, x)
    % perform the forward pass inside the network
    %
    % Input:
    % - nn: a structure storing the parameters of the network
    % - x: a feature matrix where every row depicts a data observation, and every column represents a particular feature.
    % Output:
    % - nn: a new neural network variable where the values nn.a{l} are updated for every layer of the network.
    
    %setting the input to the network
    
    nn.a{1} = x';
    n_layers=numel(nn.W)+1;
    
    %% feedforward pass
    for i = 2 : n_layers
       % 1) Performing a matrix multiplication to compute the activation nodes for the current layer
      
           
       nn.z{i} = (nn.W{i-1})*(nn.a{i-1}); 
       
       % 2) Applying a non-linear sigmoid function on every activation node z
       nn.a{i} = 1./(1+exp(-nn.z{i}));     
    end
end







function nn = BackwardPass(nn,y)
    % perform the forward pass inside the network
    %
    % Input:
    % - nn: a structure storing the parameters of the network
    % - y: a ground truth indicator matrix, where y(i,j)=1 indicates that a data point i belongs to an object class j.
    % Output:
    % - nn: a new neural network variable where the values nn.gradZ{l} and nn.gradW{l} are updated for every layer of the network.
    
   
    %number of layers in a network
    n_layers=numel(nn.W)+1;
    
    %computing the overall error of the network
    error= nn.a{n_layers} - y';
    
    %computing the error gradient in the last layer of the network
    nn.gradZ{n_layers} = error .* (nn.a{n_layers} .* (1 - nn.a{n_layers}));
     
    %looping through the layers backwards
    for i = (n_layers-1) : -1 : 2
        
       
        
        % 1) Derivative of the Sigmoid function
        nn.gradSigm{i} =(nn.a{i}).*(1-nn.a{i});
        
        % 2) Derivative with respect to activation units a{i}
        nn.gradA{i} = ((nn.W{i})')*(nn.gradZ{n_layers});
        
        % 3) Derivative with respect to activation units z{i}           
        nn.gradZ{i} = (nn.gradSigm{i}).*(nn.gradA{i});  

    end

    % Computing the gradients with respect to the fully connected layer parameters
    for i = 1 : (n_layers - 1)
        
       
        
        % 4) Derivative with respect to the fully connected layer parameters W{i}
        nn.gradW{i} = (nn.gradZ{i+1})*((nn.a{i})');
        
        % Averaging over all examples in the batch
        nn.gradW{i}=nn.gradW{i}/size(y,1);
        
    end
end

function nn=TrainNetwork(train_x,train_y)
    % Train the network
    %
    % Input:
    % - train_x: n x d matrix storing n data observations with d features
    % - train_y: a ground truth indicator matrix, where y(i,j)=1 indicates that a data point i belongs to an object class j.
    % Output:
    % - nn: a variable storing the neural network structure.
    
    %% Network Initialization
    nn = InitializeNetwork([336 100 20]);
    n_layers=numel(nn.W)+1;


    %% Hyperparameters
    num_epochs=50;
    batch_size=100;
    num_batches=size(train_x,1)/batch_size;
    gamma=2;
      
    for i = 1 : num_epochs

        rand_idx = randperm(size(train_x,1));
        for j = 1 : num_batches
            batch_x = train_x(rand_idx((j - 1) * batch_size + 1 : j * batch_size), :);
            batch_y = train_y(rand_idx((j - 1) * batch_size + 1 : j * batch_size), :);

            %% Forward Pass
            nn= ForwardPass(nn,batch_x);
            
            %% Backward Pass
            nn= BackwardPass(nn,batch_y);
            
            %% Parameter Update
            for l = 1 : (n_layers - 1)
               nn.W{l} = nn.W{l}-gamma.*(nn.gradW{l});                 
            end
        end
    end  

end



function preds=PredictNetwork(nn,test_x)
    % produce the predictions of the trained network
    %
    % Input:
    % - nn: a structure storing the parameters of the network
    % - test_x: n x d dimensional feature matrix storing d dimensional feature for n data points
    % Output:
    % - preds: n x 1 matrix that stores the predicted object class indices ranging from values [1...20].

    %1) Perform the forward pass
    
    nn= ForwardPass(nn,test_x);
    
    %2) Select object classes cororesponding to maximum probabilities and store them into 'preds' variable
    preds= max(nn.a{end})';

end