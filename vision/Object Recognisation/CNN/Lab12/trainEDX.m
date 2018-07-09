clear all;
clc;

load('X.mat');
load('Y.mat');
[train_x, train_y, test_x, test_y] = splitData(X, Y);
nn=TrainNetwork(train_x,train_y);
preds=PredictNetwork(nn,test_x);


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