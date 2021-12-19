% Formating the spectravista file SIG
% It generate a csv output file with the reflectance vectors
% and necessary information (eg. gps, time)
% Abraham MEJIA-AGUILAR, 20.11.2018

clear;clc;
format long;
utmzone = '32 T';


% Get file path, number of files and base name
[filename pathname] = uigetfile({'*_resamp.sig'}, 'Select first resampled sig file');
string = strcat(pathname, '*_resamp.sig');
DirFiles = dir(string);
[NumFiles N] = size(DirFiles);


%FullHeaderPath = strcat(pathname,filename);
%FullHeaderPath = 'C:\Users\amejia\Desktop\temp_hr1024\HRPDA.061918.0042_resamp.sig';
%buffer = textread(FullHeaderPath,'%s','whitespace','\r');

i = 1;      %counter for file index
while i <= NumFiles
   BaseName = DirFiles(i).name;
   %Name of the file
   HeaderPath = strcat(pathname,BaseName);
   % reading the HR1024 file
   buffer = textread(HeaderPath,'%s','whitespace','\r');
   
   
   for ii=1:size(buffer)
       % change to string format the cell
       a = cell2mat(buffer(ii));
       % look for name of the file
       i_name = regexp(a, 'name= ');
       if i_name == true
           i_name = regexp(a, '.sig');
           string = a(7:i_name(1)-1);
           NameFile(i,:) = char(string);
       end
       % reference time
       i_time = regexp(a, 'time= ');
       if i_time == true
           i_time_value = regexp(a, ', ');
           limits_time = size(a);
           string = a(6:16);
           DateStr(i,:) = char(string); %date
           string = a(i_time_value-9:i_time_value-1);
           TimeRefStr(i,:)= char(string); %reference time
           string = a(limits_time(2)-8:limits_time(2));
           TimeTarStr(i,:)= char(string); %target time
       end
       
       % longitude
       i_lon = regexp(a, 'longitude= ');
       if i_lon == true
           i_lon_value = regexp(a, ', ');
           i_lon_end = regexp(a, 'E');
           tmp_val = isempty(i_lon_end);
           if tmp_val == 1
               a = 'longitude= 00000.0000E     , 00000.0000E     ';
               i_lon_end = [22,40];
           end
           [r,c] = size(i_lon_end);
           if (r > 1) | (c > 1)
               string = a(i_lon_value+2:i_lon_end(2)-1);
           else
               string = a(i_lon_value+2:i_lon_end-1);
           end
           Long_deg = string(1:3);
           Long_min = string(4:length(string));
           NumLongDeg = str2num(Long_deg);
           NumLongMin = str2num(Long_min);
           LonDMS=[NumLongDeg NumLongMin 0];
           LonDeg(i) = dms2deg(LonDMS);
       end
       %latitude
       i_lat = regexp(a, 'latitude= ');
       if i_lat == true
           i_lat_value = regexp(a, ', ');
           i_lat_end = regexp(a, 'N');
           tmp_val = isempty(i_lat_end);
           if tmp_val == 1
               a = 'latitude= 0000.0000N      , 0000.0000N      ';
               i_lat_end = [20,38];
           end
           [r,c] = size(i_lat_end);
           if (r > 1) | (c > 1)
               string = a(i_lat_value+2:i_lat_end(2)-1);
           else
               string = a(i_lat_value+2:i_lat_end-1);
           end
           
           Lat_deg = string(1:2);
           Lat_min = string(3:length(string));
           NumLatDeg = str2num(Lat_deg);
           NumLatMin = str2num(Lat_min);
           LatDMS=[NumLatDeg NumLatMin 0];
           LatDeg(i) = dms2deg(LatDMS);
       end
       
   end
   
   
   for ii=1:size(buffer)
       answer = strcmp(buffer(ii),'data= ');
       if answer == 1
           index(i) = ii;
           break;
       end
   end

   %%%%%%%
   count = 1;
   for ii=index+1:size(buffer)
       a = cell2mat(buffer(ii));
       % it creates the indexes for every column - character to number
       i_char = regexp(a, ' ');
       %wavelenght
       str=a(1:i_char(1)); wavelenght(i,count)=str2num(str);
       % reference information
       str=a(i_char(2):i_char(3)); reference(i,count)=str2num(str);
       % reflectance information
       str=a(i_char(4):i_char(5)); reflectance(i,count)=str2num(str);
       % reflectance express in percentage
       str=a(i_char(6):length(a)); percentage(i,count)=str2num(str);
       count = count+1;
   end
   
   %%%
   i = i+1;
