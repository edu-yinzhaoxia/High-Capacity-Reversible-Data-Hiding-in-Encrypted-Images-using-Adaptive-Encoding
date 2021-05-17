function [mark_I,Side_Info,room,num_S,Huffman_Info] = Huffman_Mark(PE_I,encrypt_I,dict,Pre_PE_op,Pre_PE_ne)
% 函数说明：对加密图像encrypt_I进行标记
% 输入：PE_I（预测误差）,encrypt_I（加密图像）,,pa_1,pa_2（参数）
% 输出：mark_I（标记图像）,Side_Info（辅助信息）,pe_min,pe_max（可嵌入预测误差范围）
% I = imread('测试图像\Lena.tiff');
% origin_I = double(I); 
% Image_key = 1;%图像加密密钥
% 
% 
% 
% % I = imread('测试图像\7003.pgm');
% % origin_I = double(I); 
% % Image_key = 1;%图像加密密钥
% 
% num = 10000000;
% D = round(rand(1,num)*1); %产生稳定随机数
% Data_key = 2; %数据加密密钥
% %可嵌入信息的像素数量
% num_available=0;
% [row,col] = size(origin_I); %计算origin_I的行列值
% %% 计算origin_I的预测误差
% [PE_I] = Predictor_Error(origin_I); 
% hist(PE_I(2:512,2:512),100);
% %% 对原始图像origin_I进行加密
% [encrypt_I] = Encrypt_Image(origin_I,Image_key);
%%  根据预测误差产生哈夫曼编码
[dict,Pre_PE_op,Pre_PE_ne]= Huffman(PE_I);
%[dict,PE_Pro]= Copy_of_Huffman(Pre_PE_op,Pre_PE_ne);
[m1,n1]=size(dict);


 room=0; %% 空出空间位
 
% %% 计算origin_I的预测误差
% [PE_I] = Predictor_Error(origin_I); 
% %% 对原始图像origin_I进行加密
% [encrypt_I] = Encrypt_Image(origin_I,Image_key);
%%  根据预测误差产生哈夫曼编码
[dict,PE_Pro]= Huffman(PE_I);


[row,col] = size(encrypt_I); %计算encrypt_I的行列值
mark_I = encrypt_I;  %构建存储标记图像的容器
mark_I_fli= encrypt_I; %反转后的 
[m1,n1]=size(dict);

%% 辅助量
Huffman_Info = zeros(); %记录Huffman编码信息
Side_Info = zeros(); %记录辅助信息
num_H = 16; %计数，统计哈夫曼编码信息个数
num_S = 0; %计数，统计辅助信息个数
for q=1:m1
    if dict{q,1}>0
        %预测值的二进制形式
       temp=Decimalism_Binary(dict{q,1});
       %正负标志位（1位）
       Huffman_Info(num_H+1)=0;
       num_H = num_H+1;
       %预测误差值（6位）
       Huffman_Info(num_H+1:num_H+6)=temp(3:8);
       num_H = num_H+6;
       %Huffman编码长度（4位）
       L=length(dict{q,2});
       Len=Decimalism_Binary(L);
       Huffman_Info(num_H+1:num_H+4)=Len(5:8);
       num_H = num_H+4;
       %Huffman编码（4位）
       Value=Decimalism_Binary(dict{q,2});
       Huffman_Info(num_H+1:num_H+8)=Value(1:8);
       num_H = num_H+8;
    else
       temp=Decimalism_Binary(abs(dict{q,1}));
       %正负标志位（1位）
       Huffman_Info(num_H+1)=1;
       num_H = num_H+1;
       %预测误差值（6位）
       Huffman_Info(num_H+1:num_H+6)=temp(3:8);
       num_H = num_H+6;
       %Huffman编码长度（4位）
       L=length(dict{q,2});
       Len=Decimalism_Binary(L);
       Huffman_Info(num_H+1:num_H+4)=Len(5:8);
       num_H = num_H+4;
       %Huffman编码（8位）
       Value=Decimalism_Binary(dict{q,2});
       Huffman_Info(num_H+1:num_H+8)=Value(1:8);
       num_H = num_H+8;
    end
    
end
%% Huffman编码长度(16位表示)

L_Huffman = dec2bin(num_H-16)-'0';
if length(L_Huffman) < 16
    len = length(L_Huffman);
    B = L_Huffman;
    L_Huffman = zeros(1,16);
    for i=1:len
        L_Huffman(16-len+i) = B(i); %不足16位前面补充0
    end 
end

Huffman_Info(1:16)= L_Huffman;


