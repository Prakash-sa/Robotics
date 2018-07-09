% Version : 7.1
% Date : 2015-03-22
% Tested on MATLAB 2015b
% Author  : Omid Sakhi
% http://www.facedetectioncode.com

Face Detection Program for MATLAB 2013a
using Gabor Feature Extraction and Neural Networks
----------------------------------------------------------------

    1- copy all files and directories to the MATLAB's work folder
     * In order to run the program you must have Image Processing and Neural Networks Toolboxes

	2- (Important) Navigate to the root folder which contains "main.m".

    3- Type "main" or "run main" in the command window

	4. Only fort the first time, the program creates
		Gabor filters and stores them in ./data/gabor.mat
		Training set dataset and stores it in ./data/imgdb.mat 
		Neural Network and stores it in ./data/net.mat
		
	5- imgdb is short for "image data base".
	
    6- When the program menu appears click on "Train Network" and wait until the program is 
	   done with the training

    7- click on "Test on Photos". A file dialog appeares. Select a .jpg photo.
		The selected photo may contain several face images but the program can only
		detect faces that can be fit inside a 27x18 window.

    8- Wait until the program detects some faces.

Note*:
1) This program only detects faces that can fit inside a 27x18 window.
2) This program requires Image Processing and Neural Network Toolboxes.
3) This program is tested on MATLAB 2013a and probably will not work with
   older versions of MATLAB. If you want to run the program on an older 
   version of MATLAB please visit the original program.   
4) This version of program is modified to work with MATLAB 2013a and for
   some reason it is much slower than the original program. If you are
   interested in the original program please visit:
   http://www.mathworks.com/matlabcentral/fileexchange/11073-face-detection-system
	
For more information please visit the website. Thank you.
http://www.facedetectioncode.com
