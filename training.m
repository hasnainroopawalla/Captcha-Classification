% Assumes varables:
% train_data, validation_data - numerical 3D arrays of size [N x r x c] [1000 x 28 x 28] [10 x 325 x 435]
% train_labels, validation_labels - categorical vectors size N [10 x 3]
% Uses the user defined function 'FeatureExtraction' to compute features for each sample

close all;
clear all;

data = importdata('Train/labels.txt');
img_nrs = data(:,1);
true_labels = data(:,(2:4));

num_train = 1100;
num_validation = 100;
train_labels = {};
validation_labels = {};

train_patterns = [];
validation_patterns = [];

t = tic;
fprintf('Extracting Training Features...\n');

% TRAINING
for i=1:num_train
    if i < 10
        a = FeatureExtraction(imread(strcat(strcat('Train/captcha_000',num2str(i)),'.png'))); % Extract features
    elseif i >= 10 && i < 100
        a = FeatureExtraction(imread(strcat(strcat('Train/captcha_00',num2str(i)),'.png'))); % Extract features
    elseif i >=100 && i < 1000
        a = FeatureExtraction(imread(strcat(strcat('Train/captcha_0',num2str(i)),'.png'))); % Extract features
    elseif i >= 1000
        a = FeatureExtraction(imread(strcat(strcat('Train/captcha_',num2str(i)),'.png'))); % Extract features
    end
    
    if size(a) == 0
        i
    else
        for j=1:3
            train_patterns(end+1,:) = a(j,:,:);
            train_labels{end+1} = num2str(true_labels(i,j));
        end
    end
end
toc(t)

t = tic;
fprintf('Extracting Validation Features...\n');

% VALIDATION
for i=1:num_validation
    % I=shiftdim(train_data(i,:,:),1); % Get image i from the training data
    if i+num_train < 10
        a = FeatureExtraction(imread(strcat(strcat('Train/captcha_000',num2str(i+num_train)),'.png'))); % Extract features
    elseif i+num_train >= 10 && i+num_train < 100
        a = FeatureExtraction(imread(strcat(strcat('Train/captcha_00',num2str(i+num_train)),'.png'))); % Extract features
    elseif i+num_train >=100 && i+num_train < 1000
        a = FeatureExtraction(imread(strcat(strcat('Train/captcha_0',num2str(i+num_train)),'.png'))); % Extract features
    elseif i+num_train >= 1000
        a = FeatureExtraction(imread(strcat(strcat('Train/captcha_',num2str(i+num_train)),'.png'))); % Extract features
    end
    
    if size(a) == 0
        i
    else
        for j=1:3
            validation_patterns(end+1,:) = a(j,:,:);
            validation_labels{end+1} = num2str(true_labels(i+num_train,j));
        end
    end
end
toc(t)

validation_labels = transpose(validation_labels);
train_labels = transpose(train_labels);

fprintf('Building model...\n');

% Mdl = fitcensemble(double(train_patterns),train_labels);

% SVM %
% t =  tic;
% tr = templateSVM('KernelFunction','linear');
% Mdl = fitcecoc(double(train_patterns),train_labels, 'Learners',tr); % ECOC model for Multiclass problems
% toc(t)
% SVM %

% ADA BOOST %
tr = templateTree('MaxNumSplits',100);
Mdl = fitcensemble(double(train_patterns),train_labels, 'Learners',tr); 
% ADA BOOST %

% KNN %
% k=3;
% Mdl = fitcknn(double(train_patterns),train_labels, 'NumNeighbors',k, 'BreakTies','nearest');
% KNN %

save Mdl

fprintf('\nResubstitution error: %5.2f%%\n\n',100*resubLoss(Mdl));

if isa(Mdl,'classreg.learning.classif.ClassificationEnsemble')
	view(Mdl.Trained{1},'Mode','graph');
end

fprintf('Predicting validation set...\n');
t=tic;
validation_pred = predict(Mdl,validation_patterns);
toc(t);

accuracy = mean(cell2mat(validation_pred) == cell2mat(validation_labels));
fprintf('Validation accuracy: %5.2f%%\n',accuracy*100);

f=figure(2);
if (f.Position(3)<800)
	set(f,'Position',get(f,'Position').*[1,1,1.5,1.5]); %Enlarge figure
end
confusionchart(validation_labels, validation_pred, 'ColumnSummary','column-normalized', 'RowSummary','row-normalized');
title(sprintf('Validation accuracy: %5.2f%%\n',accuracy*100));

% 54.2 with circ, convarea, area
% 58.5 with circ, convarea, area, centroid
% 62.08 with circ, area, orientation, centroid
% 96.25 with circ, area, orientation, centroid, (ADA BOOST 100)
% 97.66 with circ, area, orientation, centroid, solidity (ADA BOOST 100)