%% 记录参考像素值（辅助信息）200*8=1600位
for t=1:200
    temp_value = Decimalism_Binary(mark_I(1,t));
    Side_Info(num_S+1:num_S+8)=temp_value(1:8);
    num_S = num_S+8;
end
%% 将Huffman编码规则嵌入到原来的参考像素位置(前16位是长度)
num_t=0;
for p=1:200
if num_t+8<=num_H
    mark_temp = Decimalism_Binary(mark_I(1,p));
    mark_temp(1:8)=Huffman_Info(num_t+1:num_t+8);
    num_t=num_t+8;
    mark_I(1,p)=Binary_Decimalism(mark_temp);
else
    mark_temp = Decimalism_Binary(mark_I(1,p));
    mark_temp(1:num_H-num_t)=Huffman_Info(num_t+1:num_H);
    num_t=num_t+num_H-num_t;
    mark_I(1,p)=Binary_Decimalism(mark_temp);
end
end
%% 根据预测误差对图像进行标记
for i=2:row
    for j=2:col
        pe = PE_I(i,j); %当前像素点的预测误差
        if pe<Pre_PE_ne || pe>Pre_PE_op %超出范围的预测误差当做一类进行处理
           value = encrypt_I(i,j); %当前加密像素值
           [bin2_8] = Decimalism_Binary(value); %当前加密像素值对应的8位二进制  
           %bin2_8 = fliplr(bin2_8); %% 翻转像素值
           mark=dict{1,2};%对应哈夫曼编码
           [bin_mark] = Decimalism_Binary(mark); %标记mark对应的8位二进制编码
           [~,x1]=size(dict{1,2});
           %% 同样记录辅助信息
           Side_Info(num_S+1:num_S+x1)=bin2_8(1:x1);
           num_S = num_S+x1;
           %% 用Huffman编码标记
           bin2_8(1:x1) = bin_mark(8-x1+1:8);%标记mark只用x1比特表示
           %bin2_8 = fliplr(bin2_8); %% 将像素翻转回来
           %% 经过翻转，只修改LSB，这样就可以求PSNR
           %% 11000111-->11100011-->100 00011
           %% 原始        翻转后      标记后      
           mark_I(i,j)=Binary_Decimalism(bin2_8); %标记后像素值
        else %% 
           value = encrypt_I(i,j); %当前加密像素值
           [bin2_8] = Decimalism_Binary(value); %当前加密像素值对应的8位二进制 
           %bin2_8 = fliplr(bin2_8); % 翻转像素
           for c=1: m1
               if pe == dict{c,1}
                   mark=dict{c,2};
                   [bin_mark] = Decimalism_Binary(mark); %标记mark对应的8位二进制
                   [~,x2]=size(dict{c,2});
                   if x2==1
                       bin2_8(1) = bin_mark(8);%标记mark只用x2比特表示
                   else
                       bin2_8(1:x2) = bin_mark(8-x2+1:8);%标记mark只用x2比特表示
                   end
                   room=8-x2+room;
                   %bin2_8 = fliplr(bin2_8); %翻转回来
                   mark_I(i,j)=Binary_Decimalism(bin2_8);
               end
           end
           
           
        end
            
%         value = encrypt_I(i,j); %当前加密像素值
%         [bin2_8] = Decimalism_Binary(value); %当前加密像素值对应的8位二进制
%         bin2_8 = fliplr(bin2_8); %将8位二进制bin2_8翻转                 %%%%%%%%%为什么要翻转
%         if pe>=pe_min && pe<=pe_max  %可嵌入加密像素，用pa_1比特标记
%             mark = pe + dv; %mark表示标记比特转成十进制的值
%             [bin_mark] = Decimalism_Binary(mark); %标记mark对应的8位二进制
%             bin2_8(1:pa_1) = bin_mark(8-pa_1+1:8);%标记mark只用pa_1比特表示
%         else %不可嵌入像素，用pa_2比特全0标记
%             Side_Info(num_S+1:num_S+pa_2) = bin2_8(1:pa_2); %记录加密像素值的前pa_2比特MSB作为辅助信息
%             num_S = num_S + pa_2;
%             for k=1:pa_2
%                 bin2_8(k) = 0;
%             end
%         end
%         bin2_8 = fliplr(bin2_8); %将bin2_8翻转回来
%         [value] = Binary_Decimalism(bin2_8); %将标记后的二进制转换成标记像素值
%         mark_I(i,j) = value; %记录标记像素 
    end
end
for r=1:row
    for c=1:col
        temp=mark_I(r,c);
        temp_2_8=Decimalism_Binary(temp);
        temp_fli=fliplr(temp_2_8);
        [value_temp] = Binary_Decimalism(temp_fli);
        mark_I_fli(r,c) = value_temp;
    end
end
%end