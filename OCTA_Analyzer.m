%%% OCTA-Analyzer

function varargout = OCTA_Analyzer(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @OCTA_Analyzer_OpeningFcn, ...
    'gui_OutputFcn',  @OCTA_Analyzer_OutputFcn, ...
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



function OCTA_Analyzer_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
handles.dataa = 2;
handles.onh = 0;
handles.flag_size = 0;
handles.flag_ok = 0;
handles.flag_d = 0;
handles.flag_s =0;
guidata(hObject, handles);


function varargout = OCTA_Analyzer_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;

%% Region Selection
function popupmenu1_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
selectedIndex = get(handles.popupmenu1, 'value');

switch selectedIndex
    case 1
        handles.dataa = 2;
    case 2
        handles.dataa = 1;
        handles.flag_slider = 1;
        handles.flag_th =1;
        handles.flag_auto =0;
%         handles.onh = 0;
    case 3
        handles.dataa = 0;       
        
end
guidata(hObject,handles)

function popupmenu1_CreateFcn(hObject, eventdata, handles)
handles = guidata(hObject);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject,handles)


%% Image Browsing
function pushbutton1_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
if (handles.dataa == 1)
    [FileName,PathName]= uigetfile({'*.png' ;'*.jpeg';'*.bmp'});
    i = fullfile(PathName,FileName);
    img = imread(i);
    axes(handles.axes1);
    imshow(img);
    name = strsplit(FileName,{'.'});
    handles.name= name{1};
    handles.org_img=imread(i);
    handles.flag_slider = 1;
elseif (handles.dataa == 0)
    clear i name
    [FileName,PathName]= uigetfile({'*.bmp' ;'*.jpeg';'*.png'},'Select Deep Capillary Plexus');
    i = fullfile(PathName,FileName);
    img_deep = imread(i);
    axes(handles.axes7);
    imshow(img_deep);
    name_deep = strsplit(FileName,{'.'});
    handles.name_deep= name_deep{1};
    deep_img=imread(i);
    handles.deep_img = deep_img(:,:,1);
    clear i name
    [FileName,PathName]= uigetfile({'*.bmp' ;'*.jpeg';'*.png'},'Select Superficial Plexus');
    i = fullfile(PathName,FileName);
    img_superfcl = imread(i);
    axes(handles.axes8);
    imshow(img_superfcl);
    name = strsplit(FileName,{'.'});
    handles.name= name{1};
    superfcl_img=imread(i);
    handles.superfcl_img = superfcl_img(:,:,1);
    handles.display_b = 0;
else 
    h = msgbox('Please Select a Region First!','Error');

end

guidata(hObject,handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Deep Optic Nerve%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Deep Optic Nerve Data Type Selection
function popupmenu3_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
selectedIndex = get(handles.popupmenu3, 'value');
switch selectedIndex
    case 2
        handles.onh = 1;
    case 3
        handles.onh = 2;
    case 1
        handles.onh = 3;
end
guidata(hObject,handles)

function popupmenu3_CreateFcn(hObject, eventdata, handles)
handles = guidata(hObject);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject,handles)


%% Automatic Segmentation
function pushbutton2_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
if (handles.onh == 0)
     h = msgbox('Please Select a Deep Optic Nerve Data Type First!','Error');
     return;
end
if (handles.onh == 3)
     h = msgbox('Please Select a Deep Optic Nerve Data Type First!','Error');
     return;
end
tt_img = handles.org_img;
tt_img = rgb2gray(tt_img);
t_img = double(tt_img)<20;
% figure;imshow(t_img);
[mm,nn]=size(t_img);
cc=0;
for ii=1:mm
    for jj =1:nn
        if(t_img(ii,jj)==1)
            cc=cc+1;
        end
    end
end

if (handles.onh == 1)
    if (cc > 10000)
      h = msgbox('Wrong Choice! Please Select The Correct Type!','Error');
      return;
    end
    h = waitbar(0.8,'Please wait...');
    [img,r,center,counter_cir_hol]=auto_segmentation_pure(handles.org_img);
elseif (handles.onh == 2)
    if (cc < 10000)
      h = msgbox('Wrong Choice! Please Select The Correct Type!','Error');
      return;
    end
    h = waitbar(0.8,'Please wait...');
    [img,r,center,counter_cir_hol]=auto_segmentation_darkdisk(handles.org_img);
end
axes(handles.axes2);
imshow(img);
handles.auto_img=img;
handles.r=r;
handles.center=center;
handles.counter_cir_hol=counter_cir_hol;
handles.manu_img=handles.auto_img;
handles.flag_auto = 1;
close(h);
guidata(hObject, handles);


