function [num_available,stego_I,encrypt_I,emD,num_emD,num_S,Huffman_Info,Pre_PE_op,Pre_PE_ne] = Encrypt_Embed(origin_I,Image_key,D,Data_key,pa_1,pa_2)
% 函数说明：将原始图像origin_I加密并嵌入数据
% 输入：origin_I（原始图像）,Image_key（图像加密密钥）,D（秘密数据）,Data_key(数据加密密钥),pa_1,pa_2（参数）
% 输出：stego_I（载密图像）,encrypt_I（加密图像）,emD（嵌入的秘密数据）,num_emD（嵌入秘密数据的个数）
% I = imread('测试图像\Lena.tiff');
% origin_I = double(I); 
% Image_key = 1;%图像加密密钥
% num = 10000000;
% D = round(rand(1,num)*1); %产生稳定随机数
% Data_key = 2; %数据加密密钥
%可嵌入信息的像素数量
num_available=0;
[row,col] = size(origin_I); %计算origin_I的行列值
%% 计算origin_I的预测误差
[PE_I] = Predictor_Error(origin_I); 
hist(PE_I(2:512,2:512),100);
%% 对原始图像origin_I进行加密
[encrypt_I] = Encrypt_Image(origin_I,Image_key);
%%  根据预测误差产生哈夫曼编码
[dict,Pre_PE_op,Pre_PE_ne]= Huffman(PE_I);
%[dict,PE_Pro]= Copy_of_Huffman(Pre_PE_op,Pre_PE_ne);
[m1,n1]=size(dict);

%% 对加密图像encrypt_I进行Huffman标记
[mark_I,Side_Info,room,num_S,Huffman_Info] = Huffman_Mark(PE_I,encrypt_I,dict,Pre_PE_op,Pre_PE_ne);
% %% 对加密图像encrypt_I进行标记
% [mark_I,Side_Info,pe_min,pe_max] = BinaryTree_Mark(PE_I,encrypt_I,pa_1,pa_2);

% K =[0.01 0.03];
% window = fspecial('gaussian', 11, 1.5);
% L = 255;
% disp('Encrypted image with label的PSNR和SSIM为：')
% psnrmark = PSNR(origin_I,mark_I) 
% ssimVmark = SSIM(origin_I,mark_I, K, window, L) %% 函数调用


%imwrite(uint8(mark_I),'过程图像\加密+标记的Lena.png','png');
%% 对原始秘密信息D进行加密
[Encrypt_D] = Encrypt_Data(D,Data_key);
%% 辅助量
num_D = length(Encrypt_D); %求秘密信息D的长度
num_emD = 0; %计数，统计嵌入秘密信息的个数
num_S = length(Side_Info); %求辅助信息Side_Info的长度
num_side = 0; %计数，记录嵌入辅助信息的个数



    
%% 在标记图像中嵌入信息
stego_I = mark_I;  %构建存储载密图像的容器
for i=2:row
    for j=2:col 
        if num_emD >= num_D %秘密数据已嵌入完毕
            break;
        end
        pe = PE_I(i,j); %当前像素点的预测误差
        value = mark_I(i,j); %当前标记像素值
        [bin2_8] = Decimalism_Binary(value); %当前标记像素值对应的8位二进制
        %bin2_8 = fliplr(bin2_8); %将8位二进制bin2_8翻转
        if pe<Pre_PE_ne || pe>Pre_PE_op %不可嵌入点 
            %bin2_8 = fliplr(bin2_8); %将bin2_8翻转回来 
            [value] = Binary_Decimalism(bin2_8);
            stego_I(i,j) = value; 
            
        else %可嵌入加密像素，可嵌入(8-x2)比特
            num_available=num_available+1;
            for c=1: m1     %首先求x2
                   if pe == dict{c,1}
                   [~,x2]=size(dict{c,2});
                   end
            end
            
            if num_side < num_S %辅助信息没有嵌完
              
                if num_side+8-x2 <= num_S %(8-x2)比特都用来嵌入辅助信息
                    bin2_8(x2+1:8) = Side_Info(num_side+1:num_side+8-x2);
                    num_side = num_side + 8-x2;
                    %bin2_8 = fliplr(bin2_8); %将bin2_8翻转回来
                    [value] = Binary_Decimalism(bin2_8);
                    stego_I(i,j) = value; %替换t位LSB
                else
                    t = num_S - num_side; %剩余辅助信息个数
                    bin2_8(x2+1:x2+t) = Side_Info(num_side+1:num_S); %tbit辅助信息
                    num_side = num_side + t;
                    bin2_8(x2+t+1:8) = Encrypt_D(num_emD+1:num_emD+8-x2-t); %(8-x2-t)bit秘密数据
                    num_emD = num_emD + 8-x2-t;
                    %bin2_8 = fliplr(bin2_8); %将bin2_8翻转回来
                    [value] = Binary_Decimalism(bin2_8);
                    stego_I(i,j) = value; %替换t位LSB
                end
            else %辅助信息嵌完之后再嵌入秘密数据
                if num_emD+8-x2 <= num_D %(8-pa_1)比特都用来嵌入秘密数据
                    bin2_8(x2+1:8) = Encrypt_D(num_emD+1:num_emD+8-x2);
                    num_emD = num_emD + 8-x2;
                    %bin2_8 = fliplr(bin2_8); %将bin2_8翻转回来
                    [value] = Binary_Decimalism(bin2_8);
                    stego_I(i,j) = value; %替换t位LSB
                else
                    t = num_D - num_emD; %剩余秘密数据个数
                    bin2_8(x2+1:x2+t) = Encrypt_D(num_emD+1:num_D); %tbit秘密数据
                    num_emD = num_emD + t;
                    %bin2_8 = fliplr(bin2_8); %将bin2_8翻转回来
                    [value] = Binary_Decimalism(bin2_8);
                    stego_I(i,j) = value; %替换t位LSB
                end
            end
        end      
    end
end
%% 统计嵌入的秘密数据
if num_side == num_S %表示辅助信息嵌入完毕
    emD = D(1:num_emD);
else %否侧辅助信息过长，无法嵌入秘密数据
    emD = zeros();
    num_emD = num_side - num_S;
end
