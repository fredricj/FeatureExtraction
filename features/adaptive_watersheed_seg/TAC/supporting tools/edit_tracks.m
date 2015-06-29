% ----------------------------------------------------------------------------------------------------------
% Created as part of TACTICS v2.x Toolbox under BSD License
% TACTICS (Totally Automated Cell Tracking In Confinement Systems) is a Matlab toolbox for High Content Analysis (HCA) of fluorescence tagged proteins organization within tracked cells. It designed to provide a platform for analysis of Multi-Channel Single-Cell Tracking and High-Trough Output Quantification of Imaged lymphocytes in Microfabricated grids arrays.
% We wish to make TACTICS V2.x available, in executable form, free for academic research use distributed under BSD License.
% IN ADDITION, SINCE TACTICS USE THIRD OPEN-CODE LIBRARY (I.E TRACKING ALGORITHEMS, FILTERS, GUI TOOLS, ETC) APPLICABLE ACKNOLEDMENTS HAVE TO BE SAVED TO ITS AUTHORS.
% ----------------------------------------------------------------------------------------------------------
% Copyright (c) 2010-2013, Raz Shimoni
% All rights reserved.
% Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
% Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
% Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE
% ----------------------------------------------------------------------------------------------------------
%
% NOTES-
% Although TACTICS is free it does require Matlab commercial license.
% We do not expect co-authorship for any use of TACTICS. However, we would appreciate if TACTICS would be mentioned in the acknowledgments when it used for publications and/or including the next citation: [enter our Bioinformatics]
% We are looking for collaborations and wiling to setup new components customized by the requirements in exchange to co-authorship.
%  Support and feedbacks
% TACTICS is supported trough Matlab file exchange forums or contact us directly. Updates are expected regularly. We are happy to accept any suggestions to improve the automation capability and the quality of the analysis.
%
% For more information please contact:
% Centre for Micro-Photonics (CMP)
% The Faculty of Engineering and Industrial Sciences (FEIS)
% Swinburne University of Technology, Melbourne, Australia
% URL: http://www.swinburne.edu.au/engineering/cmp/
% Email: RShimoni@groupwise.swin.edu.au
% ----------------------------------------------------------------------------------------------------------
% Note for developers- Future version will include better structure and documentation.
% Sorrry, Raz.
% Code starts here:
function varargout = edit_tracks(varargin)
% EDIT_TRACKS M-file for edit_tracks.fig
%      EDIT_TRACKS, by itself, creates a new EDIT_TRACKS or raises the existing
%      singleton*.
%
%      H = EDIT_TRACKS returns the handle to a new EDIT_TRACKS or the handle to
%      the existing singleton*.
%
%      EDIT_TRACKS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EDIT_TRACKS.M with the given input arguments.
%
%      EDIT_TRACKS('Property','Value',...) creates a new EDIT_TRACKS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before set_track_params_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to edit_tracks_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help edit_tracks

% Last Modified by GUIDE v2.5 25-Sep-2012 15:57:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @edit_tracks_OpeningFcn, ...
    'gui_OutputFcn',  @edit_tracks_OutputFcn, ...
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


% --- Executes just before edit_tracks is made visible.
function edit_tracks_OpeningFcn(hObject, eventdata, handles, varargin)



varargin{2}

set(handles.start_track,'String',num2str(varargin{1}))
set(handles.end_track,'String',num2str(varargin{2}))



varargout{1}= 1
varargout{2}=10
varargout{3}= nan
varargout{4}=1
varargout{5}=2
varargout{6}=100
varargout{7}=1
varargout{8}=nan



uiwait
handles.velocity=str2num(get(handles.max_velocity_GUI,'String'))
handles.maxdisp=str2num(get(handles.max_disps_GUI,'String'))
handles.algorithm = get(handles.algorithm_GUI,'value')
handles.dim=2;
handles.mindisp=str2num(get(handles.min_disps_GUI,'String'))
handles.mem=str2num(get(handles.memory_track_GUI,'String')) %recover
handles.start_track=str2num(get(handles.start_track,'String'))
handles.end_track=str2num(get(handles.end_track,'String'))
guidata(hObject,handles);




% --- Outputs from this function are returned to the command line.
function varargout = edit_tracks_OutputFcn(hObject, eventdata, handles)





varargout{1}= handles.algorithm
varargout{2}=handles.mindisp
varargout{3}= handles.maxdisp
varargout{4}=handles.mem
varargout{5}=2
varargout{6}=handles.velocity
varargout{7}=handles.start_track
varargout{8}=handles.end_track



close

% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;



function max_disps_GUI_Callback(hObject, eventdata, handles)
maxdisp=get(hObject,'String');
handles.maxdisp=str2num(maxdisp);
set(hObject,'String',maxdisp);

guidata(hObject,handles);

% hObject    handle to max_disps_GUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_disps_GUI as text
%        str2double(get(hObject,'String')) returns contents of max_disps_GUI as a double