%% Manual Segmentation
function pushbutton3_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
if (handles.onh == 0)
     h = msgbox('Please Select a Deep Optic Nerve Data Type First!','Error');
     return;
end
if (handles.flag_auto == 0)
     h = msgbox('Please Use Automatic Segmentation First!','Error');
     return;
end
button = questdlg('Would you like to correct the segmentation?','Please answer','Yes','No','No');
switch button
    case 'Yes'
        t_fig = figure;
        imshow(handles.manu_img);
        img = manual_segmentation(handles.manu_img);
        axes(handles.axes3);
        imshow(img);
        handles.manu_img=img;
        close(t_fig)
    case 'No'
        handles.manu_img= handles.manu_img;
        axes(handles.axes3);
        imshow(handles.manu_img);
end
guidata(hObject, handles);


%% Display Circles
function pushbutton4_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
if (handles.flag_auto == 0)
     h = msgbox('Please Use Automatic Segmentation First!','Error');
     return;
end
handles.org_img_c = handles.org_img;
handles.org_img_c =Circle_Drawing(handles.org_img_c,handles.r,handles.center);
axes(handles.axes1);
imshow(handles.org_img_c);
handles.auto_img = Circle_Drawing(handles.auto_img,handles.r,handles.center);
axes(handles.axes2);
imshow(handles.auto_img);
handles.manu_img = Circle_Drawing(handles.manu_img,handles.r,handles.center);
axes(handles.axes3);
imshow(handles.manu_img);

guidata(hObject, handles);

%% Thresholding
function slider2_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
slider_val = get(hObject, 'Value');
handles.slider_val= round(slider_val*255);
if(handles.flag_th == 0)
    handles.I_Th_slider = handles.I_Th_org > handles.slider_val;
    axes(handles.axes11);
    imshow(handles.I_Th_slider);
end
set(handles.edit2, 'String', handles.slider_val);
handles.flag_slider = 0;
guidata(hObject, handles);

function slider2_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function edit2_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
guidata(hObject, handles);

function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% VD Calculation
function pushbutton5_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
if (handles.flag_auto == 0)
     h = msgbox('Please Use Automatic Segmentation First!','Error');
     return;
end
I_Th = rgb2gray(handles.org_img);
handles.I_Th_org = rgb2gray(handles.org_img);
if (handles.flag_slider == 0)
    slider_val = handles.slider_val;
    I_Th = I_Th > slider_val;
    handles.I_Th = I_Th;
elseif(handles.flag_slider == 1)
    I_Th = imbinarize(I_Th,'adaptive','ForegroundPolarity','dark','Sensitivity',1);
    handles.I_Th = I_Th;
    handles.flag_th = 0;
    axes(handles.axes11);
    imshow(handles.I_Th);
end
manu=intrsctn_on_union(handles.r,handles.center,handles.manu_img,handles.auto_img,I_Th,handles.counter_cir_hol);
button = questdlg('Would you like to save the results?','Please answer','Yes','No','No');
switch button
    case 'Yes'
        user_path = userpath;
        defaultfilename=fullfile(user_path,'*.*');
        [basefilename,folder]=uiputfile(defaultfilename,' PATH & NAME ');
        if basefilename == 0
            return;
        end
        FullFileName = fullfile(folder,basefilename);
        h = waitbar(0.7,'Please wait...');
        file = strcat(FullFileName,'.xlsx');
        if (handles.flag_slider == 0)
            file_format(1,:)=[handles.slider_val,manu.whole_ratio,manu.inner_whole_ratio,manu.outer_whole_ratio,...
                manu.inner_up_ratio,manu.outer_up_ratio,manu.inner_down_ratio,...
                manu.outer_down_ratio];
            param ='Selected_TH.WR.IWR.OWR.ITR.OTR.IDR.ODR';
        elseif(handles.flag_slider == 1)
            file_format(1,:)=[manu.whole_ratio,manu.inner_whole_ratio,manu.outer_whole_ratio,...
                manu.inner_up_ratio,manu.outer_up_ratio,manu.inner_down_ratio,...
                manu.outer_down_ratio];
            param ='WR.IWR.OWR.ITR.OTR.IDR.ODR';
        end
        parameter = strsplit(param,{'.'});
        xlswrite(file, parameter,'Sheet1','B1');
        xlswrite(file,{handles.name},'Sheet1','A2')
        xlswrite(file,file_format,'Sheet1','B2');
        close(h);
end
guidata(hObject, handles);

