%% Digital Signal Processing Project- Gender Identification and Classification

% Program:
%Feature Matrix
datamat=zeros(11,4); % data matrix to store features
for k=1:11
    filename=['s' num2str(k) '.wav'];
    [my2,fs] = audioread(filename);%Reading the files
    [fundamental_freq,zero_crossing,short_energy]=Charac_features(my2,fs);%Finding features
    %Storing features in the data matrix
    datamat(k,1)=k;
    datamat(k,2)=fundamental_freq;
    datamat(k,3)=zero_crossing;
    datamat(k,4)=short_energy;
end

%% Feature Extraction and Classification

fundamental_freq_level=135;%Manually fixing the value of the fundamental freq
zero_crossing_level=12;%Manually fixing the value of the zero crossing value
short_energy_level=0.5;%Manually fixing the value of the Short energy value

%Reading a file and getting the fundamental,zero crossing, short energy
%values
[my2,fs] = audioread('Male_1.wav');
figure;plot(my2);title('Test Signal');
xlabel('Index');ylabel('Amplitude');

[freq,zero_cross,short_ene]=Charac_features(my2,fs);

%Giving weights and finding a number for a particular obseravation
marks=0.25*(freq/fundamental_freq_level)+(zero_cross/zero_crossing_level)*0.35;
marks=marks+ (0.4*short_ene/short_energy_level)

%Based on the value of marks we are justifying the gender
if marks>1 
    ans='female'
else 
    ans='Male'
end  
