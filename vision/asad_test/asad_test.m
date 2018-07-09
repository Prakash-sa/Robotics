function varargout = asad_test(varargin)
% ASAD_TEST M-file for asad_test.fig
%      ASAD_TEST, by itself, creates a new ASAD_TEST or raises the existing
%      singleton*.
%
%      H = ASAD_TEST returns the handle to a new ASAD_TEST or the handle to
%      the existing singleton*.
%
%      ASAD_TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ASAD_TEST.M with the given input arguments.
%
%      ASAD_TEST('Property','Value',...) creates a new ASAD_TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before asad_test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to asad_test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help asad_test

% Last Modified by GUIDE v2.5 20-May-2012 19:54:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @asad_test_OpeningFcn, ...
                   'gui_OutputFcn',  @asad_test_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before asad_test is made visible.
function asad_test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to asad_test (see VARARGIN)

% Choose default command line output for asad_test
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes asad_test wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = asad_test_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vid_flag;
global vid;

vid_flag=1;
vid = videoinput('winvideo',1,'YUY2_320x240');
set(vid,'FramesPerTrigger',15)
start(vid);
preview(vid)


 pre_axis_x=0;
   pre_axis_y=0;
   
  


while vid_flag==1
   org_frame = getsnapshot(vid);
   frame=rgb2gray(org_frame);
    title('basic frame')
   subplot(2,2,1);  
    imshow(frame);
   
 
   sample=imresize(frame,[42 24]);
   [usrID corL]= findRegisteredUserMatch(sample);
   if(~isempty(strfind(usrID,'USR')))
       strct_profile = get_profile(usrID);
       if(~isempty(strfind(strct_profile.type,'Person')))
           
           set(handles.text1,'string',['Hello Mr/Miss: ' strct_profile.name]);
           
       elseif(~isempty(strfind(strct_profile.type,'BackGround')))
           
           set(handles.text1,'string',['Normal View']);    
           
       elseif(~isempty(strfind(strct_profile.type,'Object')))
         set(handles.text1,'string',[usrID 'Object Found!']);
         
       else 
           set(handles.text1,'string','');
       end

    cb_val=get(handles.checkbox4,'value');
    ob_found_string = get(handles.edit1,'string');

    if(cb_val==1)
        if(usrID==ob_found_string)
        msgbox('object founded');
         s = serial('COM1','BaudRate',2400);
        fopen(s)
        fprintf(s,'1');
        fclose(s)
        delete(s);   
        
        pause(3.1);
        
          s = serial('COM1','BaudRate',2400);
        fopen(s)
        fprintf(s,'5');
        fclose(s)
        delete(s);   
        end    
    end
   end
    
   
   cb_val = get(handles.checkbox1,'value');
    cb_val_aoto = get(handles.checkbox3,'value');
   if(cb_val==1)
    bw_frame=basic_impro(frame);
    bw_frame = ~bw_frame;
    
    
     L = bwlabel(bw_frame);
    s  = regionprops(L,'Area','Centroid');
    maxArea = max([s.Area]);
    biggestArea = find([s.Area]==maxArea);
    
    centroids = cat(1, s(biggestArea).Centroid);
    
    subplot(2,2,2);  
    title('centroid')
    imshow(frame);
    axis_x = centroids(:,1);
    axis_y = centroids(:,2);
   
     if(pre_axis_x>axis_x)
         
         total_axis_dif_x=pre_axis_x-axis_x;
         x_direction_of_motion='right';
        
     else
         total_axis_dif_x=axis_x-pre_axis_x;
         x_direction_of_motion='left';
     end
     
     if(pre_axis_y>axis_y)
         
         total_axis_dif_y=pre_axis_y-axis_y;
          y_direction_of_motion='down';
     else
         total_axis_dif_y=axis_y-pre_axis_y;
         y_direction_of_motion='up';
     end
    
    if(total_axis_dif_x>29&&cb_val_aoto==0)
        if(cb_val_aoto==0)
        s = serial('COM1','BaudRate',2400);
        fopen(s)
        fprintf(s,'M');
        fclose(s)
        delete(s);   
        end
    x_motion_flag=1;
    
    set(handles.text_motion,'string',x_direction_of_motion);
    pause(0.1);
    else 
        x_motion_flag=0;
    end
    
    if(total_axis_dif_y>25)
        y_motion_flag=1;
        if(cb_val_aoto==0)
        s = serial('COM1','BaudRate',2400);
        fopen(s)
        fprintf(s,'M');
        fclose(s)
        delete(s);
        set(handles.text_motion,'string',y_direction_of_motion);
        pause(0.1);
        end
    else 
        y_motion_flag=0;
    end
    
    
    
    
    pre_axis_x=axis_x;
    pre_axis_y=axis_y;
   cb_val_aoto = get(handles.checkbox3,'value');
    if(cb_val_aoto==1&&(x_motion_flag||y_motion_flag))
        autonomus_bhr= randint(1,1,8);
        while (autonomus_bhr==0)
        autonomus_bhr= randint(1,1,8);
        end
          s = serial('COM1','BaudRate',2400);
        fopen(s)
        fprintf(s,num2str(autonomus_bhr));
        fclose(s)
        delete(s);   
         set(handles.text_motion,'string',['Autonomus: ' num2str(autonomus_bhr)]);
    else
         autonomus_bhr=0;
    end
    
     
    %if(x_motion_flag==1)
         %set(handles.text_motion,'string',[x_direction_of_motion  '=' num2str(x_motion_flag) ' ; ' y_direction_of_motion '=' num2str(y_motion_flag) ',autonomus_val= ' num2str( autonomus_bhr)]);
    %end
    %if(y_motion_flag==1)
    %end
    
    %set(handles.text_motion,'string',['x_dif= ' num2str(total_axis_dif_x) ' y_dif= ' num2str(total_axis_dif_y)]);
    
    
    
    hold on
    plot(axis_x, axis_y, 'm.')
    text(axis_x,axis_y,['values=(' num2str(axis_x) '),(' num2str(axis_y) ')'],'color','y','FontSize',14,'FontWeight','bold');
    hold off    
   
   end
   %imshow(bw_frame,handles.axes1);
    pause(0.1);