end

% output file with File names, times and coordinates
NameOutputFile = strcat(pathname,'SVCHR_files','.csv');
fileOutPut = fopen(NameOutputFile,'w');
fprintf(fileOutPut,'Filename,Date,ReferenceTime,TargetTime,Latitude,Longitude,X_utm,Y_utm\n');
for i=1:NumFiles
    [X_utm,Y_utm] = deg2utm(LatDeg(i), LonDeg(i));
    fprintf(fileOutPut,'%s,%s,%s,%s,%f,%f,%f,%f\n',NameFile(i,:),...
    DateStr(i,:),TimeRefStr(i,:),TimeTarStr(i,:),LatDeg(i),LonDeg(i),X_utm,Y_utm);
    %d,%f,%f,%f\r\n', Point(a), X(a), Y(a), Ele(a));
end

% output file with wavelenght and reflectances
NameOutputFile = strcat(pathname,'SVCHR_reflectance','.csv');
fileOutPut = fopen(NameOutputFile,'w');
fprintf(fileOutPut,'wavelength,');
for ii=1:NumFiles
    fprintf(fileOutPut,'%s,',NameFile(ii,:));
    if ii == NumFiles
        fprintf(fileOutPut,'\n');
    end
end

for i=1:count-1
    MainStr = '';
    % it considers that all files have same wavelengths
    str1 = num2str(wavelenght(1,i)); % version 2021.05.23 - insert
    fprintf(fileOutPut,str1);    % version 2021.05.23 - insert
    for ii=1:NumFiles
        %str1 = num2str(wavelenght(ii,i));  % version 2021.05.23 - remove
        str2 = num2str(reflectance(ii,i));
        %MainStr = strcat(',',str1,',',str2);   % old format two columns
        MainStr = strcat(',',str2);
        %fprintf(fileOutPut,'%f,%f,%f,%f,%f\n',NameFile(i,:),LatDeg(i),...
        %LonDeg(i),X_utm,Y_utm);
        fprintf(fileOutPut,MainStr);
    end
    fprintf(fileOutPut,'\n');
end

% output file with wavelenght and reflectances
NameOutputFile2 = strcat(pathname,'SVCHR_percentage','.csv');
fileOutPut2 = fopen(NameOutputFile2,'w');

fprintf(fileOutPut2,'wavelength,');
for ii=1:NumFiles
    fprintf(fileOutPut2,'%s,',NameFile(ii,:));
    if ii == NumFiles
        fprintf(fileOutPut2,'\n');
    end
end

for i=1:count-1
    MainStr = '';
    str1 = num2str(wavelenght(ii,i)); % version 2021.05.23 - insert
    fprintf(fileOutPut2,str1);        % version 2021.05.23 - insert
    for ii=1:NumFiles
        %str1 = num2str(wavelenght(ii,i)); % version 2021.05.23 - remove
        str2 = num2str(percentage(ii,i));
        %MainStr = strcat(',',str1,',',str2);   % old format two columns
        MainStr = strcat(',',str2);
        %fprintf(fileOutPut,'%f,%f,%f,%f,%f\n',NameFile(i,:),LatDeg(i),...
        %LonDeg(i),X_utm,Y_utm);
        fprintf(fileOutPut2,MainStr);
    end
    fprintf(fileOutPut2,'\n');
end

fclose('all');