%%Reset
function pushbutton19_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
I_Th = rgb2gray(handles.org_img);
handles.I_Th_org = rgb2gray(handles.org_img);
I_Th = imbinarize(I_Th,'adaptive','ForegroundPolarity','dark','Sensitivity',1);
handles.I_Th = I_Th;
handles.flag_th = 0;
axes(handles.axes11);
imshow(handles.I_Th);
handles.flag_slider = 1;
guidata(hObject,handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Macular Data%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Display Binary Images
function pushbutton17_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
threshold1 = graythresh(handles.deep_img);
handles.deep_dataa = handles.deep_img > threshold1*255;
axes(handles.axes7);
imshow(handles.deep_dataa);
threshold2 = graythresh(handles.superfcl_img);
handles.sprfcal_dataa = handles.superfcl_img > threshold2*255;
axes(handles.axes8);
imshow(handles.sprfcal_dataa);
handles.display_b = 1;
guidata(hObject, handles);

%%Deep Image Object Removing
function slider8_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
if (handles.display_b == 0)
     h = msgbox('Please Use Display Binary First!','Error');
     return;
end
x = get(hObject, 'Value');
handles.deep_remover= round(x*500);
if isempty(x)
    handles.deep_remover = 100;
end
handles.C = bwareaopen(handles.deep_dataa,handles.deep_remover);
axes(handles.axes7);
imshow(handles.C);
handles.flag_d =1;
set(handles.edit7, 'String', handles.deep_remover);
guidata(hObject, handles);

function slider8_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%%Superficial Image Object Removing
function slider5_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
if (handles.display_b == 0)
     h = msgbox('Please Use Display Binary First!','Error');
     return;
end
x = get(hObject, 'Value');
% handles.deep_remover = 100;
handles.sprfcal_remover= round(x*8000);
if isempty(x)
    handles.sprfcal_remover = 200;
end
handles.C = bwareaopen(handles.deep_dataa,handles.deep_remover);
handles.D = bwareaopen(handles.sprfcal_dataa,handles.sprfcal_remover);
axes(handles.axes8);
imshow(handles.D);
handles.flag_s =1;
set(handles.edit8, 'String', handles.sprfcal_remover);
guidata(hObject, handles);

function slider5_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%%Macula Segmentation
function pushbutton15_Callback(hObject, eventdata, handles)

handles = guidata(hObject);
if (handles.flag_size == 0)
     h = msgbox('Please Select an Image Size!','Error');
     return;
end
if (handles.flag_s == 0)
     h = msgbox('Please Remove Objects from Superficial Image First!','Error');
     return;
end
if (handles.flag_d == 0)
     h = msgbox('Please Remove Objects from Deep Image First!','Error');
     return;
end
axes(handles.axes10);
imshow(handles.deep_img);
[A,gg,x_center,y_center] = macula_segmentation(handles.deep_dataa,handles.C,handles.D);
handles.A = A;
handles.G=gg;
axes(handles.axes10);
hold on
plot(y_center,x_center,'.g')
hold on
imshow(handles.deep_img);
hold on
plot(y_center,x_center,'.g')
button = questdlg('Would you like to change the macula center?','Yes','No','Yes','Yes');
switch button
    case 'Yes'
        figure;
        imshow(handles.deep_img);
        hold on
        [x_center,y_center]=ginput(1);
        plot(x_center,y_center,'.g')      
end
handles.x_center=x_center;
handles.y_center=y_center;
img_I = Sector_Drawing( handles.img_size,handles.G,x_center, y_center);
axes(handles.axes10);
imshow(img_I);
hold on
plot(x_center,y_center,'.g')
handles.flag_ok = 1;
guidata(hObject, handles);

%%VD Calculation
function pushbutton16_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
if (handles.flag_ok == 0)
     h = msgbox('Please Press Ok First!','Error');
     return;
end
im_size=handles.img_size;
flag = 1;
if ((im_size == 7)|| (im_size==6))
    flag=0;
    Rate_deep= ratio(handles.deep_dataa,handles.y_center,handles.x_center);
    Rate_superficial= ratio(handles.sprfcal_dataa,handles.y_center,handles.x_center);
    Rate_out= ratio(handles.G,handles.y_center,handles.x_center);
end
if ((im_size == 5)|| (im_size==4)|| (im_size==3))
    flag=1;
    Rate_deep= rate(handles.deep_dataa,handles.y_center,handles.x_center);
    Rate_superficial= rate(handles.sprfcal_dataa,handles.y_center,handles.x_center);
    Rate_out= rate(handles.G,handles.y_center,handles.x_center);
end
user_path = userpath;
defaultfilename=fullfile(user_path,'*.*');
[basefile,folder]=uiputfile(defaultfilename,' Select a Path ');
if basefile == 0
    return;
end
h = waitbar(0.6,'Please wait...');
switch flag
    case 0
        for n_img = 1:3
            switch n_img
                case 1
                    
                    basefilename = strcat(basefile,'_deep');
                    file_format(1,:)=[handles.deep_remover,handles.sprfcal_remover,Rate_deep.up_ratio_cir1,Rate_deep.down_ratio_cir1,Rate_deep.down_cir2,Rate_deep.up_cir2,...
                        Rate_deep.down_cir3,Rate_deep.up_cir3,Rate_deep.whole_cir3,Rate_deep.whole_cir2,Rate_deep.whole_cir2];
                    
                case 2
                    
                    basefilename = strcat(basefile,'_superficial');
                    file_format(1,:)=[handles.deep_remover,handles.sprfcal_remover,Rate_superficial.up_ratio_cir1,Rate_superficial.down_ratio_cir1,Rate_superficial.down_cir2,Rate_superficial.up_cir2,...
                        Rate_superficial.down_cir3,Rate_superficial.up_cir3,Rate_superficial.whole_cir3,Rate_superficial.whole_cir2,Rate_superficial.whole_cir1];
                    
                case 3
                    
                    basefilename = strcat(basefile,'_out');
                    file_format(1,:)=[handles.deep_remover,handles.sprfcal_remover,Rate_out.up_ratio_cir1,Rate_out.down_ratio_cir1,Rate_out.down_cir2,Rate_out.up_cir2,...
                        Rate_out.down_cir3,Rate_out.up_cir3,Rate_out.whole_cir3,Rate_out.whole_cir2,Rate_out.whole_cir1];
            end
            FullFileName = fullfile(folder,basefilename);
            file = strcat(FullFileName,'.xlsx');
            param =' pxl_deep.pxl_suprficial.FTR.FDR.SDR.STR.TDR.TTR.TWR.SWR.FWR';
            parameter = strsplit(param,{'.'});
            xlswrite(file, parameter,'Sheet1','B1');
            xlswrite(file,{handles.name},'Sheet1','A2')
            xlswrite(file,file_format,'Sheet1','B2');            
        end
        
    case 1
        for n_img = 1:3
            switch n_img
                case 1
                    
                    basefilename = strcat(basefile,'_deep');
                    file_format(1,:)=[Rate_deep.up_ratio_cir1,Rate_deep.down_ratio_cir1,Rate_deep.down_cir2,Rate_deep.up_cir2,Rate_deep.whole_cir1,Rate_deep.whole_cir2];
                    
                case 2
                    
                    basefilename = strcat(basefile,'_superficial');
                    file_format(1,:)=[Rate_superficial.up_ratio_cir1,Rate_superficial.down_ratio_cir1,Rate_superficial.down_cir2,Rate_superficial.up_cir2,Rate_superficial.whole_cir1,Rate_superficial.whole_cir2];
                    
                case 3
                    
                    basefilename = strcat(basefile,'_out');
                    file_format(1,:)=[Rate_out.up_ratio_cir1,Rate_out.down_ratio_cir1,Rate_out.down_cir2,Rate_out.up_cir2,Rate_out.whole_cir1,Rate_out.whole_cir2];
            end            
            
            FullFileName = fullfile(folder,basefilename);
            file = strcat(FullFileName,'.xlsx');
            param =' FTR.FDR.SDR.STR.FWR.SWR';
            parameter = strsplit(param,{'.'});
            xlswrite(file, parameter,'Sheet1','B1');
            xlswrite(file,{handles.name},'Sheet1','A2')
            xlswrite(file,file_format,'Sheet1','B2');
        end
end
close(h);
guidata(hObject, handles);

%% Image Size
function popupmenu2_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
selectedIndex = get(handles.popupmenu2, 'value');
switch selectedIndex
    case 2
        handles.img_size = 7;
    case 3
        handles.img_size = 6;
    case 4
        handles.img_size = 5;
    case 5
        handles.img_size = 4;
    case 6
        handles.img_size = 3;
end
handles.flag_size = 1;
guidata(hObject,handles)

function popupmenu2_CreateFcn(hObject, eventdata, handles)

handles = guidata(hObject);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject,handles)

%%Clear
function pushbutton6_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
cla(handles.axes1);
cla(handles.axes2);
cla(handles.axes3);
cla(handles.axes7);
cla(handles.axes8);
cla(handles.axes10);
cla(handles.axes11);
handles.flag_slider = 1;
handles.flag_th =1;
set(handles.edit2, 'String', 'Threshold');



function edit7_Callback(hObject, eventdata, handles)


function edit7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)


function edit8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
