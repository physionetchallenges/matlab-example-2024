function train_models(input_directory,output_directory, verbose)

if verbose>=1
    disp('Finding Challenge data...')
end

% Find the recordings
records=dir(fullfile(input_directory,'**/*.hea'));
num_records = length(records);

if num_records<1
    error('No records were provided')
end

if verbose>=1
    disp('Training digitalization model...')
    disp('Extracting features and labels from the data...')
end

if ~isdir(output_directory)
    mkdir(output_directory)
end

fprintf('Loading data for %d records...\n', num_records)

digitalization_features=[];
classification_features=[];
classification_labels=cell(1);
count_cls=1;
kont=1;

for j=1:num_records

    if verbose>1
        fprintf('%d/%d \n',j,num_records)
    end

    header=fileread(fullfile(records(j).folder,records(j).name));
    image_file=get_image_file(header);

    % Extract features
    current_features=get_features(records(j).folder,image_file,header);
    digitalization_features(j,:)=current_features;

    % Get labels
    dx_tmp=get_labels(header);

    if ~isempty(dx_tmp)
        classification_labels{count_cls}=get_labels(header);
        classification_features(count_cls,:)=current_features;
        count_cls=count_cls+1;

        dx_tmp=strsplit(dx_tmp,',');
        for i=1:length(dx_tmp)
            unique_classes{kont}=strtrim(dx_tmp{i});
            kont=kont+1;
        end
    end
    
end

classes=sort(unique(unique_classes));

digitalization_model=mean2(digitalization_features);

label=one_hot_encoding(classification_labels,classes);
classification_model = mnrfit(classification_features,label,'model','hierarchical');

save_models(output_directory, digitalization_model, classification_model, classes)

function save_models(output_directory, digitalization_model, classification_model, classes)

filename = fullfile(output_directory,'classification_model.mat');
save(filename,'classification_model','classes','-v7.3');

filename = fullfile(output_directory,'digitalization_model.mat');
save(filename,'digitalization_model','-v7.3');

function image_file=get_image_file(header)

header=strsplit(header,'\n');
image_file=header(startsWith(header,'# Image'));
image_file=strsplit(image_file{1},':');
image_file=strtrim(image_file{2});

function dx=get_labels(header)

header=strsplit(header,'\n');
dx=header(startsWith(header,'# Labels'));
if ~isempty(dx)
    dx=strsplit(dx{1},':');
    dx=strtrim(dx{2});
else
    error('# Labels missing!')
end


function y=one_hot_encoding(dx,classes)

y=zeros(length(dx),length(classes));

for j=1:length(dx)

    y(j,ismember(classes,strtrim(strsplit(dx{j},','))))=1;

end