end




stop(vid);
delete(vid);
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vid_flag;

vid_flag=0;


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vid;
global vid_flag;
frame = getsnapshot(vid);
stop(vid);
delete(vid);
vid_flag=0;
frame=rgb2gray(frame);
figure,imshow(frame);
sample=imresize(frame,[42 24]);
        %just write for any future template ading
        imwrite(sample,'Cur_template.bmp');

        
 
msgbox('templated has been maded, Please save it firsts');        


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vid;
global vid_flag;
vid_flag=0;
%stop(vid);
%delete(vid);

answer = inputdlg('Enter Object ID:','Adding Sample',1);
usrID=cell2mat(answer);
ct=imread('Cur_template.bmp');
if(~isempty(usrID))
  add_sampleN_to_userN(usrID,ct);  
end


msgbox('Sample saved',usrID);
       


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



number_of_users=0;
try
load number_of_users number_of_users;
catch
    msgbox('no user found');
end
current_ID = number_of_users+1;

prompt={'Object Name:','Type: Person/Object'};


dlg_title=strcat('USR00',num2str(current_ID));
num_lines = 1;
answer = inputdlg(prompt,dlg_title,num_lines);
if(~isempty(answer))
    msgbox('Registered');
    number_of_users=current_ID;
    save('number_of_users','number_of_users');
    ct=imread('Cur_template.bmp');
    add_new_user(dlg_title, ct);
    insert_userProfile(dlg_title,answer);
else 
    msgbox('You canceled Registration');
end


