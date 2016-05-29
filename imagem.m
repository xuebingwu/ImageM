function varargout = imagem(varargin)
% imagem M-file for imagem.fig
%
%      imagem, by itself, creates a new imagem or raises the existing
%      singleton*.
%
%      H = imagem returns the handle to a new imagem or the handle to
%      the existing singleton*.
%
%      imagem('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in imagem.M with the given input arguments.
%
%      imagem('Property','Value',...) creates a new imagem or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imagem_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imagem_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imagem

% Last Modified by GUIDE v2.5 01-Feb-2010 20:47:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @imagem_OpeningFcn, ...
    'gui_OutputFcn',  @imagem_OutputFcn, ...
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

% --- Executes just before imagem is made visible.
function imagem_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imagem (see VARARGIN)

% Choose default command line output for imagem
handles.output = hObject;

% This sets up the initial page
if strcmp(get(hObject,'Visible'),'off')
    % set windows title
    set(gcf,'Name','ImageM: RNA FISH image analysis at AvO lab')
    plot(1)
    axis off;
    % message
    title('Welcome to ImageM','FontSize',18,'Color','b');drawnow;
    text(0.3,1.8,{'ImageM is a MATLAB package with GUI for RNA FISH image analysis,',...
        'such as counting single molecules and assigning them to individual cells.',...
        'The package is written by Xuebing Wu, Zi Peng Fan and Shalev Itzkovitz,',...
        'on the basis of scripts previously used in Alexander van Oudenaarden''s lab',...
        'at Massachusetts Institute of Technology. '},...
        'HorizontalAlignment','left')
end

% UIWAIT makes imagem wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% change window position/size here
% screen_size = get(0, 'ScreenSize')
% position = get(handles.figure1, 'Position')
% set(handles.figure1, 'Position',[screen_size(3)/2 position(2) screen_size(3)/2 position(4)])
% set(handles.figure1, 'Position',[screen_size(3)/2 position(2) screen_size(3)/2 position(4)])

% initialization of user dadta
Initialization(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = imagem_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- initialize UserData
function Initialization(hObject, eventdata, handles)
UserData=get(handles.figure1,'UserData');
UserData.stack_range=[1 1000];% stack filter [min,max]

%status: indicator of progress
UserData.status.loaded = 0;
UserData.status.projected = 0;
UserData.status.enhanced = 0;
UserData.status.cropped = 0 ;
UserData.status.segmented = 0;
UserData.status.counted = 0;
UserData.status.saved = 0;

UserData.status.changed = 0; % data changed, need save now

% laplacian filter
UserData.N= 15;%
UserData.sigma = 1.5;%

% # of intensity thresholds when counting dots
UserData.n_thresholds = 100;

%auto-thresholding parameters
UserData.auto_thresholding.width=5;
UserData.auto_thresholding.offset = 10;

%default projection method
UserData.projection_method='cv';

% default enhance method
UserData.enhance_method = 'imadjust';

% cell information
UserData.cell = [];
% struct array
% cell.label: a character.
% cell.edge: N-by-2 matrix, each row is a point. together is a polygon.
% cell.center: [x,y], calculated as the mean of cell.edge
% cell.area: area of the cell defined by cell.edge

% dot information
UserData.dots = [];
% for column
% 1-3: 3D position
% 4: channel
% 5: cell
% 6: outline projection

% original image file, multiple stacks
UserData.I = [];

% projected images
UserData.I2 = [];

% enhanced/cropped image
UserData.I3 = [];

% scale compared to cropped image
UserData.scale =[1 1];

% size of original image
UserData.image_size = [];

% save path and file name
UserData.save_path = [];
UserData.save_name = [];

% crop region
UserData.BW = [];
UserData.RECT = [];

% reference image
UserData.reference = [];

% skeleton for relabel cells
UserData.skeleton = [];

% channels that are counted
UserData.channel_name = [];

% dots summary
UserData.num_dot_cell_channel = [];
% each row is a cell
% each column is a channel

% normalized dots summary
UserData.num_dot_cell_channel_normalized = [];

% outline for projecting dots
UserData.outline = [];

% neighboring cells
UserData.neighbors = [];
% each row contains the indices of two cells that are defined as neighbors

UserData.version = 2;

set(handles.figure1,'UserData',UserData);

% enable all commands, responds to menu
% --------------------------------------------------------------------
function enable_all_Callback(hObject, eventdata, handles)
% hObject    handle to enable_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.previous,'Enable','on');% toolbar button, previous stack
set(handles.next,'Enable','on');% toolbar button, next stack
set(handles.projection,'Enable','on');% toolbar button, projection
set(handles.crop,'Enable','on');% toolbar button, crop image
set(handles.save,'Enable','on');% toolbar button, save
set(handles.save_menu,'Enable','on'); % menu item,
set(handles.ProjectionMenu,'Enable','on');% menu item, projection
set(handles.open_saved,'Enable','on');% menu item, open saved results
set(handles.image,'Enable','on');% menu item, image enhance
set(handles.image_enhance,'Enable','on');% toolbar button, image enhance
set(handles.segment,'Enable','on');%toolbar button, segment cells
set(handles.count,'Enable','on');% toolbar, count dots
set(handles.count_dots,'Enable','on') %menu
set(handles.analyze,'Enable','on');% menu, analyze
set(handles.compare_neighbor,'Enable','on');%menu,analyze->neighbor cell->
set(handles.checkbox3,'Visible','on')% dots
set(handles.checkbox4,'Visible','on')% cells
set(handles.checkbox5,'Visible','on')% outline
set(handles.checkbox6,'Visible','on')% projection
set(handles.resetcelllabel,'Enable','on')% menu
set(handles.plot_counts,'Enable','on')%menu
set(handles.neighbor_cell,'Enable','on')%menu
set(handles.detect_bg_dots,'Enable','on');%menu
set(handles.uipanel1,'Visible','on')%show channel
set(handles.plot_cryptogram,'Enable','on');%menu

% enable components under different conditions to ensure the right order of
% actions
% --------------------------------------------------------------------
function enable_components(UserData,handles)
if UserData.status.loaded
    set(handles.previous,'Enable','on');
    set(handles.next,'Enable','on');
    set(handles.projection,'Enable','on');
    set(handles.ProjectionMenu,'Enable','on');
    set(handles.open_saved,'Enable','on');
    set(handles.image,'Enable','on')
    set(handles.analyze,'Enable','on');
end
if UserData.status.projected
    set(handles.crop,'Enable','on');
    set(handles.save_menu,'Enable','on');
    set(handles.image,'Enable','on');
    set(handles.image_enhance,'Enable','on');
    set(handles.count,'Enable','on');
    set(handles.count_dots,'Enable','on');
    set(handles.segment,'Enable','on');
end
if UserData.status.cropped
    set(handles.crop,'Enable','off');
    set(handles.projection,'Enable','off');
    set(handles.ProjectionMenu,'Enable','off');
end

if UserData.status.counted
    set(handles.image_enhance,'Enable','off');
    set(handles.image,'Enable','off');
end
if UserData.status.changed
    set(handles.save,'Enable','on');
else
    set(handles.save,'Enable','off');
end

if ~isempty(UserData.dots)
    set(handles.detect_bg_dots,'Enable','on');
    set(handles.uipanel1,'Visible','on')
    set(handles.checkbox3,'Visible','on')
    set(handles.plot_cryptogram,'Enable','on');
    set(handles.analyze,'Enable','on');
    if ~isempty(UserData.cell)
        set(handles.plot_counts,'Enable','on')
        set(handles.neighbor_cell,'Enable','on')
    else
        set(handles.plot_counts,'Enable','off')
        set(handles.neighbor_cell,'Enable','off')
    end
else
    set(handles.checkbox3,'Visible','off')
end

if isempty(UserData.cell)
    set(handles.checkbox4,'Visible','off')
else
    set(handles.checkbox4,'Visible','on')
    set(handles.resetcelllabel,'Enable','on')
end

if isempty(UserData.outline)
    set(handles.checkbox5,'Visible','off')
    set(handles.checkbox6,'Visible','off')
else
    set(handles.checkbox5,'Visible','on')
    set(handles.checkbox6,'Visible','on')
end

if isempty(UserData.neighbors)
    set(handles.compare_neighbor,'Enable','off');
else
    set(handles.compare_neighbor,'Enable','on');
end


% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ask user to confirm for closing the software
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
    ['Close ' get(handles.figure1,'Name') '...'],...
    'Yes','No','Yes');
if strcmp(selection,'No')
    % exit if canceled
    return;
end

% if confirmed, run the following code

UserData=get(handles.figure1,'UserData');

if UserData.status.changed % if some changes have been made but not saved
    choice = questdlg('Do you want to save your data?',...
        'Save your data',...
        'Yes',...
        'No',...
        'Cancel',...
        'Yes');
    switch choice
        case 'Cancel'
            return;
        case 'No'
            delete(handles.figure1)
        case 'Yes'
            
            % if never saved
            if isempty(UserData.save_name)
                
                % remember current directory
                current_path = pwd;
                s = regexp(UserData.path, '\\|\/', 'split');
                default_file_name = [s{end-1} '.' UserData.file_index '.ima'];
                
                % set default path as UserData.path
                cd(UserData.path);
                [save_name, save_path] = uiputfile({'*.ima';'*.*'},'Please specify a file name for automatic save service',default_file_name);
                
                cd(current_path);
                
                if save_name==0 return; end %canceled
                
                UserData.save_name = save_name;
                UserData.save_path = save_path;
                UserData.status.saved = 1;
                
            else
                set(handles.figure1,'UserData',UserData);
                save([UserData.save_path UserData.save_name],'UserData','-mat');
            end
            delete(handles.figure1)
    end
end

% open new image file
% --------------------------------------------------------------------
function open_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get current data
UserData=get(handles.figure1,'UserData');

