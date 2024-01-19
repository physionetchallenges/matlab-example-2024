
function run_model(input_directory, model_directory, output_directory, allow_failures, verbose)

% Do *not* edit this script. Changes will be discarded so that we can process the models consistently.

% This file contains functions for running models for the 2024 Challenge. You can run it as follows:
%
%   run_model(model, data, outputs)
%
% where 'model' is a folder containing the your trained model, 'data' is a folder containing the Challenge data, and 'outputs' is a
% folder for saving your model's outputs.

if nargin==3
    allow_failures=1;
    verbose=2;
end

% Load the models
digitalization_model=load_digitalization_model(model_directory); % Teams: Implement this function!!
dx_model=load_dx_model(model_directory); % Teams: Implement this function!!

% Find challenge data
if verbose>=1
    fprintf('Finding Challenge data... \n')
end

records=dir(fullfile(input_directory,'**/*.hea'));
num_records = length(records);

if verbose>=1
    fprintf('Loading data for %d records...\n', num_records)
end

% Create the output directory if it doesn't exist
if ~exist(output_directory, 'dir')
    mkdir(output_directory)
end

% Run the model
if verbose>=1
    disp('Running the model on the Challenge data...')
end

for j=1:num_records

    if verbose>=2
        fprintf('%d/%d \n',j,num_records);
    end

    % Run the digitalization model
    try
        signal=run_digitalization_model(digitalization_model,records(j).folder,records(j).name,verbose);
    catch
        if allow_failures==1
            disp('Digitalizarion failed')
            signal=NaN;
        else
            error();
        end
    end

    % Run the dx model
    try
        dx=run_dx_model(dx_model,records(j).folder, records(j).name, signal, verbose);
    catch
        if allow_failures==1
            disp('Classification failed')
            signal=NaN;
        else
            error();
        end
    end
    
    % Create a folder for the Challenge outputs if it does not already
    % exist
    output_directory_tmp=fullfile(output_directory,records(j).folder(end-5:end));
    if ~exist(output_directory_tmp, 'dir')
        mkdir(output_directory_tmp)
    end

    output_record=fullfile(output_directory_tmp,records(j).name);

    header=fileread(fullfile(records(j).folder,records(j).name));
    writematrix(header,output_record,'FileType','text','QuoteStrings',0);

    if ~isempty(signal)

        num_signals=get_num_signals(header);
        save_signal(output_record,signal,num_signals)

    end

    if ~isempty(dx)
        save_dx(output_record,dx)
    end

end

disp('Done.')
end

function save_signal(record,signal,num_signals)

header=fileread(record);
[path,record]=fileparts(record);

sampling_frequency = get_fs(header);
signal_formats = get_signal_formats(header,num_signals);
adc_gains = get_adc_gains(header,num_signals);
baselines = get_baselines(header,num_signals);
signal_units = get_signal_units(header,num_signals);
signal_names = get_signal_names(header,num_signals);

tm=1:size(signal,1);tm=tm';
wrsamp(tm,signal,record,sampling_frequency,adc_gains);
movefile([record '.dat'],fullfile(path,[record '.dat']));
delete([record '.hea']);

end

function num_signals=get_num_signals(header)

header=strsplit(header,'\n');
header_tmp=header{1};
header_tmp=strsplit(header_tmp,' ');
num_signals=str2double(header_tmp{2});

end

function fs=get_fs(header)

header=strsplit(header,'\n');
header_tmp=header{1};
header_tmp=strsplit(header_tmp,' ');
fs=str2double(header_tmp{3});


end

function values=get_signal_formats(header,num_signals)

header=strsplit(header,'\n');
values=zeros(num_signals,1);

for j=2:num_signals+1

    l_tmp=strsplit(header{j},' ');
    l_tmp=l_tmp{2};
    if contains(l_tmp,'x')
        l_tmp=strsplit(l_tmp,'x');
        l_tmp=l_tmp{1};
    end
    if contains(l_tmp,':')
        l_tmp=strsplit(l_tmp,':');
        l_tmp=l_tmp{1};
    end
    if contains(l_tmp,'+')
        l_tmp=strsplit(l_tmp,'+');
        l_tmp=l_tmp{1};
    end
    values(j-1)=str2double(l_tmp);
end

end

function values=get_adc_gains(header,num_signals)

header=strsplit(header,'\n');
values=zeros(num_signals,1);

for j=2:num_signals+1

    l_tmp=strsplit(header{j},' ');
    l_tmp=l_tmp{3};
    if contains(l_tmp,'/')
        l_tmp=strsplit(l_tmp,'/');
        l_tmp=l_tmp{1};
    end
    if contains(l_tmp,'(') & contains(l_tmp,')')
        l_tmp=strsplit(l_tmp,'(');
        l_tmp=l_tmp{1};
    end
    values(j-1)=str2double(l_tmp);
end

end

function values=get_baselines(header,num_signals)

header=strsplit(header,'\n');
values=zeros(num_signals,1);

for j=2:num_signals+1

    l_tmp=strsplit(header{j},' ');
    l_tmp=l_tmp{3};
    if contains(l_tmp,'/')
        l_tmp=strsplit(l_tmp,'/');
        l_tmp=l_tmp{1};
    end
    if contains(l_tmp,'(') & contains(l_tmp,')')
        l_tmp=extractBetween(l_tmp,'(',')');
        l_tmp=l_tmp{1};
    end
    values(j-1)=str2double(l_tmp);
end

end

function values=get_signal_units(header,num_signals)

header=strsplit(header,'\n');
values=[];

for j=2:num_signals+1

    l_tmp=strsplit(header{j},' ');
    l_tmp=l_tmp{3};
    if contains(l_tmp,'/')
        l_tmp=strsplit(l_tmp,'/');
        l_tmp=l_tmp{2};
    else
        l_tmp='mV';
    end
    values{j-1}=l_tmp;
end

end

function values=get_signal_names(header,num_signals)

header=strsplit(header,'\n');
values=[];

for j=2:num_signals+1

    l_tmp=strsplit(header{j},' ');
    l_tmp=l_tmp{end};
    values{j-1}=l_tmp;
end

end

function save_dx(output_record,dx)

header=fileread(output_record);
header=strsplit(header,'\n');
header{end+1}=sprintf('#Dx: %s',dx);
header(cellfun(@isempty,header))=[];
header=strjoin(header,'\n');
writematrix(header,output_record,'FileType','text','QuoteStrings',0);

end