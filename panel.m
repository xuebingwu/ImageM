function varargout = panel(varargin)
% PANEL M-file for panel.fig
%      PANEL, by itself, creates a new PANEL or raises the existing
%      singleton*.
%
%      H = PANEL returns the handle to a new PANEL or the handle to
%      the existing singleton*.
%
%      PANEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PANEL.M with the given input arguments.
%
%      PANEL('Property','Value',...) creates a new PANEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before panel_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to panel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help panel

% Last Modified by GUIDE v2.5 24-Jan-2010 21:54:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @panel_OpeningFcn, ...
                   'gui_OutputFcn',  @panel_OutputFcn, ...
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


% --- Executes just before panel is made visible.
function panel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLABa
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to panel (see VARARGIN)

% Choose default command line output for panel
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% get main GUI handles
hmain = varargin{1};

% get main GUI data
UserData=get(hmain.figure1,'UserData');

pUserData=get(handles.figure1,'UserData');
pUserData.image = UserData.reference;
pUserData.image_size = size(pUserData.image);
if numel(pUserData.image_size) < 3
    pUserData.image_size(3) = 1;
end
pUserData.current_slice = 1;
if isfield(UserData,'refname')
    pUserData.name = UserData.refname;
else
    pUserData.name = 'Unknow filename'
end
set(handles.figure1,'UserData',pUserData);

% set window title
set(handles.figure1,'Name',pUserData.name);

% show image
figure(handles.figure1);
imagesc(pUserData.image(:,:,pUserData.current_slice));
colormap gray;axis square;axis off;

% show image information
text(0,-10,[num2str(pUserData.current_slice) '/' num2str(pUserData.image_size(3)) ': ' ...
    num2str(pUserData.image_size(1)) 'X' num2str(pUserData.image_size(2)) ' pixels;' ...
    pUserData.name])

% setup the slider
set(handles.slider1,'Min',1);
set(handles.slider1,'Max',pUserData.image_size(3));
set(handles.slider1,'SliderStep',[1/pUserData.image_size(3) 0.25]);
set(handles.slider1,'Value',1);

% UIWAIT makes panel wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = panel_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


pUserData=get(handles.figure1,'UserData');
pUserData.current_slice = floor(get(hObject,'Value'));

figure(handles.figure1);
imagesc(pUserData.image(:,:,pUserData.current_slice));drawnow;
colormap gray;axis square;axis off;
text(0,0,'');
text(0,-10,[num2str(pUserData.current_slice) '/' num2str(pUserData.image_size(3)) ': ' ...
    num2str(pUserData.image_size(1)) 'X' num2str(pUserData.image_size(2)) ' pixels;' ...
    pUserData.name])
set(handles.figure1,'UserData',pUserData);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over slider1.
function slider1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on scroll wheel click while the figure is in focus.
function figure1_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)
pUserData=get(handles.figure1,'UserData');
eventdata.VerticalScrollCount
    pUserData.current_slice =  pUserData.current_slice + eventdata.VerticalScrollCount;
    pUserData.current_slice
    pUserData.image_size(3)
    if pUserData.current_slice > pUserData.image_size(3)
        pUserData.current_slice = 1;
    elseif pUserData.current_slice <1
        pUserData.current_slice = pUserData.image_size(3);
    end
    set(handles.slider1,'Value',pUserData.current_slice);
    figure(handles.figure1)
imagesc(pUserData.image(:,:,pUserData.current_slice));drawnow;
colormap gray;axis square;axis off;
text(0,-10,[num2str(pUserData.current_slice) '/' num2str(pUserData.image_size(3)) ': ' ...
    num2str(pUserData.image_size(1)) 'X' num2str(pUserData.image_size(2)) ' pixels;' ...
    pUserData.name])

set(handles.figure1,'UserData',pUserData);
