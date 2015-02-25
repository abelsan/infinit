function varargout = SSDN_INFINIT(varargin)
% SSDN_INFINIT MATLAB code for SSDN_INFINIT.fig
%      SSDN_INFINIT, by itself, creates a new SSDN_INFINIT or raises the existing
%      singleton*.
%
%      H = SSDN_INFINIT returns the handle to a new SSDN_INFINIT or the handle to
%      the existing singleton*.
%
%      SSDN_INFINIT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SSDN_INFINIT.M with the given input arguments.
%
%      SSDN_INFINIT('Property','Value',...) creates a new SSDN_INFINIT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SSDN_INFINIT_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SSDN_INFINIT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SSDN_INFINIT

% Last Modified by GUIDE v2.5 22-Nov-2014 11:39:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SSDN_INFINIT_OpeningFcn, ...
                   'gui_OutputFcn',  @SSDN_INFINIT_OutputFcn, ...
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


% --- Executes just before SSDN_INFINIT is made visible.
function SSDN_INFINIT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SSDN_INFINIT (see VARARGIN)

% Create the data to plot
handles.output = hObject;

axes(handles.logoL);
imshow('Images/cces_ssdn_logo.gif');
axes(handles.logoR);
imshow('Images/cces_ssdn_logo.gif');

axes(handles.KSA_map(1));
latlim = [12 34];
lonlim = [34 60];
waterColor = [0.7 0.7 0.8];
handles.KSA_map(1) = axesm('MapProjection','mercator',...
                           'MapLatLimit',latlim,'MapLonLimit',lonlim,...
                           'FFaceColor',waterColor,...
                           'Frame','on','Grid','off',...
                           'MeridianLabel','off','ParallelLabel','off');
axis off;
geoshow(handles.KSA_map(1),'TM_WORLD_BORDERS-0.3.shp','FaceColor','white');
geoshow('worldlakes.shp','FaceColor',waterColor);

handles.sliderCost = 1.00;
handles.sliderCO2 = 0.00;

handles.generate = 0;
handles.network = 0;
handles.setWeight = 0;
handles.result = 0;
handles.stackNetwork = 0;
handles.stackResult = 0;
handles.i = 0;
handles.iCurrent = 0;

axes(handles.pareto0);
col = 0.85*[1 1 1];
set(handles.pareto0,'XColor',col,'YColor',col,'XMinorGrid','on','YMinorGrid','on','MinorGridLineStyle','-','XTickLabel',[],'YTickLabel',[],'Visible','on');

axes(handles.pareto);
set(handles.pareto,'Color','none','XColor','k','YColor','k','Box','on','Visible','on');
xlabel('Total Cost (CAPEX+OPEX) [BUSD/year]','FontSize',8);
ylabel('Total CO2 Emission [MMT/year]','FontSize',8);

load('readData.mat');
handles.numCity = numCity;
handles.txtCity = txtCity;
handles.numDesal = numDesal;
handles.txtDesal = txtDesal;
handles.numDesalCandid = numDesalCandid;
handles.txtDesalCandid = txtDesalCandid;
handles.numPower = numPower;
handles.txtPower = txtPower;
handles.numPipeline = numPipeline;
handles.txtPipeline = txtPipeline;
handles.numPipelineCandid = numPipelineCandid;
handles.txtPipelineCandid = txtPipelineCandid;
handles.numPowerline = numPowerline;
handles.txtPowerline = txtPowerline;

% Choose default command line output for SSDN_INFINIT

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SSDN_INFINIT wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SSDN_INFINIT_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function step1_edit1_Callback(hObject, eventdata, handles)
% hObject    handle to step1_edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of step1_edit1 as text
%        str2double(get(hObject,'String')) returns contents of step1_edit1 as a double
set(handles.step1_text2,'ForegroundColor',[0.5 0.5 0.5]);


% --- Executes during object creation, after setting all properties.
function step1_edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to step1_edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_pushbutton.
function load_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to load_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.step1_text2,'String','Wait...','ForegroundColor','red','FontWeight','bold');
set(handles.step2_text11,'ForegroundColor',[0.5 0.5 0.5]);
set(handles.step2_text21,'ForegroundColor',[0.5 0.5 0.5]);
set(handles.step3_text15,'ForegroundColor',[0.5 0.5 0.5]);
set(handles.step3_text25,'ForegroundColor',[0.5 0.5 0.5]);
drawnow;

