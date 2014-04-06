function varargout = QuickHIS(varargin)
% QUICKHIS MATLAB code for QuickHIS.fig
%      QUICKHIS, by itself, creates a new QUICKHIS or raises the existing
%      singleton*.
%
%      H = QUICKHIS returns the handle to a new QUICKHIS or the handle to
%      the existing singleton*.
%
%      QUICKHIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QUICKHIS.M with the given input arguments.
%
%      QUICKHIS('Property','Value',...) creates a new QUICKHIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before QuickHIS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to QuickHIS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help QuickHIS

% Last Modified by GUIDE v2.5 06-Apr-2014 00:19:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @QuickHIS_OpeningFcn, ...
                   'gui_OutputFcn',  @QuickHIS_OutputFcn, ...
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


% --- Executes just before QuickHIS is made visible.
function QuickHIS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to QuickHIS (see VARARGIN)

% Choose default command line output for QuickHIS
handles.output = hObject;
handles.fileName = [];
handles.path = [];

% Update handles structure
guidata(hObject, handles);

addpath('bfmatlab');


% UIWAIT makes QuickHIS wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = QuickHIS_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function uiFileOpenBtn_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uiFileOpenBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, path] = uigetfile('*.HIS','Select the Hamamatsu stream file');
handles.filename = filename;
handles.path = path;
set(handles.textboxFN, 'String', filename);

handles.data = bfopen(strcat(handles.path, handles.filename));
maxVal = size(handles.data, 1);
stepVal = 1 / (maxVal - 1);
set(handles.sliderFrame,'Min', 1, 'Max', maxVal, 'Sliderstep', [stepVal , stepVal], 'Value', 1);
imshow(handles.data{1,1}{1,1}, 'Parent', handles.axesFrame);
guidata(hObject, handles);

% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)  
setpos(handles.textboxFN, '0.05nz 0.9nz 0.9nz 0.1nz');
setpos(handles.axesFrame, '0.1nz 0.2nz 0.8nz 0.8nz');
setpos(handles.sliderFrame, '0.05nz 0.05nz 0.9nz 0.1nz');
setpos(handles.btnExport, '0.05nz 0.01nz 0.9nz 0.1nz');


% --- Executes on slider movement.
function sliderFrame_Callback(hObject, eventdata, handles)
% hObject    handle to sliderFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
value = round(get(hObject,'Value'));
set (handles.textboxFN, 'String', value);
imshow(imadjust(handles.data{value,1}{1,1}), 'Parent', handles.axesFrame);

% --- Executes during object creation, after setting all properties.
function sliderFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in btnExport.
function btnExport_Callback(hObject, eventdata, handles)
% hObject    handle to btnExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
currentFrame = round(get(handles.sliderFrame, 'Value'));
adjustedFrame = imadjust(handles.data{currentFrame,1}{1,1});
[FileName, PathName] = uiputfile('*.png', 'Save As'); %# <-- dot
if PathName==0, return; end
Name = fullfile(PathName,FileName);  %# <--- reverse the order of arguments
imwrite(adjustedFrame, Name, 'png');
