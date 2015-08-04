function [cell_feat, exit_code] = process_63x(in_folder,out_folder,resolution,color,extensions)
%
%
%Written by: Elton Date-unknown
%
%Edited by: (dd,mm,yy)
%Devin P Sullivan 04,08,2015 - added 'extensions' input

addpath(genpath('./hpa_lib'),'-begin');
addpath(genpath('./adaptive_watersheed_seg'),'-begin');

exit_code   = 0;

%DPS 04,08,2015 - added 'extensions' field so that we can handle multiple
%file-naming conventions. This should not break the former pipeline
if nargin<5 || isempty(extensions)
    fprintf(['You have not passed an "extensions" variable or full list of colors. We will assume you are using the HPA production channels.\n ',...
        'please make sure your files are names accordingly:\n',...
        '1."*_blue.tif" - nucleus \n 2."*_green.tif" - protein of interest \n',...
        '3."*_red.tif" - microtubules \n lastly, the "color" variable is used as the segmentation channel usually "yellow" corresponding to er \n'])
    extention_dapi  = '_blue.tif';
    extention_ab    = '_green.tif';
    extention_mtub  = '_red.tif';
    %For historical reasons 'color' is separate and we are trying to make
    %the script such that it breaks nothing in the current pipeline 
    extention_er    = strcat('_', color, '.tif');
elseif iscell(color)
    %if someone has passed a cell array of color, process it
    fprintf(['You have passed a cell array for the "color" variable. Make sure it is in the correct order',...
        'It will be parsed as follows:\n 1.nucleus \n 2.protein of interest \n 3.microtubules \n 4.segmentation channel (usually er or tubules)\n'])
    extention_dapi  = color{1};
    extention_ab    = color{2};
    extention_mtub  = color{3};
    extention_er    = color{4};
else
    fprintf(['You have passed a cell array for the "color" variable. Make sure it is in the correct order',...
        'It will be parsed as follows:\n 1.nucleus \n 2.protein of interest \n 3.microtubules \n 4.segmentation channel (usually er or tubules)\n'])
    extention_dapi  = extensions{1};
    extention_ab    = extensions{2};
    extention_mtub  = extensions{3};
    %For historical reasons 'color' is separate and we are trying to make
    %the script such that it breaks nothing in the current pipeline 
    extention_er    = strcat('_', color, '.tif');
end



if(resolution==63)
	resolution = 1;
else
	resolution = 0;
end

step1   = true;
step2   = true;
step3   = false;%true;

warning('off', 'MATLAB:MKDIR:DirectoryExists');
warning('off', 'Images:imfeature:obsoleteFunction');

filename = out_folder,'/feature_extraction_HPA';
mkdir(filename);

% extention_dapi  = '_blue.tif';
% extention_ab    = '_green.tif';
% extention_mtub  = '_red.tif';
% extention_er    = strcat('_', color, '.tif');

list_ab     = rdir_list(char([in_folder,'/*',extention_ab]));
list_dapi   = rdir_list(char([in_folder,'/*',extention_dapi]));
list_mtub   = rdir_list(char([in_folder,'/*',extention_mtub]));
list_er     = rdir_list(char([in_folder,'/*',extention_er]));

%list_ab     = rdir_list(char([in_folder,'/*','/*',extention_ab]));
%list_dapi   = rdir_list(char([in_folder,'/*','/*',extention_dapi]));
%list_mtub   = rdir_list(char([in_folder,'/*','/*',extention_mtub]));
%list_er     = rdir_list(char([in_folder,'/*','/*',extention_er]));


%% Init

if(step1)
    
    image_path = in_folder;
    dirlist    = dir(image_path);
    %dirlist
    start_time = tic;
    
    n = getenv('PBS_JOBID');
    n = regexprep(n, '[\r\n]', '');
    date_text = datestr(now(), 'yyyymmddHHMMSSFFF')
    diary([filename '/' 'log' date_text ...
        '_' n '.txt']);
    
    padnumb = 2; % Offset for directory brousing and data analysis
    
    label_subdirectories = cell(1,1);
    dirlist.name
    currind = 1;
    %breaking = breakme 
    for i=1:length(dirlist)
%         currdir = dirlist(i+padnumb).name;
        currdir = dirlist(i).name;
        if any(strcmpi(currdir,{'.','..','.DS_Store'}))
            continue
        end
        label_subdirectories{currind} = currdir;
        currind = currind+1;
    end
    
    label_names = label_subdirectories;
    
    number_labels = length(label_subdirectories);
    label_features = cell(1, number_labels);
    
    processed_path = out_folder,'/featextraction_rawdata/';
    mkdir(processed_path);
        
    feature_names = [];
    
end


%% Remaining script to run image-segmentation and feature extraction

