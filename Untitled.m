%function [dict,PE_Pro]= Copy_of_Huffman(Pre_PE_op,Pre_PE_ne)
% I = imread('测试图像\Lena.tiff');
% origin_I = double(I); 
% [PE_I] = Predictor_Error(origin_I) ;


%% 图像数据集信息(ucid.v2),格式:TIFF,数量:1338；
I_file_path = 'D:\ImageDatabase\ucid.v2\'; %测试图像数据集文件夹路径
I_path_list = dir(strcat(I_file_path,'*.tif')); %获取该文件夹中所有pgm格式的图像
img_num = length(I_path_list); %获取图像总数量
Info=zeros();
num_I=0;
for l=1:img_num
    I_name = I_path_list(l).name; %图像名
    I = imread(strcat(I_file_path,I_name));%读取图像
    origin_I = double(I);
    [PE_I] = Predictor_Error(origin_I);
    [m,n] = size(PE_I);
    PE_Pro=zeros(m-1,n-1);
  
    for i=2:m
    for j=2:n
       PE_Pro(i-1,j-1)=PE_I(i,j); 
       Info(num_I+1)=PE_I(i,j);
       num_I=num_I+1;
    end
    end
    
end


% subplot(1,2,1);
% imshow(h);
% title('原图');
% h = h(:);

%s = 0:255;

P=tabulate(Info(:));
[x,y]=size(P);
p=zeros();
s=zeros();
for t=1:x
    if P(t,1)<Pre_PE_ne || P(t,1)>Pre_PE_op
        p(1)=P(t,3)/100+p(1);
        s(1)=15;
    else
        p(P(t,1)+Pre_PE_op+2)=P(t,3)/100;
        s(P(t,1)+Pre_PE_op+2)= P(t,1);
    end
end



% 
 dict=huffmandict(s,p); 
 [m1,n1]=size(dict);
 
% enco=huffmanenco(h,dict); 
% deco=huffmandeco(enco,dict);? 
% deco=col2im(deco,[m,n],[m,n],'distinct'); 
% subplot(1,2,2);
% imshow(uint8(deco));
% imWrite(deco,'1234.bmp')
% title('哈夫曼编码');
