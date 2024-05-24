function [signal,label]=run_models(data_record, digitalization_model, classification_model, verbose)

digitalization_model=digitalization_model.digitalization_model;
classes=classification_model.classes;
classification_model=classification_model.classification_model;
header=fileread(data_record);

% Digitalization model
image_file=get_image_file(header);
[folder,~,~]=fileparts(data_record);
features=get_features(folder,image_file,header);

num_samples = get_num_samples(header);
num_signals = get_num_signals(header);

rng(digitalization_model+mean2(features));
signal=2000*rand(num_samples,num_signals)-1000;

% Classification model
probabilities=mnrval(classification_model,features);

if sum(probabilities>0.3)>0
    label=classes(probabilities>0.3);
    if length(label)>1
        label=strjoin(label,', ');
    else
        label=label{1};
    end
else
    [~,idx]=max(probabilities);
    label=classes(idx);
    label=label{1};
end

end

function image_file=get_image_file(header)

header=strsplit(header,'\n');
image_file=header(startsWith(header,'# Image'));
image_file=strsplit(image_file{1},':');
image_file=strtrim(image_file{2});

end

function num_samples = get_num_samples(header)

header=strsplit(header,'\n');
header_tmp=header{1};
header_tmp=strsplit(header_tmp,' ');
num_samples=str2double(header_tmp{4});


end

function num_signals = get_num_signals(header)

header=strsplit(header,'\n');
header_tmp=header{1};
header_tmp=strsplit(header_tmp,' ');
num_signals=str2double(header_tmp{2});

end