function    [im_data_, r, c]    = im_preprocess(im, input_dim, mean_pix, phase)

    [r,c,k]     = size(im);
    if k == 1
        im  = repmat(im,[1,1,3]);
    end
    im_data     = im(:,:,[3:-1:1]);
    im_data     = permute(im_data, [2,1,3]);
    im_data     = single(im_data);
    im_data     = imresize(im_data, [input_dim input_dim], 'bilinear');
    if strcmp(phase, 'input')
        im_data_     = im_data - repmat(mean_pix, [input_dim input_dim]);
    elseif strcmp(phase, 'prior')
        im_data_ = im_data(:,:,1);
    end