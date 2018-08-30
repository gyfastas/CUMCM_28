function cnn_cifar_demo(net,imagepath,data_pre)
%ʾ������������ѵ����ģ�ͷ���ͼƬ��
%ʹ��cifar���ݼ�ѵ������ֻ֧��'airplane'    'automobile'    'bird'    'cat' 
%'deer'   'dog'    'frog'    'horse'     'ship'    'truck' ʮ������ķ��ࡣ
%�ú����ɼ��޸���������ģ�͵�ʾ����

%����ͼƬ�����š������Ļ���
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

%ģ���Զ��޸���
net=vl_simplenn_tidy(net);
%�����һ���������softmaxloss��Ϊsoftmax�����в��ԡ�
net.layers{end}.type='softmax';
%ͨ��ģ�͵õ������res����ÿ����ص�ֵ��
res = vl_simplenn(net, im_);

%�õ����һ�������scores��
scores = squeeze(gather(res(end).x)) ;
%�õ����score����Ӧlabel��š�
[bestScore,best]=max(scores);
%������ӻ�չʾ��
figure(1) ; clf ; imagesc(im) ;
title(sprintf('%s (%d), score %.3f',...
net.meta.classes.name{best}, best, bestScore)) ;

end

