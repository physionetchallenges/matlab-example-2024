function label=run_dx_model(dx_model,folder,name,signal, verbose)

data_record=fullfile(folder,name);

model=dx_model.model;
classes=dx_model.classes;
header=fileread(data_record);

image_file=get_image_file(header);
features=get_features(folder,image_file,header);

probabilities=mnrval(model,features);

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
image_file=header(startsWith(header,'#Image'));
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