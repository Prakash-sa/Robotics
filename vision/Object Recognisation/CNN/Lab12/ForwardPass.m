
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
