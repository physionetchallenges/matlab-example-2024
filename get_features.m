function features=get_features(image_file,header)

img=imread(image_file);

features(1)=mean2(img);
features(2)=std2(img);

function age=get_age(header)

header=strsplit(header,'\n');
age_tmp=header(startsWith(header,'#Age:'));
age_tmp=strsplit(age_tmp{1},':');
age=str2double(age_tmp{2});