%===============================================================

 function delete_existingUser(usrID_string)
       img_path_string =strcat('User_Templates\',usrID_string,'_mat.mat');
       delete(img_path_string);
       infor_path=strcat('User_Profile_info\',usrID_str,'.mat');
       delete(infor_path);


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1

value_of_this=get(handles.checkbox1,'Value');
%msgbox(num2str(value_of_this),'chkbox');
if(value_of_this==0)
 %   set(handles.axes2,'Visible','off');
    set(handles.text_motion,'Visible','off');
else 
  %  set(handles.axes2,'Visible','on');
    set(handles.text_motion,'Visible','on');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vid_flag;
vid_flag=1;

load sample1
load sample2
load sample3
load sample4
load whole_sample
load whole_sample2

% Define system parameters
framesize = 100;       % Framesize (samples)
Fs = 8000;            % Sampling Frequency (Hz)



% Setup data acquisition from sound card
ai = analoginput('winsound');
addchannel(ai, 1);

% Configure the analog input object.
set(ai, 'SampleRate', Fs);
set(ai, 'SamplesPerTrigger', framesize);
set(ai, 'TriggerRepeat',inf);
set(ai, 'TriggerType', 'immediate');

% Start acquisition
start(ai)


  nd1 = getdata(ai,ai.SamplesPerTrigger);    
  %pause(0.2);
  nd2 = getdata(ai,ai.SamplesPerTrigger);  
  %pause(0.2);
  nd3 = getdata(ai,ai.SamplesPerTrigger); 
  %pause(0.2);
  nd4 = getdata(ai,ai.SamplesPerTrigger); 
  %pause(0.2);
  
  whole_sample_d=[nd1 nd2 nd3 nd4];
    subplot(3,3,9);  
    plot(whole_sample_d);
    title('Voice Signal')
    xlabel('Time Domain')
    % Set RUNNING to zero if we are done 
  cr_sample1 = corr2(sample1,nd1);
  cr_sample2 = corr2(sample2,nd2);
  cr_sample3 = corr2(sample3,nd3);
  cr_sample4 = corr2(sample4,nd4);
  
  whole_cor= corr2(whole_sample,whole_sample_d);

  whole_cor2 = corr2(whole_sample2,whole_sample_d);
  
  if(whole_cor>whole_cor2)
      msgbox('s1 greater',num2str(whole_cor));
        if(whole_cor>0.1)
         s = serial('COM1','BaudRate',2400);
        fopen(s)
        fprintf(s,'3');     %up right hand
        fclose(s)
        delete(s);   
    
        end
  elseif(whole_cor2>whole_cor)
      msgbox('s2 greater',num2str(whole_cor2));
      if(whole_cor2>0.1)
        s = serial('COM1','BaudRate',2400);
        fopen(s)
        fprintf(s,'1');     %up right hand
        fclose(s)
        delete(s);  
        
        pause(3.1);
        
         s = serial('COM1','BaudRate',2400);
        fopen(s)
        fprintf(s,'5');     %up right hand
        fclose(s)
        delete(s);   
    
       
      
      end
  end
  
  
  
  
  
  



stop(ai);

% Disconnect/Cleanup
delete(ai);
clear ai;


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vid_flag;
vid_flag=1;

%load sample1
sample1=[];
sample2=[];
sample3=[];
sample4=[];


% Define system parameters
framesize = 100;       % Framesize (samples)
Fs = 8000;            % Sampling Frequency (Hz)



% Setup data acquisition from sound card
ai = analoginput('winsound');
addchannel(ai, 1);

% Configure the analog input object.
set(ai, 'SampleRate', Fs);
set(ai, 'SamplesPerTrigger', framesize);
set(ai, 'TriggerRepeat',inf);
set(ai, 'TriggerType', 'immediate');

% Start acquisition
start(ai)


  sample1 = getdata(ai,ai.SamplesPerTrigger);    
  %pause(0.2);
  sample2 = getdata(ai,ai.SamplesPerTrigger);  
  %pause(0.2);
  sample3 = getdata(ai,ai.SamplesPerTrigger); 
  %pause(0.2);
  sample4 = getdata(ai,ai.SamplesPerTrigger); 
  %pause(0.2);
  
  whole_sample=[sample1 sample2 sample3 sample4];
    subplot(3,3,9);  
    plot(whole_sample);
    title('Voice Signal')
    xlabel('Time Domain')
    % Set RUNNING to zero if we are done 
  save('sample1','sample1');
  save('sample2','sample2');
  save('sample3','sample3');
  save('sample4','sample4');
  save('whole_sample','whole_sample');
  msgbox('sample of sound saved','sound');


stop(ai);

% Disconnect/Cleanup
delete(ai);
clear ai;


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global vid_flag;
vid_flag=1;

%load sample1
sample1=[];
sample2=[];
sample3=[];
sample4=[];


% Define system parameters
framesize = 100;       % Framesize (samples)
Fs = 8000;            % Sampling Frequency (Hz)



% Setup data acquisition from sound card
ai = analoginput('winsound');
addchannel(ai, 1);

% Configure the analog input object.
set(ai, 'SampleRate', Fs);
set(ai, 'SamplesPerTrigger', framesize);
set(ai, 'TriggerRepeat',inf);
set(ai, 'TriggerType', 'immediate');

% Start acquisition
start(ai)


  sample1 = getdata(ai,ai.SamplesPerTrigger);    
  pause(0.2);
  sample2 = getdata(ai,ai.SamplesPerTrigger);  
  pause(0.2);
  sample3 = getdata(ai,ai.SamplesPerTrigger); 
  pause(0.2);
  sample4 = getdata(ai,ai.SamplesPerTrigger); 
  pause(0.2);
  
  whole_sample2=[sample1 sample2 sample3 sample4];
    subplot(3,3,9);  
    plot(whole_sample2);
    title('Voice Signal')
    xlabel('Time Domain')
    % Set RUNNING to zero if we are done 
  save('whole_sample2','whole_sample2');
  msgbox('sample of sound saved','sound');


stop(ai);

% Disconnect/Cleanup
delete(ai);
clear ai;