% if a file is already opened, warn the user
if UserData.status.loaded
    selection = questdlg('Are you sure? This will discard current data.','Warnings!', ...
        'Yes','No','Yes');
    if strcmp(selection,'No')
        return;
    end
end

% open file choosing dialog
if isfield(UserData,'name')
    [UserData.name, UserData.path, filter_index] = uigetfile('*.tif','Open an image file (.tif)',[UserData.path UserData.name]);
else
    [UserData.name, UserData.path, filter_index] = uigetfile('*.tif','Open an image file (.tif)');
end
% debug
UserData.name

% exit if no file is choosed
if UserData.name==0 return; end

% clear figure
cla
legend('off')
title('')

% save file path and name
set(handles.figure1,'UserData',UserData);

% initialization of Non-GUI generated user data: status and parameters
Initialization(hObject, eventdata, handles);

% get all data, particularly GUI-generated data
UserData=get(handles.figure1,'UserData');

% enable/disable component according to status, doesn't change UserData
enable_components(UserData,handles);

% extract file index
% xxx001.tif, extract 001
UserData.file_index=UserData.name((end-6):(end-4));

% show message panel
set(handles.uipanel3,'Visible','on');drawnow;
% display message
set(handles.text1,'String',['Loading file ' UserData.name ', please wait ...']);drawnow;

% loading image file
UserData.I=parse_stack([UserData.path UserData.name],UserData.stack_range(1),UserData.stack_range(2));

UserData.image_size = size(UserData.I);

% update stack_range
if UserData.stack_range(2) > UserData.image_size(3)
    UserData.stack_range(2) = UserData.image_size(3);
end

% update windows name
set(handles.figure1,'Name',UserData.name);

% display the first stack
UserData.current_stack = 1;
imagesc(UserData.I(:,:,UserData.current_stack));colormap gray;axis square;axis off;

set(handles.text1,'String',{'Stack 1','(check other stacks by mouse scroll wheel or arrows on toolbar)'})

% update status and other
UserData.status.loaded = 1;
UserData.status.changed = 1;

% update component status
enable_components(UserData,handles);

% save data
set(handles.figure1,'UserData',UserData);

%debug
UserData.status


% open an image from menu
% --------------------------------------------------------------------
function open_Callback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open_ClickedCallback(hObject, eventdata, handles)


