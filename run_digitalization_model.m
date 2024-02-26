function signal=run_digitalization_model(digitalization_model,folder,name,verbose)

data_record=fullfile(folder,name);

model=digitalization_model.model;
header=fileread(data_record);

image_file=get_image_file(header);
features=get_features(folder,image_file,header);

num_samples = get_num_samples(header);
num_signals = get_num_signals(header);

rng(model+mean2(features));
signal=2000*rand(num_samples,num_signals)-1000;

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