clear all;

load('ImageDataTrain.mat');
Xtrain=StandardizeData(data.trainX); 

load('ImageDataTest.mat');
Xtest=StandardizeData(data.testX); 

function X_new=StandardizeData(X)
   % standardizes data
   %
   % Input:
   % - X: an n x d dimensional feature matrix where n is the number of observations, and d is the number of features.
   % Output:
   % - X_new: an n x d dimensional normalized feature matrix.
   
   [n,d]=size(X);
    sdd=zeros(1,n);
   r=zeros(1,n);
   var=zeros(1,n);
   for i=1:n
       r(1,n)=sum(X(n,:))/d;
       
       var(1,n)=sum(X(n,:).^2)/d - r(1,n);
   end
   
  
   sdd=var.^0.5;
   
   
   X_new=(X-r)/sdd;
end