filename = get(handles.step1_edit1,'String');

% Node
[handles.numCity,handles.txtCity] = xlsread(filename,'City','A3:AZ1000'); % City
[handles.numDesal,handles.txtDesal] = xlsread(filename,'Desal','A3:AZ1000'); % Desal
[handles.numDesalCandid,handles.txtDesalCandid] = xlsread(filename,'Desal_Candid','A3:AZ1000'); % Desal Candidate
[handles.numPower,handles.txtPower] = xlsread(filename,'Power','A3:AZ1000'); % Power

% Edge
[handles.numPipeline,handles.txtPipeline] = xlsread(filename,'Pipeline','A3:AZ1000'); % Pipeline
[handles.numPipelineCandid,handles.txtPipelineCandid] = xlsread(filename,'Pipeline_Candid','A3:AZ1000'); % Pipeline Candidate
[handles.numPowerline,handles.txtPowerline] = xlsread(filename,'Powerline','A3:AZ1000'); % Powerline

set(handles.step1_text2,'String','Done!  ','ForegroundColor','blue','FontWeight','bold');

guidata(hObject, handles);


% --- Executes on button press in generate_pushbutton.
function generate_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to generate_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.step2_text11,'String','Wait...','ForegroundColor','red','FontWeight','bold');
set(handles.step2_text21,'ForegroundColor',[0.5 0.5 0.5]);
set(handles.step3_text15,'ForegroundColor',[0.5 0.5 0.5]);
set(handles.step3_text25,'ForegroundColor',[0.5 0.5 0.5]);
drawnow;

% Flow Variables
%   1: feed water [m^3/day]
%   2: potable water [m^3/day]
%   3: non-potable water [m^3/day]
%   4: waste water [m^3/day]
%   5: power resource [MW]
%   6: electricity [MW]
handles.flow = {'feed water';
                'potable water';
                'non-potable water';
                'waste water';
                'power resource';
                'electricity'};
handles.v = size(handles.flow,1); % number of flow variables

% Decision Binary Variables
%   1: water
%   2: power
handles.binary = {'water';
                  'power'};
handles.vw = [1 0;1 0;1 0;1 0;0 1;0 1]; % mapping matrix from flow to binary
handles.w = size(handles.binary,1); % number of binary variables

% Key performance indicators (KPI)
%   1: total CAPEX [USD/year]
%   2: total OPEX [USD/year]
%   3: total CO2 emission [kg/day]
%   4: total potable water produced [m^3/day]
%   5: total electricity produced [kWh/day]
%   6: ...
handles.KPI = {'CAPEX'
               'OPEX'
               'CO2'
               'potable water';
               'electricity'};

% Objective Function Weight
handles.W = zeros(size(handles.KPI));
handles.W(index(handles.KPI,'CAPEX')) = 1;
handles.W(index(handles.KPI,'OPEX')) = 1;
handles.W(index(handles.KPI,'CO2')) = 0;
handles.W(index(handles.KPI,'potable water')) = 0;
handles.W(index(handles.KPI,'electricity')) = 0;

% Node Set Definition
handles.setNode = [];
[handles.setNode] = setupExistingNodes(handles.setNode,handles.numCity,handles.txtCity,handles.numDesal,handles.txtDesal,handles.numPower,handles.txtPower,handles.flow,handles.v); % existing nodes
[handles.setNode] = setupCandidateNodes(handles.setNode,handles.numDesalCandid,handles.txtDesalCandid,handles.flow,handles.v); % candidate nodes
handles.N = size(handles.setNode,1); % number of nodes

