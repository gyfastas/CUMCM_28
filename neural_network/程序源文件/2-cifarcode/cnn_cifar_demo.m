function cnn_cifar_demo(net,imagepath,data_pre)
%示例函数。利用训练的模型分类图片。
%使用cifar数据集训练，故只支持'airplane'    'automobile'    'bird'    'cat' 
%'deer'   'dog'    'frog'    'horse'     'ship'    'truck' 十类物体的分类。
%该函数可简单修改用于其他模型的示例。

%读入图片、缩放、并中心化。
imageshape=net.meta.inputSize;
im=imread(imagepath);
im_=single(im);
im_=imresize(im_,imageshape(1:2));
im_ = bsxfun(@minus, im_, data_pre.data_mean);

if isfield(data_pre,'normnum')
    z=reshape(im_,[],1);
    z = bsxfun(@minus,z,mean(z,1));
    n = std(z,0,1) ;
    z=bsxfun(@times,z,mean(n) ./ max(n, 40));
    im_=reshape(z,imageshape);
end

if isfield(data_pre,'whitennum')
    z=reshape(im_,[],1);
    z=data_pre.whitennum*z;
    im_=reshape(z,net.meta.inputSize);
end

%模型自动修复。
net=vl_simplenn_tidy(net);
%将最后一层的类型由softmaxloss改为softmax，进行测试。
net.layers{end}.type='softmax';
%通过模型得到结果。res返回每层相关的值。
res = vl_simplenn(net, im_);

%得到最后一层输出的scores。
scores = squeeze(gather(res(end).x)) ;
%得到最大score和相应label编号。
[bestScore,best]=max(scores);
%结果可视化展示。
figure(1) ; clf ; imagesc(im) ;
title(sprintf('%s (%d), score %.3f',...
net.meta.classes.name{best}, best, bestScore)) ;

end