% --- Executes during object creation, after setting all properties.
function max_disps_GUI_CreateFcn(hObject, eventdata, handles)

% hObject    handle to max_disps_GUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function dimensions_Callback(hObject, eventdata, handles)
dim=get(hObject,'String');
handles.dim=str2num(dim);
set(hObject,'String',dim);


guidata(hObject,handles);

% hObject    handle to dimensions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dimensions as text
%        str2double(get(hObject,'String')) returns contents of dimensions as a double


% --- Executes during object creation, after setting all properties.
function dimensions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dimensions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function min_disps_GUI_Callback(hObject, eventdata, handles)
good=get(hObject,'String');
handles.good=str2num(good);
set(hObject,'String',good);


guidata(hObject,handles);

% hObject    handle to min_disps_GUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min_disps_GUI as text
%        str2double(get(hObject,'String')) returns contents of min_disps_GUI as a double


% --- Executes during object creation, after setting all properties.
function min_disps_GUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min_disps_GUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function memory_track_GUI_Callback(hObject, eventdata, handles)
mem=get(hObject,'String');
handles.mem=num2str(mem);

guidata(hObject,handles);

% hObject    handle to memory_track_GUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of memory_track_GUI as text
%        str2double(get(hObject,'String')) returns contents of memory_track_GUI as a double


% --- Executes during object creation, after setting all properties.
function memory_track_GUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to memory_track_GUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)




handles.velocity=str2num(get(handles.max_velocity_GUI,'String'))
handles.maxdisp=str2num(get(handles.max_disps_GUI,'String'))
handles.algorithm = get(handles.algorithm_GUI,'value')
handles.dim=2;
handles.mindisp=str2num(get(handles.min_disps_GUI,'String'))
handles.mem=str2num(get(handles.memory_track_GUI,'String')) %recover


% varargout{1}=handles.maxdisp
% varargout{2}=handles.dim
% varargout{3}=handles.good
% varargout{4}=handles.mem

guidata(hObject,handles);

uiresume
% varargout{1}=handles.maxdisp;
% varargout{2}=handles.dim;
% varargout{3}=handles.good;
% varargout{4}=handles.mem;
% handles

function max_velocity_GUI_Callback(hObject, eventdata, handles)
function max_velocity_GUI_CreateFcn(hObject, eventdata, handles)
function algorithm_GUI_CreateFcn(hObject, eventdata, handles)
function radiobutton1_Callback(hObject, eventdata, handles)
if get(hObject,'value')==1
    set(handles.max_disps_GUI,'Visible','on')
else
    set(handles.max_disps_GUI,'Visible','off')
    set(handles.max_disps_GUI,'string','nan')
end



% --- Executes on selection change in algorithm_GUI.
function algorithm_GUI_Callback(hObject, eventdata, handles)
% hObject    handle to algorithm_GUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch  get(hObject,'value')
    case 1
        set(handles.uipanel1,'Visible','off')
        set(handles.radiobutton1,'Visible','on')
        if get(handles.radiobutton1,'value')==1
            set(handles.max_disps_GUI,'Visible','on')
        else
            set(handles.max_disps_GUI,'Visible','off')
            set(handles.max_disps_GUI,'string','nan')
        end
        
        set(handles.text5,'Visible','on')
        set(handles.memory_track_GUI,'Visible','on')
        
        set(handles.Velocity_text,'Visible','off')
        set(handles.max_velocity_GUI,'Visible','off')
        
    case 2
        set(handles.radiobutton1,'Visible','off')
        set(handles.max_disps_GUI,'Visible','off')
        
        set(handles.text5,'Visible','off')
        set(handles.memory_track_GUI,'Visible','off')
        set(handles.Velocity_text,'Visible','on')
        set(handles.uipanel1,'Visible','on')
        
        set(handles.max_velocity_GUI,'Visible','on')
    case 3
        set(handles.radiobutton1,'Visible','off')
        set(handles.max_disps_GUI,'Visible','off')
        
        set(handles.text5,'Visible','off')
        set(handles.memory_track_GUI,'Visible','off')
        set(handles.Velocity_text,'Visible','off')
        set(handles.uipanel1,'Visible','off')
        set(handles.min_disps_GUI,'Visible','off')
        set(handles.text4,'Visible','off')
        set(handles.max_velocity_GUI,'Visible','off')
end
% -------------------





% --- Executes during object creation, after setting all properties.
function Velocity_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Velocity_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function radiobutton1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function start_track_Callback(hObject, eventdata, handles)
% hObject    handle to start_track (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start_track as text
%        str2double(get(hObject,'String')) returns contents of start_track as a double


% --- Executes during object creation, after setting all properties.
function start_track_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_track (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function end_track_Callback(hObject, eventdata, handles)
% hObject    handle to end_track (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of end_track as text
%        str2double(get(hObject,'String')) returns contents of end_track as a double


% --- Executes during object creation, after setting all properties.
function end_track_CreateFcn(hObject, eventdata, handles)
% hObject    handle to end_track (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
