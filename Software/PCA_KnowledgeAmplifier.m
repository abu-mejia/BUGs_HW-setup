clc
clear all
close all
warning off
x = readtable('C:\Users\AMejia\Desktop\Video_data.csv');
x = x(x.Hour >= 6 & x.Hour <= 18, :);
data = x(:,5:end-1); %dewpoint to windspeed column to predict Solar radiation

%y = x(:,end);
data.DewPoint = (data.DewPoint-mean(data.DewPoint))/std(data.DewPoint);
data.Temperature = (data.Temperature-mean(data.Temperature))/std(data.Temperature);
data.RelativeHumidity= (data.RelativeHumidity-mean(data.RelativeHumidity))/std(data.RelativeHumidity);
data.WindDirection= (data.WindDirection-mean(data.WindDirection))/std(data.WindDirection);
data.WindSpeed= (data.WindSpeed-mean(data.WindSpeed))/std(data.WindSpeed);
Data = table2array(data);
[idx c sumd] = kmeans(Data,6);
[coeff, score, latent, tsquared, explained, mu] = pca(Data);
pc1 = score(:,1)
pc2 = score(:,2)
figure;
gscatter(pc1,pc2,idx);