if(step2)
    
    base_naming_convention.protein_channel  = extention_ab;
    base_naming_convention.nuclear_channel  = extention_dapi;
    base_naming_convention.tubulin_channel  = extention_mtub;
    base_naming_convention.er_channel       = extention_er;
    base_naming_convention.blank_channels = {};
    
    base_naming_convention.segmentation_suffix = base_naming_convention.protein_channel;
        
    index  = 1;
   
    label_subdirectories 
    image_subdirectory      = [image_path, filesep, (label_subdirectories{index}), filesep]
    
    %DPS - 28,07,2015  Adding support for direct parent directories rather
    %than directories of directories 
    if ~isdir(image_subdirectory)
        image_subdirectory = [image_path, filesep];
    end
    image_path
    %storage_subdirectory    = [processed_path, (label_subdirectories{index}), filesep];
    storage_subdirectory    = processed_path;
    %label_subdirectories{index}
    %image_subdirectory
    %storage_subdirectory
    disp('In 63x code')
    %try
        [label_features{index}, feature_names, feature_computation_time, cell_seed, nucleus_seed] = get_concatenated_region_features(image_subdirectory, storage_subdirectory, base_naming_convention, label_names{index}, true, false, resolution);
        regions_results     =   cell2mat(label_features);
        
        % read cell (x,y) centers and bounding box values
        
        dir_png         = dir([storage_subdirectory,'/*.png']);
        
	%%%DPS 2015/07/09 - I don't understand how this ever worked without a for loop unless they were running on one image at a time. I am changing now
	position_stats = zeros(size(regions_results,1),7);
    %DPS 30,07,2015 - Adding variable to track variable names; 7 position
    %stats are calculated
    pos_stats_names = cell(1,7);
    %area
    pos_stats_names{1} = 'position_stats:Area';
    %center of mass location
    pos_stats_names{2} = 'position_stats:Centroid_x';
    pos_stats_names{3} = 'position_stats:Centroid_y';
    %bounding box
    pos_stats_names{4} = 'position_stats:BoundingBox_ulx';
    pos_stats_names{5} = 'position_stats:BoundingBox_uly';
    pos_stats_names{6} = 'position_stats:BoundingBox_wx';
    pos_stats_names{7} = 'position_stats:BoundingBox_wy';
	currstart = 1;
	for i = 1:length(dir_png)
	%bw_seg          = imread([storage_subdirectory,'/',char(dir_png(1).name)]);
        bw_seg = imread([storage_subdirectory,'/',char(dir_png(i).name)]);
	nucstats_seg    = regionprops(bwlabel(bw_seg,4),'Centroid','BoundingBox','Area');
        
        if(length(nucstats_seg)>0)
            
            %num_cells = size(regions_results);
            %num_cells = num_cells(1,1);
            num_cells = length(nucstats_seg);
	    %position_stats(1:num_cells,1) = [nucstats_seg(1:num_cells).Area]';
	    position_stats(currstart:currstart+num_cells-1,1)      =   [nucstats_seg.Area]';
            position_stats(currstart:currstart+num_cells-1,2:3)    =   reshape([nucstats_seg(1:num_cells).Centroid],2,num_cells)';
            position_stats(currstart:currstart+num_cells-1,4:7)    =   reshape([nucstats_seg(1:num_cells).BoundingBox],4,num_cells)';
            
            time_so_far = toc(start_time);
            currstart = currstart+num_cells;
            %size(regions_results)
            %size(position_stats)
	
	else
	    warning(['Image ', storage_subdirectory,'/',char(dir_png(i).name),' seems to be blank!'])
	end
	end

	if sum(position_stats(:))>0
            cell_feat  = [position_stats regions_results];
            %DPS 30,07,2015 - added feature name save and concatenation of
            %position stats to feature names 
            feature_names = [pos_stats_names feature_names];
            save([out_folder,filesep,'feature_names.mat'],'feature_names');
            csvwrite([out_folder,'/','features.csv'], [position_stats regions_results]);
            
        else
	    breaking = breakme
            cell_feat = 0;
            exit_code = 1;
            disp('Segmentation error occuring during feature extraction 63x/40x');
            exit(exit_code);
        end
        
    %catch
        %cell_feat = 0;
        %exit_code = 1;
        %disp('Segmentation error occuring during feature extraction 63x/40x');
        %exit(exit_code);
    %end
end


%% create segmentation masks 

if(step3)
   %%%DPS 2015-07-09  Not sure where I is supposed to be coming from without a for loop!  
    % Read images
    
    im_dapi     =   imread(list_dapi(i).name);
    im_ab       =   imread(list_ab(i).name);
    im_mtub     =   imread(list_mtub(i).name);
    im_er       =   imread(list_er(i).name);
    
    % Segment the nucleus and cell extent mask
    
    cyto_seed   =   cell_seed & (~(nucleus_seed>0));
    
    % create cell perimeter
    
    perim_thick = 5 ; % defines number of pixels thickness of the perimeter
    bw2         = bwmorph(cell_seed,'erode',perim_thick);
    bw3         = bwmorph(cell_seed,'remove');
    plasmaMem   = bwmorph(bw3,'dilate',perim_thick-2);%imshow((plasmaMem));
    
    % save output images in the output directory
    
    alpha_ch       = plasmaMem*0;
    merge_mask     = alpha_ch;
    max_alpha      = 5000;
    
    alpha_ch(cell_seed>0)                       = 3;
    alpha_ch(cyto_seed>0)                       = 2;
    alpha_ch(nucleus_seed>0&cell_seed>0)        = 1;
    alpha_ch(plasmaMem)                         = 4;
         
    imwrite(double(merge_mask),[out_folder,'/segmentation.png'],'Alpha',alpha_ch/255);
    
    % merge the output from the image set with other ABs image set data
    % previously analysed (if multiple ABs are included or if analysis is 
    % run at the plate level)  
end

% exit(exit_code);
