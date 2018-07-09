

clear all;
close all;
clc;



while (1==1)
    choice=menu('Face Detection',...
                'Create Database',...
                'Create Netwoek',...
                'Train Network',...
                'Test on Photos',...
                'Exit');
    if (choice ==1)
        run ('include/menuLoadImages.m');
    end
    if (choice == 2)
        run ('include/menuCreateNetwork.m');
    end    
    if (choice == 3)
        run ('include/menuTrainNetwork.m');
    end    
    if (choice == 4)
        run ('include/menuScanImage.m');
        
    end
    if (choice == 5)
        clear all;
        clc;
        close all;
        return;
    end    
end