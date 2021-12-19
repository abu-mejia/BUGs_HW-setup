% Script for generate different CSV file with
% Latitude Longitude and elevation

% it is necessary to create three different columns for either Latitude or
% Longitude from the original CSV file produce by LEICA software

clear; clc;
format long;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Layer centroid tree coordinate points 
[filenameLeica pathnameLeica] = uigetfile({'*.xlsx'}, 'Select xls LEICA data');
file = strcat(pathnameLeica,filenameLeica);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ground control points coordinate points 
% File that contains the GCP positions
BaseName = strcat(file(1:length(file)-5),'_');
NameGCPFile = strcat(BaseName,'results','.csv');
fileID = fopen(NameGCPFile,'w');    



%file = 'GCP_MarcoMulas.xlsx';    % Name of the file stored on USERS\MATLAB folder
Data = xlsread(file);
LastRow = size(Data, 1);

% Get column for Latitude column "Degree Minute Second"
[numLat, numeric, Raw] = xlsread(file, strcat('B1:D',num2str(LastRow+1)));
% Get column for Longitude "Degree Minutte Second"
[numLon, numeric, Raw] = xlsread(file, strcat('E1:G',num2str(LastRow+1)));
% Get column for Ellipsoidal Height 
[numEllipHgt, numeric, Raw] = xlsread(file, strcat('H1:H',num2str(LastRow+1)));

i = 1;

for a=1:LastRow
    LatDMS=[numLat(a,1) numLat(a,2) numLat(a,3)];
    LonDMS=[numLon(a,1) numLon(a,2) numLon(a,3)];
    LatDeg = dms2deg(LatDMS);
    LonDeg = dms2deg(LonDMS);
    [x,y,utmzone] = deg2utm(LatDeg,LonDeg);
    X_coor(a) = x;
    Y_coor(a) = y;
end


% Latitude Longitude Height(GPS)
%fileID = fopen('C:\Users\amejia\Desktop\Temp\GCP_XY_Mulas.csv','w');
fileID = fopen('C:\Users\amejia\Desktop\20210907_GPS.csv','w');
for a=1:LastRow
    fprintf(fileID,'%f, %f, %f\r\n',X_coor(a), Y_coor(a),numEllipHgt(a));
end
fclose(fileID);
fclose('all');