% Edge Set Definition
handles.setEdge = [];
[handles.setEdge] = setupExistingLoops(handles.setNode,handles.setEdge,handles.numCity,handles.txtCity,handles.numDesal,handles.txtDesal,handles.numPower,handles.txtPower,handles.flow,handles.v,handles.w,handles.KPI); % existing resource processing loops
[handles.setEdge] = setupCandidateLoops(handles.setNode,handles.setEdge,handles.numDesalCandid,handles.txtDesalCandid,handles.flow,handles.v,handles.w,handles.KPI); % candidate resource processing loops
[handles.setEdge] = setupExistingEdges(handles.setNode,handles.setEdge,handles.numPipeline,handles.txtPipeline,handles.numPowerline,handles.txtPowerline,handles.flow,handles.v,handles.binary,handles.w,handles.KPI); % existing pipelines and powerlines
[handles.setEdge] = setupCandidateEdges(handles.setNode,handles.setEdge,handles.numPipelineCandid,handles.txtPipelineCandid,handles.flow,handles.v,handles.binary,handles.w,handles.KPI); % candidate pipelines
handles.E = size(handles.setEdge,1); % number of edges

% INFINIT MILP Parameters
% setNode                           setEdge
%  1: node ID                        1: edge ID
%  2: node name                      2: edge name
%  3: node region                    3: edge type
%  4: node type                      4: origin & destination
%  5: coordinates                    5: objective function coefficient for flow: cx
%  6: supply/demand                  6: objective function coefficient for capacity expansion: cy
%  7: other important properties     7: objective function coefficient for edge usage: cz
%                                    8: requirement matrix for outflow: Ao
%                                    9: requirement matrix for inflow: Ai
%                                   10: transformation matrix: B
%                                   11: concurrency matrix for outflow: Co
%                                   12: concurrency matrix for inflow: Ci
%                                   13: lower bound for outflow: lo
%                                   14: lower bound for inflow: li
%                                   15: current capacity for outflow: uo
%                                   16: current capacity for inflow: ui
OD = handles.setEdge(:,4); % origin and destination of each edge
handles.cx = handles.setEdge(:,5);
handles.cy = handles.setEdge(:,6);
handles.cz = handles.setEdge(:,7);
Ao = handles.setEdge(:,8);
Ai = handles.setEdge(:,9);
bc = handles.setNode(:,6);
B = handles.setEdge(:,10);
Co = handles.setEdge(:,11);
Ci = handles.setEdge(:,12);
lo = handles.setEdge(:,13);
li = handles.setEdge(:,14);
uo = handles.setEdge(:,15);
ui = handles.setEdge(:,16);

[handles.fall,handles.f,handles.Aineq,handles.bineq,handles.Aeq,handles.beq,handles.lb] = setupINFINIT(handles.v,handles.w,handles.vw,handles.W,handles.N,handles.E,OD,handles.cx,handles.cy,handles.cz,Ao,Ai,bc,B,Co,Ci,lo,li,uo,ui);
xstr = repmat('C',1,2*handles.v);
ystr = repmat('C',1,2*handles.v);
zstr = repmat('B',1,handles.w);
handles.ctype = repmat([xstr ystr zstr],1,handles.E);

handles.generate = 1;
handles.network = 0;

set(handles.step2_text11,'String','Done!  ','ForegroundColor','blue','FontWeight','bold');

guidata(hObject, handles);


% --- Executes on button press in network_pushbutton.
function network_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to network_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.generate == 1
    set(handles.step2_text21,'String','Wait...','ForegroundColor','red','FontWeight','bold');
    drawnow;
    
    if handles.network == 0
        handles.KSA_map(2) = axes('Position',[0.23117033603707995 0.015677491601343786 0.4640787949015064 0.7894736842105263]);
        axes(handles.KSA_map(2));
        cla;
        latlim = [12 34];
        lonlim = [34 60];
        waterColor = [0.7 0.7 0.8];
        handles.KSA_map(2) = axesm('MapProjection','mercator',...
                                   'MapLatLimit',latlim,'MapLonLimit',lonlim,...
                                   'FFaceColor',waterColor,...
                                   'Frame','on','Grid','off',...
                                   'MeridianLabel','off','ParallelLabel','off');
        axis off;
        geoshow(handles.KSA_map(2),'TM_WORLD_BORDERS-0.3.shp','FaceColor','white');
        geoshow('worldlakes.shp','FaceColor',waterColor);
        drawEdges(handles.setNode,handles.setEdge);
        layoutNodes(handles.setNode);
        handles.network = 1;
        handles.stackNetwork = 1;
        handles.stackResult = 0;
    elseif handles.network == 1
        uistack(handles.KSA_map(2),'top');
        handles.stackNetwork = 1;
        handles.stackResult = 0;
    end
    
    set(handles.step2_text21,'String','Done!  ','ForegroundColor','blue','FontWeight','bold');
    
    guidata(hObject, handles);
