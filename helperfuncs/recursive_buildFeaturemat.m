function [featmat,expnames] = recursive_buildFeaturemat(inpath,featfilename,recursiveind)
%This function takes a file output structure, finds the features.csv files
%for each experiment, splits the features and compiles the desired features
%into a single feature matrix
%
%INPUTS:
%inpath - string containing the path to your master folder that
%contains the feature files.
%featfilename - string specifying what the name of the file we are looking
%for is. Here we expect a .csv file as outputed by the feature extraction.
%The default is 'features.csv'
%recursiveind - this is a simple housekeeping argument and can be ignored. 
%
%OUTPUTS:
%featmat - a single feature matrix with an index list per-experiment in the
%first column
%
%Written by: Devin P Sullivan January 13, 2016

if nargin<2
    featfilename = 'features.csv';
end

if nargin<3
    recursiveind = 1;
end

listdirs = ml_ls(inpath);

[~,~,filetype] = fileparts(featfilename);

%first check if any of the files found are the images we are looking for
featfilelist = listdirs(~cellfun(@isempty,strfind(listdirs,featfilename)));

% filelist = filelist(~cellfun(@isempty,strfind(listdirs,submitstruct.extensions{2})));
featmat = [];
expnames = {};
for i = 1:length(featfilelist)
      currpath = [inpath,filesep,featfilelist{i}];
      currinfolders = strsplit(currpath,filesep);
      currimgname = currinfolders(end-1);
%       imgfilebase = currpath(1:end-length(submitstruct.extensions{1}));
      currfeats = csvread(currpath);
      featmat = [featmat;currfeats];
      expnames = [expnames;repmat(currimgname,size(featmat,1),1)];
end


%eliminate non-dirs
listdirs(~cellfun(@isdir,strcat([inpath,filesep],listdirs))) = [];
numexperiments = length(listdirs)



%recurse for each directory
newrecursiveind = recursiveind+1;
for j = 1:numexperiments
    currpath = [inpath,filesep,listdirs{j}]
   
    [featmattmp,expnamestmp] = recursive_buildFeaturemat(currpath,featfilename,newrecursiveind);
    featmat = [featmat;featmattmp];
    expnames = [expnames;expnamestmp];
end

