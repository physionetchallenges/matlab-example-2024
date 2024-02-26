function features=get_features(folder,image_file,header)

features=zeros(1,2);

images=strtrim(strsplit(image_file,','));

for i=1:length(images)

    img=imread(fullfile(folder,images{i}));
    features(1)=mean2(img);
    features(2)=std2(img);

end

features=features/length(images);

function age=get_age(header)

header=strsplit(header,'\n');
age_tmp=header(startsWith(header,'#Age:'));
age_tmp=strsplit(age_tmp{1},':');
age=str2double(age_tmp{2});