clc;clear;
close all;

%% init
% Add caffe/matlab to my Matlab search PATH to use matcaffe
if exist('caffe/matlab/+caffe','dir')
    addpath('caffe/matlab/');
else
    error('Please run this from root directory!');
end
addpath('utils/');
% Set caffe mode
use_gpu     = true;
if exist('use_gpu', 'var') && use_gpu
    caffe.set_mode_gpu();
    gpu_id = 1;
    caffe.set_device(gpu_id);
else
    caffe.set_mode_cpu();
end

% Initialize the network using my caffemodel
model_dir       = 'pretrained_model/';
net_model       = ['prototxt/deploy-AFNet.prototxt'];
net_weights     = [model_dir 'AFNet.caffemodel'];
phase           = 'test';
if ~exist(net_weights, 'file')
    error('No such model');
end

% Initialize a network
net         = caffe.Net(net_model, net_weights, phase);
mean_pix    = single([104 117 123]);
mean_pix    = reshape(mean_pix,[1,1,3]);

%% load testing set
impath          = ['test-Image/'];
respath         = ['results/AFNet/'];
if ~exist(respath, 'dir')
    mkdir(respath);
end

im_ext          = '.jpg';
res_ext         = '.png';
imnames         = dir([impath '*' im_ext]);
im_num          = numel(imnames);
input_dim       = 224;
t_start         = tic;

for i = 1 : im_num 
    fprintf('Processing images: %05d/%05d\n', i, im_num);
    im                  = imread([impath, imnames(i).name]);
    [im_data, r, c]     = im_preprocess(im, input_dim, mean_pix, 'input');
    input_data = {im_data};
    res         = net.forward(input_data);
    map         = net.blobs('pre4_map-sm-R2').get_data();
    final_map   = map_postprocess(map, r, c, 'noneed');
    imwrite(final_map, [respath, imnames(i).name(1:end-4), res_ext]);
end

t_end           = toc(t_start);
fps             = round(im_num/t_end);
fprintf('FPS : %d\n', fps);
caffe.reset_all();