% open a saved results only.
% --------------------------------------------------------------------
function open_saved_Callback(hObject, eventdata, handles)
% hObject    handle to open_saved (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get current data
UserData=get(handles.figure1,'UserData');

% if a file is already opened, warn the user
if UserData.status.loaded
    selection = questdlg('Are you sure? This will discard current data.','Warnings!', ...
        'Yes','No','Yes');
    if strcmp(selection,'No')
        return;
    end
end

% open file choosing dialog
if ~isempty(UserData.save_name)
    [name, path, filter_index] = uigetfile('*.ima','Open saved results',[UserData.save_path UserData.save_name]);
else
    [name, path, filter_index] = uigetfile('*.ima','Open saved results');
end
if name==0 return; end

% load file
load([path name],'-mat');

% set data to gui
set(handles.figure1,'UserData',UserData);

% for debug, check status
UserData.status

% clear figure
cla;
legend('off')
title('')

% resize cropped image
I3 = imresize(UserData.I2, UserData.image_size(1:2));

% show image
imagesc(I3);
axis off;axis square;colormap gray;

% change windows title
set(handles.figure1,'Name',name);

set(handles.uipanel3,'Visible','on')

% show message
set(handles.text1,'String',name)

% for data saved via previous version
if ~isfield(UserData,'version')
    warndlg('this data is saved via a previous version of the software. It will be transformed to the current version without loss of data.',...
        'Version change',...
        'modal');
    if isfield(UserData,'scale')
        UserData.scale=1./UserData.scale;
        if isfield(UserData,'dots')
            if ~isempty(UserData.dots)
                UserData.dots(:,1)=UserData.dots(:,1)/UserData.scale(1);
                UserData.dots(:,2)=UserData.dots(:,2)/UserData.scale(2);
            end
        end
        if isfield(UserData,'cell')
            if ~isempty(UserData.cell)
                for i=1:length(UserData.cell)
                    UserData.cell(i).center = UserData.cell(i).center./UserData.scale;
                    UserData.cell(i).edge(:,1)=UserData.cell(i).edge(:,1)./UserData.scale(1);
                    UserData.cell(i).edge(:,2)=UserData.cell(i).edge(:,2)./UserData.scale(2);
                end
            end
        end
    end
    if ~isfield(UserData,'name')
        UserData.name = name;
    else
        UserData.name =[];
    end
    
    UserData.version = 2;
end

if isfield(UserData,'border')
    UserData.reference = UserData.border;
end
if isfield(UserData,'reference')
    if ~isempty(UserData.reference)
        UserData.reference = imresize(UserData.reference,UserData.image_size(1:2));
    end
else
    UserData.reference = [];
end

if isfield(UserData.status,'changed')
    UserData.status.changed = 1;
else
    UserData.status.changed = 0;
end

if ~isfield(UserData,'outline')
    UserData.outline = [];
end

if ~isfield(UserData,'neighbors')
    UserData.neighbors = [];
end

% display dots if counted
if isfield(UserData,'dots')
    figure(handles.figure1)
    if plot_all_dot(UserData.dots);
        if isfield(UserData,'channel_name')
            legend(UserData.channel_name,'FontSize',14);
        end
    end
else
    UserData.dots = [];
end

% display cells if segmented
if isfield(UserData,'cell')
    if ~isempty(UserData.cell)
        % assign labels if none assigned, for compatability with previous
        % version
        if ~isfield(UserData.cell,'label')
            UserData.cell = set_cell_label(UserData.cell);
        end
        plot_all_cell(UserData.cell);
    end
else
    UserData.cell=[];
end

axis off;axis square;colormap gray;

UserData.status.changed = 1;
% update component status
enable_components(UserData,handles);
% save data
set(handles.figure1,'UserData',UserData);

% open a reference image
% --------------------------------------------------------------------
function open_image_Callback(hObject, eventdata, handles)
% hObject    handle to open_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserData=get(handles.figure1,'UserData');

% open file choosing dialog
[UserData.refname, UserData.refpath] = uigetfile('*.tif','Open a reference image file (.tif)');

% exit if no file is choosed
if UserData.refname==0 return; end

% load image file
UserData.reference=parse_stack([UserData.refpath UserData.refname],UserData.stack_range(1),UserData.stack_range(2));

set(handles.figure1,'UserData',UserData);
panel(handles)


% save, respond to the button on the toolbar
% --------------------------------------------------------------------
function save_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to save_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserData=get(handles.figure1,'UserData');
set(handles.text1,'String','Saving data ...');drawnow

% if this is the first time to save, let user specify a file name
if isempty(UserData.save_name)
    
    % remember current directory
    current_path = pwd;
    s = regexp(UserData.path, '\\|\/', 'split');
    default_file_name = [s{end-1} '.' UserData.file_index '.ima'];
    
    % set default path as UserData.path
    cd(UserData.path);
    [save_name, save_path] = uiputfile({'*.ima';'*.*'},'Please specify a file name for automatic save service',default_file_name);
    
    cd(current_path);
    
    if save_name==0 return; end %canceled
    
    UserData.save_name = save_name;
    UserData.save_path = save_path;
    UserData.status.saved = 1;
end

% do not save the original stack image, it's huge!
I = UserData.I;
UserData.I = [];
save([UserData.save_path UserData.save_name],'UserData','-mat');
UserData.I=I;
set(handles.figure1,'UserData',UserData);

figure(handles.figure1)
set(handles.text1,'String','Data saved');

UserData.status.changed = 0;
enable_components(UserData,handles)

% debug
UserData=get(handles.figure1,'UserData');
UserData.status

% --------------------------------------------------------------------
function save_menu_Callback(hObject, eventdata, handles)
% hObject    handle to save_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function saveas_Callback(hObject, eventdata, handles)
% hObject    handle to saveas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserData=get(handles.figure1,'UserData');

% remember current directory
current_path = pwd;
s = regexp(UserData.path, '\\|\/', 'split');
default_file_name = [s{end-1} '.' UserData.file_index '.ima'];

% set default path as UserData.path
cd(UserData.path);
[save_name, save_path] = uiputfile({'*.ima';'*.*'},'Please specify a file name for automatic save service',default_file_name);

cd(current_path);

if save_name==0 return; end %canceled

UserData.save_name = save_name;
UserData.save_path = save_path;
UserData.status.saved = 1;
set(handles.figure1,'UserData',UserData);
enable_components(UserData,handles);
UserData.I = [];

set(handles.figure1,'UserData',UserData);
save([UserData.save_path UserData.save_name],'UserData','-mat');

% debug
UserData=get(handles.figure1,'UserData');
UserData.status


% for batch analysis, not implemented
% --------------------------------------------------------------------
function open_dir_Callback(hObject, eventdata, handles)
% hObject    handle to open_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path = uigetdir;

if path == 0
    return;
end

files = dir(fullfile(path,'*.ima'));

UserDataArray=[];
n_file = length(files)
for i=1:n_file
    % load the file
    tmp = load(fullfile(path,files(i).name),'-mat');
    UserDataArray=[UserDataArray tmp.UserData];
    %UserDataArray(i).save_name
end


% --------------------------------------------------------------------
function export_as_figure_Callback(hObject, eventdata, handles)
% hObject    handle to export_as_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserData=get(handles.figure1,'UserData');

% remember current directory
current_path = pwd;
s = regexp(UserData.path, '\\|\/', 'split');
default_file_name = [s{end-1} '.' UserData.file_index '.eps'];

% set default path as UserData.path
cd(UserData.path);
[save_name, save_path] = uiputfile({'*.eps';'*.*'},'Please specify a file name',default_file_name);
cd(current_path);

if save_name==0 return; end %canceled

UserData.save_figure_name = save_name;
UserData.save_figure_path = save_path;

saveas(gcf,[UserData.save_figure_path UserData.save_figure_name,'.eps'],'psc2')
set(handles.text1,'String',['figure saved to:' UserData.save_figure_path UserData.save_figure_name])
set(handles.figure1,'UserData',UserData);


% crop image
% crop a region of interest
% --------------------------------------------------------------------
function crop_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to crop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserData=get(handles.figure1,'UserData');

% if not projected and multi-stack, warning
if ~UserData.status.projected & UserData.image_size(3)>1
    warndlg('This is multi-stack image, please do Z-projection first!','Warning');
end

% if no enhancement applied
if ~UserData.status.enhanced
    UserData.I3 = UserData.I2;
    % I2: projected
    % I3: enhanced
end

% crop until user is satisfied
go_on=1;
while go_on
    
    set(handles.text1,'String','Please click crypt boundary')
    
    % apply a polygonal cropping on the image
    [x,y,BW,xi,yi]=roipoly;
    
    hold on;
    
    % the minimum rectangle that contains the mask
    RECT=[min(xi) min(yi) max(xi)-min(xi)  max(yi)-min(yi)];
    
    BW=imcrop(BW,RECT);
    
    % apply the mask to the image
    ims = gui_crop_stack_poly(UserData.I3,RECT,BW);
    
    % resize the image to display
    s = UserData.image_size;
    
    I3 = imresize(ims, s(1:2));
    scale =size(ims)./s(1:2);
    % reverse, row - column
    UserData.scale = scale(2:-1:1);
    
    %debug
    size(ims)
    UserData.scale
    
    % display the image
    cla;
    imagesc(I3);
    axis off;axis square;colormap gray;
    
    selection = questdlg('Happy with this?','Happy with this?','Yes','No','Yes');
    if strcmp(selection,'Yes')
        go_on=0;
    else
        imagesc(UserData.I3)
        axis off;axis square;colormap gray;
    end
end

UserData.BW=BW;
UserData.RECT=RECT;
UserData.I2=I3; % so that user can do enhancement on the cropped image
UserData.status.cropped  = 1;
UserData.status.changed = 1;
% update component status
enable_components(UserData,handles);
% save data
set(handles.figure1,'UserData',UserData);
save_ClickedCallback(hObject, eventdata, handles);

% count dots in chanels
% all channels in the same directory, with the same file_index are listed
% --------------------------------------------------------------------
function count_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserData=get(handles.figure1,'UserData');

% find all channels
all_channel=all_channel_names(UserData.path,UserData.file_index);

% let user to choose channels to be counted
[selected,v] = listdlg('Name','Channel filter',...
    'PromptString','Select the channels you want to count the dots:',...
    'ListSize',[300 100],...
    'ListString',all_channel);
if isempty(selected)
    return;
end

new_channels = all_channel(selected); % user selected channels

% check whether some of the channels have already been counted
% if so, ask the user whether to count again or not

counted_channels = [];% to store the indices of channels that are already counted
counted_channels_in_channel_name = []; % indices in channel_name

% if already counted some channels
if ~isempty(UserData.channel_name)
    for i=1:length(new_channels)
        for j=1:length(UserData.channel_name)
            % if there is overlab between new channel and counted channel
            if strcmp(new_channels{i},UserData.channel_name{j})
                % add to indices of counted channels
                counted_channels=[counted_channels i];
                counted_channels_in_channel_name = [counted_channels_in_channel_name j];
            end
        end
    end
    % if some channels are counted, let user to decide
    if ~isempty(counted_channels)
        choice = questdlg([new_channels(counted_channels) ' have been counted already, do you like to count them AGAIN?'],...
            'Channels already counted',...
            'Yes',...
            'No',...
            'Cancel',...
            'No');
        switch choice
            case 'No'
                % remove counted channels from the list of channels to be
                % counted
                new_channels(counted_channels)=[];
            case 'Yes'
                UserData.channel_name(counted_channels_in_channel_name) = [];
                % also need to update dots!!
                for k = 1:numel(counted_channels_in_channel_name)
                    UserData.dots(UserData.dots(:,4)==counted_channels_in_channel_name(k),:)=[];
                end
            case 'Cancel'
                return;
        end
        
    end
    UserData.channel_name = [UserData.channel_name new_channels];
else
    UserData.channel_name = new_channels;
end

set(handles.text1,'String','Starting counting dots, please wait ...')

% start counting dots in each channel
col = 'rgb'; % color for dots in different channel

channel_start = length(UserData.channel_name) - length(new_channels)+1;

%debug
channel_start
new_channels
UserData.channel_name

% for each channel that need to count
for j=channel_start:length(UserData.channel_name),
    % load channel image
    filename = [UserData.channel_name{j} UserData.file_index '.tif'];
    set(handles.text1,'String',['loading ' filename ' ...']);
    ims=parse_stack([UserData.path filename],UserData.stack_range(1),UserData.stack_range(2));
    % crop image
    set(handles.text1,'String','Cropping each stack ...');drawnow
    if ~isempty(UserData.BW)
        ims=gui_crop_stack_poly(ims,UserData.RECT,UserData.BW);
    end
    
    % calculate the number of dots for different thresholds
    [thresholdfn,thresholds,ims2]=calculate_file_threshold_function(handles,ims,UserData.BW,UserData.N,UserData.sigma,UserData.n_thresholds);
    
    % let the user choose the appropriate threshold
    [num_dots,locations,threshold]=threshold_selection(handles,thresholds,thresholdfn,ims,ims2,UserData.BW,...
        UserData.auto_thresholding.width,...
        UserData.auto_thresholding.offset,...
        UserData.projection_method,...
        UserData.enhance_method);
    
    % if there are some dots in the channel
    if num_dots > 0
        % correct the coordinates
        locations(:,1) = locations(:,1)./UserData.scale(1);
        locations(:,2) = locations(:,2)./UserData.scale(2);
        
        UserData.dots = [UserData.dots; [locations zeros(num_dots,1)+j]];
        
        % plot dots onto the image
        plot_all_dot(UserData.dots);
        
        % save data
        set(handles.figure1,'UserData',UserData);
        save_ClickedCallback(hObject, eventdata, handles);
    else
        set(handles.text1,'String',['No dots in ' filename])
    end
end
UserData.status.counted  = 1;
set(handles.figure1,'UserData',UserData);

figure(handles.figure1);

if ~isempty(UserData.dots)
    plot_all_dot(UserData.dots);
end

% add legend for channels
% first need to shut off the legend for cells if any
hs = findobj('-regexp','Tag','plot_cell');
if ~isempty(hs)
    for i=1:length(hs)
        set(get(get(hs(i),'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude from legend
    end
end
legend(UserData.channel_name,'FontSize',14)

% find background dots
if max(UserData.dots(:,4)>1)
    set(handles.text1,'String','Finding potential background dots ...');drawnow;
    bgid = find_background_dots(UserData.dots);
    bgds=UserData.dots(bgid,:);
    hbg = plot(bgds(:,1),bgds(:,2),'yo');
    set(handles.text1,'String','Background dots are circled out');drawnow;
    n_bg_dots = size(bgds,1);
    n_dots = size(UserData.dots,1);
    if n_bg_dots
        msg =[num2str(n_bg_dots) ' of ' num2str(n_dots) ' in total are present in multiple channels (circled) You are recommended to remove these dots.']
        choice = questdlg(msg,...
            'Remove potential background dots',...
            'Remove',...
            'Keep them',...
            'Remove');
        if ~strcmp(choice,'Keep them')
            UserData.dots(bgid,:)=[];
            delete(hbg)
            hd = findobj('Tag','plot_dot');
            delete(hd)
            plot_all_dot(UserData.dots);
            set(handles.text1,'String','Potential background dots removed');drawnow;
        end
    end
end

UserData.status.changed = 1;
enable_components(UserData,handles)
set(handles.figure1,'UserData',UserData);
save_ClickedCallback(hObject, eventdata, handles);

% segment cells by clicking polygons
% --------------------------------------------------------------------
function segment_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserData=get(handles.figure1,'UserData');

if isempty(UserData.reference)% first time
    
    %debug
    disp('first time to segment')
    UserData.status
    
    % let user to choose a channel that helps segmentation
    all_channel=all_channel_names(UserData.path,UserData.file_index);
    [selected,v] = listdlg('Name','Channel filter',...
        'PromptString','Select a channel to aid cell segmentation:',...
        'ListSize',[300 100],...
        'SelectionMode','single',... % select only one channel
        'ListString',all_channel);
    
    % debug
    selected
    
    % if none selected, exit
    if isempty(selected)
        return;
    end
    
    % the selected channel name
    reference_channel =all_channel(selected);
    
    reference_filename= [reference_channel{1} UserData.file_index '.tif'];
    
    set(handles.text1,'String',['Loading ' reference_filename ', please wait ...'])
    
    % load the channel
    ims=parse_stack([UserData.path reference_filename],UserData.stack_range(1),UserData.stack_range(2));
    
    % z-projection
    UserData.reference = zprojection(ims,UserData.projection_method);
    if ~isempty(UserData.BW)
        UserData.reference=gui_crop_stack_poly(UserData.reference,UserData.RECT,UserData.BW);
    end
    
    %debug
    size(UserData.reference)
    
    UserData.reference = imresize(UserData.reference, UserData.image_size(1:2));
    UserData.reference=enhance_image(UserData.reference,UserData.enhance_method);
    
    UserData.cell=[];
end

% change the position of the new figure window
screen_size = get(0, 'ScreenSize')
position = get(handles.figure1, 'Position')
href = figure;

set(gcf, 'Position', [position(3)+10 position(2) screen_size(3)-position(3) position(4)] );
imagesc(UserData.reference);
axis off;axis square; colormap gray;
set(handles.text1,'String','Refer to the other image when segmenting cells');

set(handles.uipanel1,'Visible','on')

% debug
size(UserData.reference)

figure(handles.figure1)
set(handles.text1,'String','Click the cell border');
plot_all_cell(UserData.cell);
figure(href)
plot_all_cell(UserData.cell);

% start segmenting cells
go_on = 1;
hold on;
while go_on
    figure(handles.figure1)
    UserInput=1;
    while UserInput > 0
        UserInput = waitforbuttonpress;      % Wait for click
    end
    SelectionType = get(gcf,'SelectionType')
    CurrentPoint = get(gca,'CurrentPoint')
    if strcmp(SelectionType,'alt') % right click
        figure(handles.figure1)
        choice = questdlg('I want to ...',...
            'Tell me what you want to do:',...
            'stop',...
            'delete the cell',...
            'stop');
        switch choice
            case 'delete the cell'
                % find the cell
                found = which_cell(CurrentPoint(1,1:2),UserData.cell);
                if found==0
                    % the point is not inside any cell
                    set(handles.text1,'String','You need to right-click INSIDE the cell!');
                else
                    % delete the cell
                    UserData.cell(found)=[];
                    % update cell labels
                    UserData.cell = set_cell_label(UserData.cell);
                    % save data
                    set(handles.figure1,'UserData',UserData);
                    % debug
                    UserData.cell
                    
                    % update figure
                    figure(handles.figure1)
                    % first delete old plot
                    h = findobj('-regexp','Tag','plot_cell');
                    delete(h)
                    % then plot all cells
                    plot_all_cell(UserData.cell);
                    
                    % update reference figure
                    figure(href)
                    plot_all_cell(UserData.cell);
                end
                
            otherwise % stop
                UserData.status.segmented = 1;
                set(handles.figure1,'UserData',UserData);
                set(handles.text1,'String',['You have selected ' num2str(length(UserData.cell)) ' cells' ])
                go_on =0;
        end
    else
        % segment cells
        figure(handles.figure1)
        % user clicks a polygon
        poly=getline(handles.figure1,'closed');
        
        if size(poly,1)>2   % ignore when less than 3 points are clicked
            % calculate the cell area
            area = polyarea(poly(:,1),poly(:,2));
            if area > 100 % ignore when the polygon is too small
                % update cell information
                newcell.edge = poly;
                newcell.center = mean(newcell.edge);
                newcell.area = area;
                newcell.label = num2str(length(UserData.cell)+1);
                
                if isfield(UserData.cell,'channel')
                    UserData.cell=rmfield(UserData.cell,'channel');
                end
                UserData.cell
                newcell
                newcell.edge
                UserData.cell = [UserData.cell newcell];
                set(handles.figure1,'UserData',UserData);
                
                %debug
                %length(cell)
                %cell(length(cell))
                
                % plot all cells
                plot_all_cell(UserData.cell);
                figure(href)
                plot_all_cell(UserData.cell);
                title(['You have selected ' num2str(length(UserData.cell)) ' cells' ],'FontSize',18,'Color','b');
                
                figure(handles.figure1)
                set(handles.text1,'String',['Please click to crop the next cell, or right-click to delete cell or exit']);
            end
        end
    end
end
% end of segmenting cells

% close reference image
close(href)

% update / save data
UserData.status.changed = 1;
UserData.status.segmented  = 1;
enable_components(UserData,handles)

set(handles.text1,'String',['saving data ...'])
save_ClickedCallback(hObject, eventdata, handles);
set(handles.text1,'String','Data saved')

% --------------------------------------------------------------------
function ProjectionMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ProjectionMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% do default z-projection: responds to the button on the toolbar
% can also specify the projection methods
% --------------------------------------------------------------------
function projection_ClickedCallback(hObject, eventdata, handles,method)
% hObject    handle to projection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserData=get(handles.figure1,'UserData');

%debug
disp('perform projection')
UserData.status
UserData.stack_range

if UserData.status.loaded % image loaded
    if nargin <4
        method = UserData.projection_method;
    end
    method
    
    I2 = zprojection(UserData.I(:,:,UserData.stack_range(1):UserData.stack_range(2)),method);
    size(I2)
    cla
    imagesc(I2)
    axis off;axis square;colormap gray;
    set(handles.text1,'String','try other projection/enhance method, or start to crop image')
    UserData.I2=I2;
    UserData.status.projected = 1;
    
    UserData.status.changed = 1;
    enable_components(UserData,handles)
    set(handles.figure1,'UserData',UserData);
end

% z-projection: standard deviation, respond to menu item:projection->std
% --------------------------------------------------------------------
function Proj_STD_Callback(hObject, eventdata, handles)
% hObject    handle to Proj_STD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

projection_ClickedCallback(hObject, eventdata, handles,'std');

% z-projection: coefficient variation, responds to menu item:
% projection->cv
% --------------------------------------------------------------------
function Proj_CV_Callback(hObject, eventdata, handles)
% hObject    handle to Proj_CV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
projection_ClickedCallback(hObject, eventdata, handles,'cv');

% z-projection: max, rsponds to menu item:projection->max
% --------------------------------------------------------------------
function Proj_Max_Callback(hObject, eventdata, handles)
% hObject    handle to Proj_Max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

projection_ClickedCallback(hObject, eventdata, handles,'max');

% z-projection, average, responds to menu item: projection->average
% --------------------------------------------------------------------
function Proj_Mean_Callback(hObject, eventdata, handles)
% hObject    handle to Proj_Mean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

projection_ClickedCallback(hObject, eventdata, handles,'mean');

% set stack filter: responds to menu item: setting->stack filter
% --------------------------------------------------------------------
function setting_stack_filter_Callback(hObject, eventdata, handles)
% hObject    handle to ProjSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserData=get(handles.figure1,'UserData');

% prompt an input dialog
prompt = {'Only include stacks ','to '};
dlg_title = 'Stack filtering';
num_lines = 1;
def = {num2str(UserData.stack_range(1)),num2str(UserData.stack_range(2))};% default input

go_on = 1;
while go_on
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    if isempty(answer)
        return;
    end
    input1 =  str2num(answer{1});
    input2 =  str2num(answer{2});
    if input1 <1 | input2<1
        clicked=questdlg('Both numbers should be positive!','Oops!','Retry','Cancel','Don''t touch me!','Retry')
        switch clicked
            case 'Retry'
            otherwise
                go_on = 0;
        end
    elseif (input1 > input2)
        clicked=questdlg('The first number should not be larger than the second!','Oops!','Retry','Cancel','Don''t touch me!','Retry')
        switch clicked
            case 'Retry'
            otherwise
                go_on = 0;
        end
    elseif UserData.status.loaded
        max_stack = UserData.image_size(3);
        if input2 <= max_stack% the only right input
            UserData.stack_range=[input1 input2];
            set(handles.figure1,'UserData',UserData);
            go_on = 0;
        else
            clicked=questdlg('The second number is larger than the total number of stacks in current image!','Oops!','Retry','Cancel','Don''t touch me!','Retry')
            switch clicked
                case 'Retry'
                otherwise
                    go_on = 0;
            end
        end
    else
        go_on = 0;
    end
end

UserData.status.changed = 1;
enable_components(UserData,handles)
set(handles.figure1,'UserData',UserData);

% use mouse wheel to explore stacks
% --- Executes on scroll wheel click while the figure is in focus.
function figure1_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)

UserData=get(handles.figure1,'UserData');
if UserData.status.loaded
    UserData.current_stack =  UserData.current_stack + eventdata.VerticalScrollCount;
    if UserData.current_stack > UserData.image_size(3)
        UserData.current_stack = 1;
    elseif UserData.current_stack <1
        UserData.current_stack = UserData.image_size(3);
    end
    figure(handles.figure1)
    imagesc(UserData.I(:,:,UserData.current_stack));colormap gray;axis square;axis off;
    set(handles.text1,'String',['stack ' num2str(UserData.current_stack)]);
    drawnow;
end
set(handles.figure1,'UserData',UserData);

UserData.status.changed = 1;
enable_components(UserData,handles)
set(handles.figure1,'UserData',UserData);


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate axes1


% --- assign dots to cell
% ------------------------------------------------------------------------
function assign_dots_to_cells(handles)
UserData=get(handles.figure1,'UserData');
n_channel = length(UserData.channel_name);
n_cell = length(UserData.cell);

set(handles.text1,'String','Assigning dots to cell ...');drawnow;
for i=1:n_cell % for each cell
    in = inpoly(UserData.dots(:,1:2),UserData.cell(i).edge);
    UserData.dots(in,5) = i;
    % if a dot is in multiple cells, it will be assigned to the one
    % with larger label
end

% statistics
UserData.num_dot_cell_channel = zeros(n_cell,n_channel);
for i=1:n_cell
    for j=1:n_channel
        UserData.num_dot_cell_channel(i,j) = sum(UserData.dots(:,4)==j & UserData.dots(:,5)==i);
    end
end
set(handles.text1,'String','Dots have been assigned to cells');drawnow;
UserData.status.changed = 1;
enable_components(UserData,handles)
set(handles.figure1,'UserData',UserData);

% plot raw count in each cell
% --------------------------------------------------------------------
function plot_raw_count_Callback(hObject, eventdata, handles)
% hObject    handle to plot_raw_count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UserData=get(handles.figure1,'UserData');

if ~isempty(UserData.cell) & ~isempty(UserData.dots)
    if isempty(UserData.num_dot_cell_channel)
        assign_dots_to_cells(handles);
        UserData=get(handles.figure1,'UserData');
    end
    figure
    plot(UserData.num_dot_cell_channel,'-o');
    axis tight;
    set(gca,'XTick',1:length(UserData.cell));
    set(gca,'XTickLabel',get_cell_labels(UserData.cell));
    legend(UserData.channel_name)
    ylabel('Counts')
    xlabel('Cells')
    title('Raw counts')
    
    % plot channel pairwise correlation
    figure
    plot_pairwise(UserData.num_dot_cell_channel,UserData.channel_name);
    
    UserData.status.changed = 1;
    enable_components(UserData,handles)
    set(handles.figure1,'UserData',UserData);
    save_ClickedCallback(hObject, eventdata, handles)
end

% --------------------------------------------------------------------
function CountNormalization_Callback(hObject, eventdata, handles)
% hObject    handle to CountNormalization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% normalize dots count by cell
% --------------------------------------------------------------------
function NormCellCount_Callback(hObject, eventdata, handles)
% hObject    handle to NormCellCount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserData=get(handles.figure1,'UserData');
if isempty(UserData.num_dot_cell_channel)
    assign_dots_to_cells(handles);
    UserData=get(handles.figure1,'UserData');
end

UserData.num_dot_cell_channel_normalized = cell_count_normalization(UserData.num_dot_cell_channel,'bycell');
figure
plot(UserData.num_dot_cell_channel_normalized,'-o')
legend(UserData.channel_name);
axis tight
set(gca,'XTick',1:length(UserData.cell))
set(gca,'XTickLabel',get_cell_labels(UserData.cell));
xlabel('Cells');
ylabel('Counts')
title('Normalized by max cell count')

figure
plot_pairwise(UserData.num_dot_cell_channel_normalized,UserData.channel_name);

UserData.status.changed = 1;
enable_components(UserData,handles)
set(handles.figure1,'UserData',UserData);

% normalize dots count by channel
% --------------------------------------------------------------------
function NormChannelCount_Callback(hObject, eventdata, handles)
% hObject    handle to NormChannelCount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserData=get(handles.figure1,'UserData');
if isempty(UserData.num_dot_cell_channel)
    assign_dots_to_cells(handles);
    UserData=get(handles.figure1,'UserData');
end
UserData.num_dot_cell_channel_normalized = cell_count_normalization(UserData.num_dot_cell_channel,'bychannel');
figure
plot(UserData.num_dot_cell_channel_normalized,'-o')
legend(UserData.channel_name);
axis tight
set(gca,'XTick',1:length(UserData.cell))
set(gca,'XTickLabel',get_cell_labels(UserData.cell));
xlabel('Cells');
ylabel('Counts')
title('Normalized by max channel count')

figure
plot_pairwise(UserData.num_dot_cell_channel_normalized,UserData.channel_name);


UserData.status.changed = 1;
enable_components(UserData,handles)
set(handles.figure1,'UserData',UserData);


% normalize dots count by cell volume
% --------------------------------------------------------------------
function NormCellSize_Callback(hObject, eventdata, handles)
% hObject    handle to NormCellSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserData=get(handles.figure1,'UserData');
if isempty(UserData.num_dot_cell_channel)
    assign_dots_to_cells(handles);
    UserData=get(handles.figure1,'UserData');
end

% calculate cell volume
nstks = UserData.stack_range(2)-UserData.stack_range(1)+1;
for i=1:length(UserData.cell)
    cell_vol(i) = UserData.cell(i).area;
end
cell_vol = cell_vol*nstks;
UserData.num_dot_cell_channel_normalized = cell_count_normalization(UserData.num_dot_cell_channel,'bysize',cell_vol);

figure
plot(UserData.num_dot_cell_channel_normalized,'-o')
legend(UserData.channel_name);
axis tight
set(gca,'XTick',1:length(UserData.cell))
set(gca,'XTickLabel',get_cell_labels(UserData.cell));
xlabel('Cells');
ylabel('Counts')
title('Normalized by cell volume')

figure
plot_pairwise(UserData.num_dot_cell_channel_normalized,UserData.channel_name);

UserData.status.changed = 1;
enable_components(UserData,handles)
set(handles.figure1,'UserData',UserData);

% normalize dot count by total dots in a cell
% --------------------------------------------------------------------
function NormTotalCount_Callback(hObject, eventdata, handles)
% hObject    handle to NormTotalCount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserData=get(handles.figure1,'UserData');
if isempty(UserData.num_dot_cell_channel)
    assign_dots_to_cells(handles);
    UserData=get(handles.figure1,'UserData');
end
UserData.num_dot_cell_channel_normalized = cell_count_normalization(UserData.num_dot_cell_channel,'bytotal');
figure
plot(UserData.num_dot_cell_channel_normalized,'-o')
legend(UserData.channel_name);
axis tight
set(gca,'XTick',1:length(UserData.cell))
set(gca,'XTickLabel',get_cell_labels(UserData.cell));
xlabel('Cells');
ylabel('Counts')
title('Normalized by total count')

figure
plot_pairwise(UserData.num_dot_cell_channel_normalized,UserData.channel_name);

UserData.status.changed = 1;
enable_components(UserData,handles)
set(handles.figure1,'UserData',UserData);

% --------------------------------------------------------------------
function image_Callback(hObject, eventdata, handles)
% hObject    handle to image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MergeChannels_Callback(hObject, eventdata, handles)
% hObject    handle to MergeChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% go to previous stack
% --------------------------------------------------------------------
function previous_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UserData=get(handles.figure1,'UserData');
if UserData.status.loaded
    UserData.current_stack =  UserData.current_stack-1;
    if UserData.current_stack <1
        UserData.current_stack = UserData.image_size(3);
    end
    imagesc(UserData.I(:,:,UserData.current_stack));colormap gray;axis square;axis off;
    set(handles.text1,'String',['stack ' num2str(UserData.current_stack)]);
    drawnow;
end

UserData.status.changed = 1;
enable_components(UserData,handles)
set(handles.figure1,'UserData',UserData);

% go to next stack
% --------------------------------------------------------------------
function next_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UserData=get(handles.figure1,'UserData');
if UserData.status.loaded
    UserData.current_stack =  UserData.current_stack+1;
    if UserData.current_stack > UserData.image_size(3)
        UserData.current_stack = 1;
    end
    imagesc(UserData.I(:,:,UserData.current_stack));colormap gray;axis square;axis off;
    set(handles.text1,'String',['stack ' num2str(UserData.current_stack)]);
    drawnow;
end

UserData.status.changed = 1;
enable_components(UserData,handles)
set(handles.figure1,'UserData',UserData);



% let user to specify the laplacian filter
% --------------------------------------------------------------------
function setting_laplacian_filter_Callback(hObject, eventdata, handles)
% hObject    handle to setting_laplacian_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UserData=get(handles.figure1,'UserData');

prompt = {'Set the laplacian filter size','Set the laplacian filter bandwidth'};
dlg_title = 'Set the laplacian filter';
num_lines = 1;
def = {num2str(UserData.N),num2str(UserData.sigma)};
go_on = 1;
while go_on
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    if isempty(answer)
        return;
    end
    input1 =  str2num(answer{1});
    input2 =  str2num(answer{2});
    if input1 <=0 | input2<=0
        clicked=questdlg('Both numbers should be positive!','Oops!','Revise','Cancel','Don''t touch me!','Revise')
        switch clicked
            case 'Cancel'
                go_on = 0;
            otherwise
        end
    else
        UserData.N = input1;
        UserData.sigma = input2;
        set(handles.figure1,'UserData',UserData);
        go_on = 0;
    end
end

UserData.status.changed = 1;
enable_components(UserData,handles)
set(handles.figure1,'UserData',UserData);

% let user specify the number of thresholds to try when counting dots.
% default is 100.
% --------------------------------------------------------------------
function setting_num_threshold_Callback(hObject, eventdata, handles)
% hObject    handle to setting_num_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UserData=get(handles.figure1,'UserData');

prompt = {'Set the number of thresholds for image intensity you want to try'};
dlg_title = 'Set the number of thresholds';
num_lines = 1;
def = {num2str(UserData.n_thresholds)};
go_on = 1;
while go_on
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    if isempty(answer)
        return;
    end
    input =  str2num(answer{1});
    if input < 2
        clicked=questdlg('The number is too small!','Oops!','Revise','Cancel','Don''t touch me!','Revise')
        switch clicked
            case 'Cancel'
                go_on = 0;
            otherwise
        end
    else
        UserData.n_thresholds = input;
        set(handles.figure1,'UserData',UserData);
        go_on = 0;
    end
end

UserData.status.changed = 1;
enable_components(UserData,handles)
set(handles.figure1,'UserData',UserData);

% change default projection method
% --------------------------------------------------------------------
function setting_proj_max_Callback(hObject, eventdata, handles)
% hObject    handle to setting_proj_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UserData=get(handles.figure1,'UserData');
UserData.projection_method = 'max';
hs = findobj('-regexp','Tag','setting_proj');
for i=1:numel(hs)
    set(hs(i),'Checked','off');
end
set(hObject,'Checked','on');
UserData.status.changed = 1;
enable_components(UserData,handles)
set(handles.figure1,'UserData',UserData);

% --------------------------------------------------------------------
function setting_proj_average_Callback(hObject, eventdata, handles)
% hObject    handle to setting_proj_average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UserData=get(handles.figure1,'UserData');
UserData.projection_method = 'mean';
hs = findobj('-regexp','Tag','setting_proj');
for i=1:numel(hs)
    set(hs(i),'Checked','off');
end
set(hObject,'Checked','on');
UserData.status.changed = 1;
enable_components(UserData,handles)
set(handles.figure1,'UserData',UserData);


% --------------------------------------------------------------------
function setting_proj_std_Callback(hObject, eventdata, handles)
% hObject    handle to setting_proj_std (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UserData=get(handles.figure1,'UserData');
UserData.projection_method = 'std';
hs = findobj('-regexp','Tag','setting_proj');
for i=1:numel(hs)
    set(hs(i),'Checked','off');
end
set(hObject,'Checked','on');
UserData.status.changed = 1;
enable_components(UserData,handles)
set(handles.figure1,'UserData',UserData);


% --------------------------------------------------------------------
function setting_proj_cv_Callback(hObject, eventdata, handles)
% hObject    handle to setting_proj_cv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UserData=get(handles.figure1,'UserData');
UserData.projection_method = 'cv';
hs = findobj('-regexp','Tag','setting_proj');
for i=1:numel(hs)
    set(hs(i),'Checked','off');
end
set(hObject,'Checked','on');
UserData.status.changed = 1;
enable_components(UserData,handles)
set(handles.figure1,'UserData',UserData);


% let user specify the parameters for auto-thresholding
% --------------------------------------------------------------------
function setting_auto_thresholding_Callback(hObject, eventdata, handles)
% hObject    handle to setting_auto_thresholding (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UserData=get(handles.figure1,'UserData');

prompt = {'Set the size of sliding window (odd integer, >=3)','Set the offset punishment for number of dots (positive number)'};
dlg_title = 'Set parameters for automatic thresholding';
num_lines = 1;
def = {num2str(UserData.auto_thresholding.width),num2str(UserData.auto_thresholding.offset)};
go_on = 1;
while go_on
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    if isempty(answer)
        return;
    end
    input1 =  floor(str2num(answer{1})/2)*2+1;
    input2 =  str2num(answer{2});
    if input1 <3 | input2<=0
        clicked=questdlg('Invalid input!','Oops!','Revise','Cancel','Don''t touch me!','Revise')
        switch clicked
            case 'Cancel'
                go_on = 0;
            otherwise
        end
    else
        UserData.auto_thresholding.width = input1;
        UserData.auto_thresholding.offset = input2;
        set(handles.figure1,'UserData',UserData);
        go_on = 0;
    end
end

UserData.status.changed = 1;
enable_components(UserData,handles)
set(handles.figure1,'UserData',UserData);




% do image enhancement from toolbar
% --------------------------------------------------------------------
function image_enhance_ClickedCallback(hObject, eventdata, handles, method)
% hObject    handle to image_enhance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UserData=get(handles.figure1,'UserData');
if UserData.status.projected % image projected
    if nargin <4
        method = UserData.enhance_method;
    end
    UserData.I3 = enhance_image(UserData.I2,method);
    imagesc(UserData.I3)
    axis off;axis square;colormap gray;
    set(handles.text1,'String','Choose another enhance/projection method, or start to crop image')
    UserData.status.enhanced = 1;
    set(handles.figure1,'UserData',UserData);
    enable_components(UserData,handles);
end
UserData.status.changed = 1;
enable_components(UserData,handles)
set(handles.figure1,'UserData',UserData);

% do image enhancemetn from menu
% --------------------------------------------------------------------
function histeq_Callback(hObject, eventdata, handles)
% hObject    handle to histeq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_enhance_ClickedCallback(hObject, eventdata, handles, 'histeq')

% --------------------------------------------------------------------
function adapthisteq_Callback(hObject, eventdata, handles)
% hObject    handle to adapthisteq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_enhance_ClickedCallback(hObject, eventdata, handles, 'adapthisteq')

% --------------------------------------------------------------------
function imadjust_Callback(hObject, eventdata, handles)
% hObject    handle to imadjust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_enhance_ClickedCallback(hObject, eventdata, handles, 'imadjust')

% change default image enhance method
% --------------------------------------------------------------------
function setting_enhance_histeq_Callback(hObject, eventdata, handles)
% hObject    handle to setting_enhance_histeq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UserData=get(handles.figure1,'UserData');
UserData.enhance_method = 'histeq';
hs = findobj('-regexp','Tag','setting_enhance');
for i=1:numel(hs)
    set(hs(i),'Checked','off');
end
set(hObject,'Checked','on');
UserData.status.changed = 1;
enable_components(UserData,handles)
set(handles.figure1,'UserData',UserData);


% --------------------------------------------------------------------
function setting_enhance_adapthisteq_Callback(hObject, eventdata, handles)
% hObject    handle to setting_enhance_adapthisteq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UserData=get(handles.figure1,'UserData');
UserData.enhance_method = 'adapthisteq';
hs = findobj('-regexp','Tag','setting_enhance');
for i=1:numel(hs)
    set(hs(i),'Checked','off');
end
set(hObject,'Checked','on');
UserData.status.changed = 1;
enable_components(UserData,handles)
set(handles.figure1,'UserData',UserData);

% --------------------------------------------------------------------
function setting_enhance_imadjust_Callback(hObject, eventdata, handles)
% hObject    handle to setting_enhance_imadjust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UserData=get(handles.figure1,'UserData');
UserData.enhance_method = 'imadjust';
hs = findobj('-regexp','Tag','setting_enhance');
for i=1:numel(hs)
    set(hs(i),'Checked','off');
end
set(hObject,'Checked','on');
UserData.status.changed = 1;
enable_components(UserData,handles)
set(handles.figure1,'UserData',UserData);


% count from menu
% --------------------------------------------------------------------
function count_Callback(hObject, eventdata, handles)
% hObject    handle to count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
count_ClickedCallback(hObject, eventdata, handles)


% adjust brightness/contrast
% --------------------------------------------------------------------
function contrast_Callback(hObject, eventdata, handles)
% hObject    handle to contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserData=get(handles.figure1,'UserData');

h = figure(handles.figure1);

hh = imcontrast(h);

position1 = get(h, 'Position');
position2 = get(hh, 'Position');
set(hh, 'Position', [position1(1)+position1(3)+10 position1(2)+position1(4)-500 300 400]);

uiwait

% save data to workspace
% --------------------------------------------------------------------
function save_workspace_Callback(hObject, eventdata, handles)
% hObject    handle to save_workspace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UserData=get(handles.figure1,'UserData');
save
msgbox('Your data has been saved to current workspace. You can type ''load'' in the command line to check it.','Data saved','modal');


% click the orgin/apex for re-ordering cells
% --------------------------------------------------------------------
function reset_label_click_origin_Callback(hObject, eventdata, handles)
% hObject    handle to reset_label_click_origin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UserData=get(handles.figure1,'UserData');
if isempty(UserData.cell)
    errordlg('No cells!');
    return;
end

figure(handles.figure1)
set(handles.text1,'String','Please click a cell as the origin');
go_on = 1;
while go_on
    UserInput=1;
    while UserInput > 0
        UserInput = waitforbuttonpress;      % Wait for click
    end
    CurrentPoint = get(gca,'CurrentPoint')
    origin = which_cell(CurrentPoint(1,1:2),UserData.cell);
    if origin==0
        set(handles.text1,'String','You need to right-click INSIDE the cell!');
    else
        go_on =  0;
    end
end

UserData.cell = set_cell_label(UserData.cell,origin);
set(handles.figure1,'UserData',UserData);
figure(handles.figure1);
h = findobj('-regexp','Tag','plot_cell');
delete(h)
plot_all_cell(UserData.cell);
set(handles.text1,'String','Cell labels have been changed');

UserData.status.changed = 1;
enable_components(UserData,handles)
set(handles.figure1,'UserData',UserData);

% re-order cells by projecting them to an outline
% --------------------------------------------------------------------
function reset_label_click_outline_Callback(hObject, eventdata, handles)
% hObject    handle to reset_label_click_outline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UserData=get(handles.figure1,'UserData');
if isempty(UserData.cell)
    UserData
    errordlg('No cells!');
    return;
end
figure(handles.figure1)
set(handles.text1,'String','Please click out the skeleton to order cells');
skeleton=[];

go_on =1;
UserData.skeleton = getline;
set(handles.figure1,'UserData',UserData);
UserData.cell = reorder_cells(UserData.cell,UserData.skeleton);
UserData.cell = set_cell_label(UserData.cell);
set(handles.figure1,'UserData',UserData);
figure(handles.figure1);
h = findobj('-regexp','Tag','plot_cell');
delete(h)
plot_all_cell(UserData.cell);
set(handles.text1,'String','Cell labels have been changed');

UserData.status.changed = 1;
enable_components(UserData,handles)
set(handles.figure1,'UserData',UserData);

% --------------------------------------------------------------------
function reset_label_channel_peak_Callback(hObject, eventdata, handles)
% hObject    handle to reset_label_channel_peak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% reset image
% --------------------------------------------------------------------
function reset_image_Callback(hObject, eventdata, handles)
% hObject    handle to reset_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UserData=get(handles.figure1,'UserData');
imagesc(UserData.I(:,:,UserData.current_stack));colormap gray;axis square;axis off;
set(handles.text1,'String','you can now project, enhance or crop image')
set(handles.figure1,'UserData',UserData);


% to show dots or not
% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hs = findobj('-regexp','Tag','plot_cell')
hs = [hs; findobj('-regexp','Tag','plot_outline')]
hs = [hs ;findobj('-regexp','Tag','plot_dot_proj')];
hs = [hs ;findobj('-regexp','Tag','plot_neighbor')];
hs = [hs ;findobj('-regexp','Tag','plot_dot_bg')];
if ~isempty(hs)
    for i=1:length(hs)
        set(get(get(hs(i),'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude from legend
    end
end
if ~isempty(hs)
    for i=1:length(hs)
        set(get(get(hs(i),'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude from legend
    end
end
legend('off')
UserData=get(handles.figure1,'UserData');
% Hint: get(hObject,'Value') returns toggle state of checkbox3
if ~isempty(UserData.dots)
    if (get(hObject,'Value') == get(hObject,'Max'))
        % Checkbox is checked-take approriate action
        UserData=get(handles.figure1,'UserData');
        if plot_all_dot(UserData.dots);
            if isfield(UserData,'channel_name')
                legend(UserData.channel_name,'FontSize',14);
            end
        end
    else
        % Checkbox is not checked-take approriate action
        hd = findobj('-regexp','Tag','plot_dot');
        delete(hd)
        set(handles.checkbox6,'Value',0);
    end
elseif (get(hObject,'Value') == get(hObject,'Max'))
    set(handles.text1,'String','No dots!!')
end


% to show cells or not
% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserData=get(handles.figure1,'UserData');
% Hint: get(hObject,'Value') returns toggle state of checkbox4
if ~isempty(UserData.cell)
    if (get(hObject,'Value') == get(hObject,'Max'))
        % Checkbox is checked-take approriate action
        UserData=get(handles.figure1,'UserData');
        plot_all_cell(UserData.cell);
    else
        % Checkbox is not checked-take approriate action
        hd = findobj('-regexp','Tag','plot_cell');
        delete(hd)
    end
elseif (get(hObject,'Value') == get(hObject,'Max'))
    set(handles.text1,'String','No cells!!')
end

% to show which channel, main or reference
% --- Executes when selected object is changed in uipanel1.
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel1
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
hs = findobj('-regexp','Tag','plot_cell')
hs = [hs; findobj('-regexp','Tag','plot_outline')]
hs = [hs ;findobj('-regexp','Tag','plot_dot_proj')];
hs = [hs ;findobj('-regexp','Tag','plot_neighbor')];
hs = [hs ;findobj('-regexp','Tag','plot_dot_bg')];
if ~isempty(hs)
    for i=1:length(hs)
        set(get(get(hs(i),'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude from legend
    end
end
UserData=get(handles.figure1,'UserData');
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'radiobutton2'
        % Code for when radiobutton1 is selected.
        if ~isempty(UserData.reference)
            imagesc(UserData.reference)
            axis off;axis square;colormap gray;
        else
            set(handles.text1,'String','No reference images loaded!');drawnow
        end
    case 'radiobutton1'
        % Code for when radiobutton2 is selected.
        imagesc(UserData.I2)
        axis off;axis square;colormap gray;
end

if ~isempty(UserData.cell)
    if (get(handles.checkbox4,'Value') == get(handles.checkbox4,'Max'))
        % Checkbox is checked-take approriate action
        plot_all_cell(UserData.cell);
    else
        % Checkbox is not checked-take approriate action
        hd = findobj('-regexp','Tag','plot_cell');
        delete(hd)
    end
elseif (get(handles.checkbox4,'Value') == get(handles.checkbox4,'Max'))
    set(handles.text1,'String','No cells!!')
end

if ~isempty(UserData.dots)
    if (get(handles.checkbox3,'Value') == get(handles.checkbox3,'Max'))
        % Checkbox is checked-take approriate action
        if plot_all_dot(UserData.dots)
            if isfield(UserData,'channel_name')
                legend(UserData.channel_name,'FontSize',14);
            end
        end
    else
        % Checkbox is not checked-take approriate action
        hd = findobj('-regexp','Tag','plot_dot');
        delete(hd)
    end
elseif (get(handles.checkbox3,'Value') == get(handles.checkbox3,'Max'))
    set(handles.text1,'String','No dots!!')
end


% --- Executes during object creation, after setting all properties.
function checkbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function plot_counts_Callback(hObject, eventdata, handles)
% hObject    handle to plot_counts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% plot cryptogram
% --------------------------------------------------------------------
function plot_unfolded_Callback(hObject, eventdata, handles)
% hObject    handle to plot_unfolded (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserData=get(handles.figure1,'UserData');

% to click the outline or not
go_on = 1;
if ~isempty(UserData.outline)
    choice = questdlg('Do you want to RE-DRAW the outline?',...
        'Outline',...
        'Yes',...
        'No',...
        'No');
    if strcmp(choice,'No')
        go_on = 0;
    end
end

if go_on
    set(handles.text1,'String','Click crypt outline, press ENTER when done')
    UserData.outline=ginput;
    set(handles.text1,'String','Click crypt apex, press ENTER when done')
    UserData.apex=ginput;
    xi=UserData.outline(:,1);
    yi=UserData.outline(:,2);
    q = 0:length(xi)-1;
    qq = 0:0.01:length(xi)-1;
    xpts_spline = spline(q,xi,qq);
    ypts_spline = spline(q,yi,qq);
    UserData.outline=[xpts_spline;ypts_spline]';
    [yy,ind]=min((UserData.outline(:,1)-UserData.apex(1)).^2+(UserData.outline(:,2)-UserData.apex(2)).^2);
    UserData.apex = [UserData.apex ind];   %the apex position projected on the cell outline
end

hold on;
SplineCurve = plot(UserData.outline(:,1),UserData.outline(:,2),'r','LineWidth',2,'Tag','plot_outline');
pause(0.5);
delete(SplineCurve);
hold off;

MAX_OUTLINE_DIST=1000;%70.^2; % only dots within 60 pixels of the outline are projected

% let user choose the threshold
prompt = {'Only dots within T pixels of the outline will be projected. Set T='};
dlg_title = 'Set threshold for projection';
num_lines = 1;
def = {'1000'};

go_on = 1;
while go_on
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    if isempty(answer)
        return;
    end
    input =  str2num(answer{1});
    if input < 0
        warndlg('The number should be positive!','Oops!','modal');
    else
        go_on = 0;
    end
end
MAX_OUTLINE_DIST = input^2;

if size(UserData.dots,2)==5
    UserData.dots=[UserData.dots NaN(length(UserData.dots),1)]; % Each dot will be assigned a point on the outline
else
    UserData.dots(:,6)=NaN;
end

for i=1:length(UserData.dots)
    [y,UserData.dots(i,6)]=min((UserData.dots(i,1)-UserData.outline(:,1)).^2+(UserData.dots(i,2)-UserData.outline(:,2)).^2);
    if y<=MAX_OUTLINE_DIST
        UserData.dots(i,6)=UserData.dots(i,6)-UserData.apex(3);
    else
        UserData.dots(i,6)=NaN;
    end
end

%plot projection
hs = findobj('Tag','plot_dot_proj');
delete(hs);
hold on
for i=1:length(UserData.dots)
    if ~isnan(UserData.dots(i,6))
        plot([UserData.dots(i,1) UserData.outline(UserData.dots(i,6)+UserData.apex(3),1)],...
            [UserData.dots(i,2) UserData.outline(UserData.dots(i,6)+UserData.apex(3),2)],...
            'Color','w',...
            'Tag','plot_dot_proj');
    end
end

%statistics
max_loc=max(UserData.dots(:,6));
min_loc=min(UserData.dots(:,6));


% let user choose the window size
prompt = {['The default window size is half of the average cell width along the outline. Set it to:(1-' num2str(max_loc) ')']};
dlg_title = 'Please set the window size';
num_lines = 1;
def = {'auto'};

go_on = 1;
while go_on
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    if isempty(answer)
        return;
    end
    answer{1}
    if strcmp(def{1},answer{1}) % default
        % determine default window size
        if isempty(UserData.cell)
            ncell = 30;
        else
            ncell = length(UserData.cell);
        end
        half_window_size=(max_loc-min_loc+1)/ncell/4
        go_on = 0;
    else
        input =  str2num(answer{1});
        if input < 1 | input > max_loc
            warndlg('Invalid input!','Oops!','modal');
        else
            half_window_size = floor(input/2);
            go_on = 0;
        end
    end
end

set(handles.text1,'String',['window size = ' num2str(2*half_window_size+1)]);

if isfield(UserData,'crytogram')
    UserData=rmfield(UserData,'crytogram');
end

for i=1:max(UserData.dots(:,4))
    dots=UserData.dots(find(UserData.dots(:,4)==i),:);
    for j=min_loc+half_window_size:max_loc-half_window_size
        ind=find(dots(:,6)>j-half_window_size & dots(:,6)<j+half_window_size);
        UserData.crytogram{i}(abs(min_loc+half_window_size)+1+j)=numel(ind);
    end
end
ind=min_loc+half_window_size:1:max_loc-half_window_size;

figure;
hold on;
col = 'rgbm';
for i=1:length(UserData.channel_name)
    subplot(length(UserData.channel_name),1,i);
    plot(ind,UserData.crytogram{i},'Color',col(i));
    legend(UserData.channel_name{i})
    ylabel('#dots')
end

UserData.status.changed = 1;
enable_components(UserData,handles);
set(handles.figure1,'UserData',UserData);


% --------------------------------------------------------------------
function analyze_Callback(hObject, eventdata, handles)
% hObject    handle to analyze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function count_dots_Callback(hObject, eventdata, handles)
% hObject    handle to count_dots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
count_ClickedCallback(hObject, eventdata, handles)


% detect background dots
% --------------------------------------------------------------------
function detect_bg_dots_Callback(hObject, eventdata, handles)
% hObject    handle to detect_bg_dots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserData=get(handles.figure1,'UserData');

% find background dots
if max(UserData.dots(:,4)>1)
    
    % let user choose the threshold
    prompt = {'Set the distance threshold relative to minimum distance between dots within a channel'};
    dlg_title = 'Set threshold';
    num_lines = 1;
    def = {'1'};
    
    go_on = 1;
    while go_on
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        if isempty(answer)
            return;
        end
        b =  str2num(answer{1});
        if b < 0
            clicked=questdlg('The number should be positive!','Oops!','Retry','Cancel','Retry')
            switch clicked
                case 'Retry'
                case 'Cancel'
                    return;
            end
        else
            go_on = 0;
        end
    end
    
    set(handles.text1,'String','Finding potential background dots ...');drawnow;
    [bgid, id, T] = find_background_dots(UserData.dots,b);
    bgds=UserData.dots(bgid,:);
    hbg = plot(bgds(:,1),bgds(:,2),'yo','MarkerSize',10,'Tag','plot_dot_bg');
    set(handles.text1,'String',{[num2str(numel(bgid)) ' background dots found (circled)'], ['at threshold =' num2str(T)]});drawnow;
    n_bg_dots = size(bgds,1);
    n_dots = size(UserData.dots,1);
    if n_bg_dots
        msg =[num2str(n_bg_dots) ' of ' num2str(n_dots) ' in total are present in multiple channels (circled) You are recommended to remove these dots.']
        choice = questdlg(msg,...
            'Remove potential background dots',...
            'Remove',...
            'Keep them',...
            'Remove');
        if ~strcmp(choice,'Keep them')
            UserData.dots(bgid,:)=[];
            set(handles.text1,'String','Potential background dots removed');drawnow;
            hd = findobj('-regexp','Tag','plot_dot');
            delete(hd)
            plot_all_dot(UserData.dots);
        else % keep them
            delete(hbg)
        end
    end
end

UserData.status.changed = 1;
% update component status
enable_components(UserData,handles);
% save data
set(handles.figure1,'UserData',UserData);


% show outline or not
% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserData=get(handles.figure1,'UserData');
% Hint: get(hObject,'Value') returns toggle state of checkbox4
if ~isempty(UserData.outline)
    if (get(hObject,'Value') == get(hObject,'Max'))
        % Checkbox is checked-take approriate action
        plot(UserData.outline(:,1),UserData.outline(:,2),'r','LineWidth',2,'Tag','plot_outline');
    else
        % Checkbox is not checked-take approriate action
        hd = findobj('-regexp','Tag','plot_outline');
        delete(hd)
    end
elseif (get(hObject,'Value') == get(hObject,'Max'))
    set(handles.text1,'String','No outlines!!')
end

% show projection or not
% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UserData=get(handles.figure1,'UserData');
% Hint: get(hObject,'Value') returns toggle state of checkbox4
if ~isempty(UserData.outline)
    if (get(hObject,'Value') == get(hObject,'Max'))
        % Checkbox is checked-take approriate action
        
        %plot projection
        hold on
        for i=1:length(UserData.dots)
            if ~isnan(UserData.dots(i,6))
                plot([UserData.dots(i,1) UserData.outline(UserData.dots(i,6)+UserData.apex(3),1)],...
                    [UserData.dots(i,2) UserData.outline(UserData.dots(i,6)+UserData.apex(3),2)],...
                    'Color','w',...
                    'Tag','plot_dot_proj');
            end
        end
    else
        % Checkbox is not checked-take approriate action
        hd = findobj('-regexp','Tag','plot_dot_proj');
        delete(hd)
    end
elseif (get(hObject,'Value') == get(hObject,'Max'))
    set(handles.text1,'String','No outlines!!')
end

% re-ordering cells by click order
% --------------------------------------------------------------------
function reset_label_click_order_Callback(hObject, eventdata, handles)
% hObject    handle to reset_label_click_order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% delete original cell labels
hs = findobj('-regexp','Tag','plot_cell_label');
delete(hs);

UserData=get(handles.figure1,'UserData');

set(handles.text1,'String','Please click the cells in the order you want')

ind = 1;

order = zeros(length(UserData.cell),1);

last_cell = 0;

go_on = 1;
while go_on
    UserInput = -1;
    while UserInput < 0
        UserInput = waitforbuttonpress;      % Wait for click
    end
    if UserInput % key
        set(handles.text1,'String','mission terminated since you pressed a key');
        return;
    else
        CurrentPoint = get(gca,'CurrentPoint');
        found = which_cell(CurrentPoint(1,1:2),UserData.cell);
        if found==0
            set(handles.text1,'String','You need to right-click INSIDE the cell!');
        elseif last_cell ~= found
            order(ind) = found;
            last_cell = found;
            text(UserData.cell(found).center(1),UserData.cell(found).center(2),num2str(ind),...
                'FontSize',16,'Color','y','Tag','plot_cell_label','HorizontalAlignment','center');
            ind = ind + 1;
            if ind > length(UserData.cell)
                go_on = 0;
                set(handles.text1,'String','You have changed the cell labels');
            else
                set(handles.text1,'String',{'Please click the next cell','Or press any key to exit'});
            end
        else
            set(handles.text1,'String','The cell has already been labeled!');
        end
    end
end
UserData.cell=UserData.cell(order);
hs = findobj('-regexp','Tag','plot_cell_label');
delete(hs);
UserData.cell=set_cell_label(UserData.cell);
plot_all_cell(UserData.cell);

% assign dots to cell
assign_dots_to_cells(handles);

UserData.status.changed = 1;
% update component status
enable_components(UserData,handles);
% save data
set(handles.figure1,'UserData',UserData);


% --------------------------------------------------------------------
function neighbor_cell_Callback(hObject, eventdata, handles)
% hObject    handle to neighbor_cell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% click neighbors
% --------------------------------------------------------------------
function click_neighbors_Callback(hObject, eventdata, handles)
% hObject    handle to click_neighbors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserData=get(handles.figure1,'UserData');

set(handles.text1,'String','Please click two neighboring cells')

pairs = [];

first_cell = 0;

go_on = 1;
while go_on
    UserInput = -1;
    while UserInput < 0
        UserInput = waitforbuttonpress;      % Wait for click
    end
    if UserInput % key
        set(handles.text1,'String','mission terminated since you pressed a key');
        go_on = 0;
    else
        CurrentPoint = get(gca,'CurrentPoint');
        found = which_cell(CurrentPoint(1,1:2),UserData.cell);
        if found==0
            set(handles.text1,'String','You need to right-click INSIDE the cell!');
        elseif ~first_cell % if the first cell is not assigned
            first_cell = found;
        elseif first_cell ~= found % if the second is not the same as the first
            pairs = [pairs; first_cell found]
            first_cell = 0;
            plot([UserData.cell(pairs(end,1)).center(1),UserData.cell(pairs(end,2)).center(1)],...
                [UserData.cell(pairs(end,1)).center(2),UserData.cell(pairs(end,2)).center(2)],'r-.','Tag','plot_neighbor');
            plot(mean([UserData.cell(pairs(end,1)).center(1),UserData.cell(pairs(end,2)).center(1)]),...
                mean([UserData.cell(pairs(end,1)).center(2),UserData.cell(pairs(end,2)).center(2)]),'s','Tag','plot_neighbor');
            set(handles.text1,'String',{'Please click the next cell','Or press any key to exit'});
        else
            set(handles.text1,'String','You cannot click the cell again!');
        end
    end
end

UserData.neighbors=pairs;

UserData.status.changed = 1;
% update component status
enable_components(UserData,handles);
% save data
set(handles.figure1,'UserData',UserData);

% --------------------------------------------------------------------
function detect_neighbor_Callback(hObject, eventdata, handles)
% hObject    handle to detect_neighbor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function compare_neighbor_Callback(hObject, eventdata, handles)
% hObject    handle to compare_neighbor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserData=get(handles.figure1,'UserData');

celldot = UserData.num_dot_cell_channel_normalized;

offset = realmin;
set(handles.text1,'String','Calculating dots ratio between neighbors ...');
n_pair = size(UserData.neighbors,1);
n_channel = length(UserData.channel_name);
dotratio = zeros(n_pair,n_channel);
for i=1:n_channel
    for j=1:n_pair
        v1 = celldot(UserData.neighbors(j,1),i)+offset;
        v2 = celldot(UserData.neighbors(j,2),i)+offset;
        dotratio(j,i) = min([v1/v2 v2/v1]);
    end
end

set(handles.text1,'String','Calculating dots ratio between all cells ...');
n_cell = length(UserData.cell);
dotratio_bg = [];

res = zeros(1,n_channel);
for j=1:n_cell
    for k=(j+1):n_cell
        for i=1:n_channel
            v1 = celldot(j,i)+offset;
            v2 = celldot(k,i)+offset;
            res(i) = min([v1/v2 v2/v1]);
        end
        dotratio_bg=[dotratio_bg;res];
    end
end

UserData.neighbor_ratio = dotratio;
UserData.neighbor_ratio_bg = dotratio_bg;

% test significance
h = zeros(n_channel,2);
p = zeros(n_channel,2);
for i=1:n_channel
    [h(i,1),p(i,1)] = ttest2(dotratio(:,i),dotratio_bg(:,i),0.05,'left');
    [h(i,2),p(i,2)] = ttest2(dotratio(:,i),dotratio_bg(:,i),0.05,'right');
end

h
p

figure
hold on
y(1,:) = mean(UserData.neighbor_ratio);
e(1,:) = std(UserData.neighbor_ratio);
y(2,:) = mean(UserData.neighbor_ratio_bg);
e(2,:) = std(UserData.neighbor_ratio_bg);
bar(0.9:n_channel,y(1,:),0.2,'g')
errorbar(0.9:n_channel,y(1,:),e(1,:),'xr')
bar(1.1:n_channel+0.1,y(2,:),0.2,'b')
errorbar(1.1:n_channel+0.1,y(2,:),e(2,:),'xr')
axis([0.5 n_channel+0.5 0 1])
set(gca,'XTick',1:3)
set(gca,'XTickLabel',UserData.channel_name)
title('ratio of #dots in neighboring cells')

UserData.status.changed = 1;
% update component status
enable_components(UserData,handles);
% save data
set(handles.figure1,'UserData',UserData);


% --------------------------------------------------------------------
function resetcelllabel_Callback(hObject, eventdata, handles)
% hObject    handle to resetcelllabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function plot_cryptogram_Callback(hObject, eventdata, handles)
% hObject    handle to plot_cryptogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