end


% --- Executes on slider movement.
function weights_slider1_Callback(hObject, eventdata, handles)
% hObject    handle to weights_slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.step3_text15,'ForegroundColor',[0.5 0.5 0.5]);
set(handles.step3_text25,'ForegroundColor',[0.5 0.5 0.5]);

handles.sliderCost = round(get(hObject,'Value')*100)/100;
set(handles.step3_text12,'String',num2str(handles.sliderCost,'%1.2f'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function weights_slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to weights_slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function weights_slider2_Callback(hObject, eventdata, handles)
% hObject    handle to weights_slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.step3_text15,'ForegroundColor',[0.5 0.5 0.5]);
set(handles.step3_text25,'ForegroundColor',[0.5 0.5 0.5]);

handles.sliderCO2 = round(get(hObject,'Value')*100)/100;
set(handles.step3_text14,'String',num2str(handles.sliderCO2,'%1.2f'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function weights_slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to weights_slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in set_pushbutton.
function set_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to set_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.generate == 1
    set(handles.step3_text15,'String','Wait...','ForegroundColor','red','FontWeight','bold');
    set(handles.step3_text25,'ForegroundColor',[0.5 0.5 0.5]);
    drawnow;
    
    % Normalizer
    normCost = 6.7173; % 2010-2030
    normCO2 = 11.9896; % 2010-2030
    % normCost = 6.8368; % 2010-2030 twice pipeline CAPEX
    % normCO2 = 24.5628; % 2010-2030 twice pipeline CAPEX
    
    % Objective Function Weight
    handles.W = zeros(size(handles.KPI));
    handles.weightCost = handles.sliderCost/(handles.sliderCost+handles.sliderCO2);
    handles.weightCO2 = 1-handles.weightCost;
    e = 1e-6;
    handles.W(index(handles.KPI,'CAPEX')) = handles.weightCost/normCost+e;
    handles.W(index(handles.KPI,'OPEX')) = handles.weightCost/normCost+e;
    handles.W(index(handles.KPI,'CO2')) = handles.weightCO2/normCO2+e;
    handles.W(index(handles.KPI,'potable water')) = 0;
    handles.W(index(handles.KPI,'electricity')) = 0;
    
    [handles.fall,handles.f] = setupObjFun(handles.v,handles.w,handles.W,handles.E,handles.cx,handles.cy,handles.cz);
    
    handles.setWeight = 1;
    
    set(handles.step3_text15,'String','Done!  ','ForegroundColor','blue','FontWeight','bold');
    
    guidata(hObject, handles);
end


function step3_edit1_Callback(hObject, eventdata, handles)
% hObject    handle to step3_edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of step3_edit1 as text
%        str2double(get(hObject,'String')) returns contents of step3_edit1 as a double
set(handles.step3_text25,'ForegroundColor',[0.5 0.5 0.5]);


% --- Executes during object creation, after setting all properties.
function step3_edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to step3_edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function step3_edit2_Callback(hObject, eventdata, handles)
% hObject    handle to step3_edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of step3_edit2 as text
%        str2double(get(hObject,'String')) returns contents of step3_edit2 as a double
set(handles.step3_text25,'ForegroundColor',[0.5 0.5 0.5]);


% --- Executes during object creation, after setting all properties.
function step3_edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to step3_edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in optimize_pushbutton.
function optimize_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to optimize_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.generate == 1 && handles.setWeight == 1
    set(handles.step3_text25,'String','Wait...','ForegroundColor','red','FontWeight','bold');
    drawnow;
   
    addpath('/opt/ibm/ILOG/CPLEX_Studio126/cplex/matlab/');
    
    % Options
    options = cplexoptimset;
%     options = cplexoptimset('cplex');
    options.timelimit = str2double(get(handles.step3_edit1,'String'));
    options.parameter2009 = str2double(get(handles.step3_edit2,'String'))/100;
    
    % MILP Solver (CPLEX)
    [x,J,exitflag,output] = cplexmilp(handles.f,handles.Aineq,handles.bineq,handles.Aeq,handles.beq,[],[],[],handles.lb,[],handles.ctype,[],options);
    
    handles.i = handles.i+1;
    
    handles.fx = handles.fall'*x;
    handles.xyz = splitvw(x,handles.v,handles.w,handles.vw,handles.E);
    
    if output.cplexstatus == 102
        handles.termination{handles.i} = ['Optimality Gap of ' get(handles.step3_edit2,'String') '%'];
        set(handles.result_text02,'String',handles.termination{handles.i},'ForegroundColor','blue','FontWeight','bold');
    elseif output.cplexstatus == 107
        handles.termination{handles.i} = ['Time Limit of ' get(handles.step3_edit1,'String') ' sec'];
        set(handles.result_text02,'String',handles.termination{handles.i},'ForegroundColor','red','FontWeight','bold');
    else
        handles.termination{handles.i} = 'Unknown';
        set(handles.result_text02,'String',handles.termination{handles.i},'ForegroundColor','black','FontWeight','bold');
    end
    handles.CAPEX(handles.i) = handles.fx(index(handles.KPI,'CAPEX'))/10^6;
    handles.OPEX(handles.i) = handles.fx(index(handles.KPI,'OPEX'))/10^6;
    handles.cost(handles.i) = handles.CAPEX(handles.i)+handles.OPEX(handles.i);
    handles.CO2(handles.i) = handles.fx(index(handles.KPI,'CO2'))/10^9;
    handles.potable(handles.i) = handles.fx(index(handles.KPI,'potable water'))*365/10^6;
    totalDemandWater = 0; % [m^3/day]
    for i = 1:size(handles.setNode,1)
        totalDemandWater = totalDemandWater+abs(handles.setNode{i,6}(index(handles.flow,'potable water')));
    end
    handles.totalLossWater(handles.i) = (handles.fx(index(handles.KPI,'potable water'))-totalDemandWater)/handles.fx(index(handles.KPI,'potable water'))*100; % [%]
    handles.electricity(handles.i) = handles.fx(index(handles.KPI,'electricity'))*365/10^6;
    set(handles.result_text12,'String',[num2str(handles.cost(handles.i),'%6.0f') ' '],'FontWeight','bold'); % total cost
    set(handles.result_text22,'String',[num2str(handles.CAPEX(handles.i),'%6.0f') ' ']); % total CAPEX
    set(handles.result_text32,'String',[num2str(handles.OPEX(handles.i),'%6.0f') ' ']); % total OPEX
    set(handles.result_text42,'String',[num2str(handles.CO2(handles.i),'%6.2f') ' '],'FontWeight','bold'); % total CO2 emission
    set(handles.result_text52,'String',[num2str(handles.potable(handles.i),'%6.0f') ' '],'FontWeight','bold'); % total potable water production
    set(handles.result_text62,'String',[num2str(handles.totalLossWater(handles.i),'%6.1f') ' ']); % total water loss in pipeline
    set(handles.result_text72,'String',[num2str(handles.electricity(handles.i),'%6.0f') ' '],'FontWeight','bold'); % total electricity generation
    
    handles.KSA_result(handles.i) = axes('Position',[0.23117033603707995 0.015677491601343786 0.4640787949015064 0.7894736842105263]);
    axes(handles.KSA_result(handles.i));
    latlim = [12 34];
    lonlim = [34 60];
    waterColor = [0.7 0.7 0.8];
    handles.KSA_result(handles.i) = axesm('MapProjection','mercator',...
                                          'MapLatLimit',latlim,'MapLonLimit',lonlim,...
                                          'FFaceColor',waterColor,...
                                          'Frame','on','Grid','off',...
                                          'MeridianLabel','off','ParallelLabel','off');
    axis off;
    geoshow(handles.KSA_result(handles.i),'TM_WORLD_BORDERS-0.3.shp','FaceColor','white');
    geoshow('worldlakes.shp','FaceColor',waterColor);
    drawEdgesExisting(handles.setNode,handles.setEdge);
    drawEdgesUsedWater(handles.setNode,handles.setEdge,handles.xyz);
    layoutNodesUsed(handles.setNode,handles.setEdge,handles.flow,handles.xyz);
    weightCostS = sprintf('%1.2f',handles.weightCost);
    weightCO2S = sprintf('%1.2f',handles.weightCO2);
    textm(14.4,54.5,'Weights','Color','k','FontSize',12,'FontWeight','bold','FontName','Calibri');
    textm(14.4,51.9,'Cost','Color','k','FontSize',12,'FontWeight','bold','FontName','Calibri');
    textm(14.4,58.0,'CO2','Color','k','FontSize',12,'FontWeight','bold','FontName','Calibri');
    textm(14.9,52.0,weightCostS,'Color','k','FontSize',10,'FontName','Calibri');
    textm(14.9,58.05,weightCO2S,'Color','k','FontSize',10,'FontName','Calibri');
    geoshow([13.4-0.5 13.4+0.5],[52.5 52.5],'LineWidth',3,'Color','k');
    geoshow([13.4-0.5 13.4+0.5],[58.5 58.5],'LineWidth',3,'Color','k');
    geoshow([13.4 13.4],[52.5 58.5],'LineWidth',3,'Color','k');
    geoshow(13.4,52.5+(58.5-52.5)*handles.weightCO2,'DisplayType','multipoint',...
                                                    'Marker','o','LineWidth',2.5,'MarkerEdgeColor',[0 0.7 1],'MarkerFaceColor',[0 1 0.7],...
                                                    'MarkerSize',12);
    geoshow(13.4,52.5+(58.5-52.5)*handles.weightCO2,'DisplayType','multipoint',...
                                                    'Marker','x','LineWidth',2.5,'MarkerEdgeColor',[0 0.7 1],...
                                                    'MarkerSize',12);
    
    axes(handles.pareto);
    handles.paretoPlot(handles.i) = plot(handles.cost(handles.i)/10^3,handles.CO2(handles.i),'rx','LineWidth',1.5,'MarkerSize',8); % 'MarkerEdgeColor','k','MarkerFaceColor','g'
    handles.paretoCurrent(handles.i) = plot(handles.cost(handles.i)/10^3,handles.CO2(handles.i),'o','LineWidth',1,'MarkerEdgeColor',[1 0.85 0],'MarkerFaceColor',[1 0.85 0],'MarkerSize',12);
    uistack(handles.paretoCurrent(handles.i),'bottom');
    if handles.i > 1
        set(handles.paretoCurrent(handles.iCurrent),'Visible','off');
    else
        handles.result = 1;
    end
    
    handles.stackNetwork = 0;
    for i = 1:handles.i
        handles.stackResult(i) = 1;
    end
    handles.iCurrent = handles.i;
    
    set(handles.step3_text25,'String','Done!  ','ForegroundColor','blue','FontWeight','bold');
    
    guidata(hObject, handles);
end


% --- Executes on button press in switch_pushbutton.
function switch_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to switch_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.stackNetwork == 0
    if handles.generate == 1 && handles.network == 0
        handles.KSA_map(2) = axes('Position',[0.23117033603707995 0.015677491601343786 0.4640787949015064 0.7894736842105263]);
        axes(handles.KSA_map(2));
        cla;
        latlim = [12 34];
        lonlim = [34 60];
        waterColor = [0.7 0.7 0.8];
        handles.KSA_map(2) = axesm('MapProjection','mercator',...
                                   'MapLatLimit',latlim,'MapLonLimit',lonlim,...
                                   'FFaceColor',waterColor,...
                                   'Frame','on','Grid','off',...
                                   'MeridianLabel','off','ParallelLabel','off');
        axis off;
        geoshow(handles.KSA_map(2),'TM_WORLD_BORDERS-0.3.shp','FaceColor','white');
        geoshow('worldlakes.shp','FaceColor',waterColor);
        drawEdges(handles.setNode,handles.setEdge);
        layoutNodes(handles.setNode);
        handles.network = 1;
        handles.stackNetwork = 1;
    elseif  handles.network == 1
        uistack(handles.KSA_map(2),'top');
        handles.stackNetwork = 1;
    end
    set(handles.paretoCurrent(handles.iCurrent),'Visible','off');
elseif handles.stackNetwork == 1
    if handles.result == 1
        uistack(handles.KSA_result(handles.iCurrent),'top');
        handles.stackNetwork = 0;
        set(handles.paretoCurrent(handles.iCurrent),'Visible','on');
    end
end

guidata(hObject, handles);


% --- Executes on button press in previous_pushbutton.
function previous_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to previous_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.stackNetwork == 0
    if handles.iCurrent > 1
        uistack(handles.KSA_result(handles.iCurrent-1),'top');
        handles.stackResult(handles.iCurrent) = 0;
        
        set(handles.paretoCurrent(handles.iCurrent),'Visible','off');
        
        handles.iCurrent = handles.iCurrent-1;
        
        if strncmp(handles.termination{handles.iCurrent},'Opti',4) == 1
            set(handles.result_text02,'String',handles.termination{handles.iCurrent},'ForegroundColor','blue','FontWeight','bold');
        elseif strncmp(handles.termination{handles.iCurrent},'Time',4) == 1
            set(handles.result_text02,'String',handles.termination{handles.iCurrent},'ForegroundColor','red','FontWeight','bold');
        else
            set(handles.result_text02,'String',handles.termination{handles.iCurrent},'ForegroundColor','black','FontWeight','bold');
        end
        set(handles.result_text12,'String',[num2str(handles.cost(handles.iCurrent),'%6.0f') ' '],'FontWeight','bold'); % total cost
        set(handles.result_text22,'String',[num2str(handles.CAPEX(handles.iCurrent),'%6.0f') ' ']); % total CAPEX
        set(handles.result_text32,'String',[num2str(handles.OPEX(handles.iCurrent),'%6.0f') ' ']); % total OPEX
        set(handles.result_text42,'String',[num2str(handles.CO2(handles.iCurrent),'%6.2f') ' '],'FontWeight','bold'); % total CO2 emission
        set(handles.result_text52,'String',[num2str(handles.potable(handles.iCurrent),'%6.0f') ' '],'FontWeight','bold'); % total potable water production
        set(handles.result_text62,'String',[num2str(handles.totalLossWater(handles.iCurrent),'%6.1f') ' ']); % total water loss in pipeline
        set(handles.result_text72,'String',[num2str(handles.electricity(handles.iCurrent),'%6.0f') ' '],'FontWeight','bold'); % total electricity generation
        
        set(handles.paretoCurrent(handles.iCurrent),'Visible','on');
    end
elseif handles.stackNetwork == 1
    if handles.result == 1
        uistack(handles.KSA_result(handles.iCurrent),'top');
        handles.stackNetwork = 0;
        handles.stackResult(handles.iCurrent) = 1;
        set(handles.paretoCurrent(handles.iCurrent),'Visible','on');
    end
end

guidata(hObject, handles);


% --- Executes on button press in next_pushbutton.
function next_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to next_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.stackNetwork == 0
    if handles.iCurrent < handles.i
        uistack(handles.KSA_result(handles.iCurrent+1),'top');
        handles.stackResult(handles.iCurrent+1) = 1;
        
        set(handles.paretoCurrent(handles.iCurrent),'Visible','off');
        
        handles.iCurrent = handles.iCurrent+1;
        
        if strncmp(handles.termination{handles.iCurrent},'Opti',4) == 1
            set(handles.result_text02,'String',handles.termination{handles.iCurrent},'ForegroundColor','blue','FontWeight','bold');
        elseif strncmp(handles.termination{handles.iCurrent},'Time',4) == 1
            set(handles.result_text02,'String',handles.termination{handles.iCurrent},'ForegroundColor','red','FontWeight','bold');
        else
            set(handles.result_text02,'String',handles.termination{handles.iCurrent},'ForegroundColor','black','FontWeight','bold');
        end
        set(handles.result_text12,'String',[num2str(handles.cost(handles.iCurrent),'%6.0f') ' '],'FontWeight','bold'); % total cost
        set(handles.result_text22,'String',[num2str(handles.CAPEX(handles.iCurrent),'%6.0f') ' ']); % total CAPEX
        set(handles.result_text32,'String',[num2str(handles.OPEX(handles.iCurrent),'%6.0f') ' ']); % total OPEX
        set(handles.result_text42,'String',[num2str(handles.CO2(handles.iCurrent),'%6.2f') ' '],'FontWeight','bold'); % total CO2 emission
        set(handles.result_text52,'String',[num2str(handles.potable(handles.iCurrent),'%6.0f') ' '],'FontWeight','bold'); % total potable water production
        set(handles.result_text62,'String',[num2str(handles.totalLossWater(handles.iCurrent),'%6.1f') ' ']); % total water loss in pipeline
        set(handles.result_text72,'String',[num2str(handles.electricity(handles.iCurrent),'%6.0f') ' '],'FontWeight','bold'); % total electricity generation
        
        set(handles.paretoCurrent(handles.iCurrent),'Visible','on');
    end
elseif handles.stackNetwork == 1
    if handles.result == 1
        uistack(handles.KSA_result(handles.iCurrent),'top');
        handles.stackNetwork = 0;
        handles.stackResult(handles.iCurrent) = 1;
        set(handles.paretoCurrent(handles.iCurrent),'Visible','on');
    end
end

guidata(hObject, handles);


% --- Executes on button press in delete_pushbutton.
function delete_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to delete_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uistack(handles.KSA_map(1),'top');
if handles.network == 1
    delete(handles.KSA_map(2));
end
for i = 1:handles.i
    delete(handles.KSA_result(i));
    delete(handles.paretoPlot(i));
    delete(handles.paretoCurrent(i));
end
clear handles.termination;
clear handles.CAPEX;
clear handles.OPEX;
clear handles.cost;
clear handles.CO2;
clear handles.potable;
clear handles.totalLossWater;
clear handles.electricity;
set(handles.result_text02,'String',[],'ForegroundColor','blue','FontWeight','bold');
set(handles.result_text12,'String',[],'FontWeight','bold'); % total cost
set(handles.result_text22,'String',[]); % total CAPEX
set(handles.result_text32,'String',[]); % total OPEX
set(handles.result_text42,'String',[],'FontWeight','bold'); % total CO2 emission
set(handles.result_text52,'String',[],'FontWeight','bold'); % total potable water production
set(handles.result_text62,'String',[]); % total water loss in pipeline
set(handles.result_text72,'String',[],'FontWeight','bold'); % total electricity generation

set(handles.step1_text2,'String',[],'ForegroundColor','red','FontWeight','bold');
set(handles.step2_text11,'String',[],'ForegroundColor',[0.5 0.5 0.5]);
set(handles.step2_text21,'String',[],'ForegroundColor',[0.5 0.5 0.5]);
set(handles.step3_text15,'String',[],'ForegroundColor',[0.5 0.5 0.5]);
set(handles.step3_text25,'String',[],'ForegroundColor',[0.5 0.5 0.5]);

handles.generate = 0;
handles.network = 0;
handles.setWeight = 0;
handles.result = 0;
handles.stackNetwork = 0;
handles.stackResult = 0;
handles.i = 0;
handles.iCurrent = 0;

load('readData.mat');
handles.numCity = numCity;
handles.txtCity = txtCity;
handles.numDesal = numDesal;
handles.txtDesal = txtDesal;
handles.numDesalCandid = numDesalCandid;
handles.txtDesalCandid = txtDesalCandid;
handles.numPower = numPower;
handles.txtPower = txtPower;
handles.numPipeline = numPipeline;
handles.txtPipeline = txtPipeline;
handles.numPipelineCandid = numPipelineCandid;
handles.txtPipelineCandid = txtPipelineCandid;
handles.numPowerline = numPowerline;
handles.txtPowerline = txtPowerline;

guidata(hObject, handles);
