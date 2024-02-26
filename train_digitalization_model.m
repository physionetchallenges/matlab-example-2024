function model = train_digitalization_model(input_directory,output_directory,verbose)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose: Train and obtain digitalization model
% Inputs:
% 1. input_directory
% 2. output_directory
%
% Outputs:
% 1. model: trained model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if verbose>=1
    disp('Training digitalization model...')
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

fprintf('Loading data for %d records...\n', num_records)

% Extract features

features=[];

for j=1:num_records

    if verbose>1
        fprintf('%d/%d \n',j,num_records)
    end

    header=fileread(fullfile(records(j).folder,records(j).name));
    image_file=get_image_file(header);

    % Extract features
    current_features=get_features(records(j).folder,image_file,header);
    features(j,:)=current_features;
    
end

%% train model

disp('Training the model...')

% This overly simple model uses the mean of these overly simple features as a seed for a random number generator.
model=mean2(features);

save_digitalization_model(model,output_directory);

disp('Done.')

end

function save_digitalization_model(model,output_directory) %save_model
% Save results.
filename = fullfile(output_directory,'digitalization_model.mat');
save(filename,'model','-v7.3');

disp('Done.')
end

function image_file=get_image_file(header)

header=strsplit(header,'\n');
image_file=header(startsWith(header,'#Image'));
image_file=strsplit(image_file{1},':');
image_file=strtrim(image_file{2});

end