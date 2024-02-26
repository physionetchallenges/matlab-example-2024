function model = train_dx_model(input_directory,output_directory,verbose)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose: Train classifiers and obtain the models
% Inputs:
% 1. input_directory
% 2. output_directory
%
% Outputs:
% 1. model: trained model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if verbose>=1
    disp('Training dx classification model...')
    disp('Finding Challenge data...')
end

% Find the recordings
records=dir(fullfile(input_directory,'**/*.hea'));
num_records = length(records);

if num_records<1
    error('No records were provided')
end

% Create a folder for the model if it doesn't exist
if ~isdir(output_directory)
    mkdir(output_directory)
end

fprintf('Extracting features and labels for %d records...\n', num_records)

% Extract features

features=[];
dx=cell(1);
kont=1;

for j=1:num_records

    if verbose>1
        fprintf('%d/%d \n',j,num_records)
    end

    header=fileread(fullfile(records(j).folder,records(j).name));
    image_file=get_image_file(header);

    % Extract features
    current_features=get_features(records(j).folder,image_file,header);

    features(j,:)=current_features;

    % Get labels
    dx{j}=get_labels(header);

    dx_tmp=strsplit(dx{j},',');
    for i=1:length(dx_tmp)
        unique_classes{kont}=strtrim(dx_tmp{i});
        kont=kont+1;
    end
    
end

classes=sort(unique(unique_classes));

%% train model

disp('Training the model...')

label=one_hot_encoding(dx,classes);

% This overly simple model uses the mean of these overly simple features as a seed for a random number generator.
model = mnrfit(features,label,'model','hierarchical');

save_dx_model(model,classes,output_directory);

disp('Done.')

end

function save_dx_model(model,classes,output_directory) %save_model
% Save results.
filename = fullfile(output_directory,'dx_model.mat');
save(filename,'model','classes','-v7.3');

disp('Done.')
end

function image_file=get_image_file(header)

header=strsplit(header,'\n');
image_file=header(startsWith(header,'#Image'));
image_file=strsplit(image_file{1},':');
image_file=strtrim(image_file{2});

end

function dx=get_labels(header)

header=strsplit(header,'\n');
dx=header(startsWith(header,'#Dx'));
dx=strsplit(dx{1},':');
dx=strtrim(dx{2});

end

function y=one_hot_encoding(dx,classes)

y=zeros(length(dx),length(classes));

for j=1:length(dx)

    y(j,ismember(classes,strtrim(strsplit(dx{j},','))))=1;

end

end