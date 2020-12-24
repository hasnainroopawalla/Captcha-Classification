tic
data = importdata('Train/labels.txt');
img_nrs = data(:,1);
true_labels = data(:,(2:4));

my_labels = zeros(size(true_labels));
N = size(img_nrs);

% IGNORE
% N = 300;
% my_labels = zeros(N,3);
% true_labels = true_labels(1:N,:);
% IGNORE

for n = 1:N
    k = img_nrs(n);
    sprintf('Train/captcha_%04d.png', k)
    t = tic;
    im = imread(sprintf('Train/captcha_%04d.png', k));     
    my_labels(k,:) = myclassifier(im);
    toc(t)
   
end

fprintf('\n\nAccuracy: \n');
fprintf('%f\n\n',mean(sum(abs(true_labels - my_labels),2)==0));
toc

