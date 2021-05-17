%function [Side_Info,Encrypt_exD,PE_I] = Extract_Data(stego_I,num_emD)
function [dict_re,ExD,num_Ext,Side_Info,PE_I] = Extract_Data(stego_I,num_emD,num_S,Pre_PE_op,Pre_PE_ne)
% 函数说明：在加密标记图像中提取信息
% 输入：stego_I（加密标记图像）,num_emD（秘密信息的长度）
% 输出：Side_Info（辅助信息）,Encrypt_exD（加密的秘密信息）,PE_I（预测误差）,pa_1,pa_2（参数）


%% 辅助量
[row,col] = size(stego_I); %统计stego_I的行列数
PE_I = stego_I;
%% 在参考像素位置处提取Huffman编码
Huffman_Info=zeros();
Huffman_Length=zeros();
num_Huffman=0;
L=0;
%% 求Huffman编码表长度
Huffman_Length(1:8)= Decimalism_Binary(stego_I(1,1));
Huffman_Length(9:16)= Decimalism_Binary(stego_I(1,2));

len = length(Huffman_Length);
for i=1:len
    L = L + Huffman_Length(i)*(2^(len-i));
end
%% 提取Huffman编码表,将其信息存储在Huffman_Info中
for t=3:200
    if num_Huffman+8<=L %Huffman编码表未提取完
        Temp=Decimalism_Binary(stego_I(1,t));
        Huffman_Info(num_Huffman+1:num_Huffman+8)=Temp(1:8);
        num_Huffman=num_Huffman+8;
    else
        x=L-num_Huffman;
        Temp=Decimalism_Binary(stego_I(1,t));
        Huffman_Info(num_Huffman+1:num_Huffman+x)=Temp(1:x);
        num_Huffman=num_Huffman+x;
    end
end
%% 将Huffman_Info中信息解码，得到dict_re（5：预测误差值 4：Huffman编码长度 8：Huffman）
dict_re=cell(0);
for q=1:19:num_Huffman
    if Huffman_Info(q)== 0 %PE为正值
        PE=Binary_Decimalism(Huffman_Info(q+1:q+6));
        Len=Binary_Decimalism(Huffman_Info(q+7:q+10)); %编码长度
        Mark=Huffman_Info(q+11:q+18);
        dict_re{floor(q/19)+1,1}=PE;
        dict_re{floor(q/19)+1,2}=Mark(8-Len+1:8);
    else
        PE=Binary_Decimalism(Huffman_Info(q+1:q+6))-2*(Binary_Decimalism(Huffman_Info(q+1:q+6)));
        Len=Binary_Decimalism(Huffman_Info(q+7:q+10)); %编码长度
        Mark=Huffman_Info(q+11:q+18);
        dict_re{floor(q/19)+1,1}=PE;
        dict_re{floor(q/19)+1,2}=Mark(8-Len+1:8);
    end
end
 [m1,n1]=size(dict_re);
%% 提取嵌入的信息
Ext_Info=zeros();%提取信息
Num_Ext=0; %提取信息数量
for i=2:row
    for j=2:col
       value = stego_I(i,j); %当前载密像素值 
       [bin2_8] = Decimalism_Binary(value); %当前载密像素值对应的8位二进制
       %bin2_8 = fliplr(bin2_8); %将8位二进制bin2_8翻转
       for d=2:m1
           
               [~,x2]=size(dict_re{d,2});
               if bin2_8(1:x2)== dict_re{d,2} %寻找标记对应Huffman编码
                   PE_I(i,j) = dict_re{d,1};
                   Ext_Info(Num_Ext+1:Num_Ext+8-x2)=bin2_8(x2+1:8);% 提取信息
                   Num_Ext=Num_Ext+8-x2; %记录提取信息数量
               end
           
       end
    end
end
Side_Info=zeros();    %辅助信息
ExD=zeros();          %净嵌入信息
Side_Info(1:num_S)=Ext_Info(1:num_S);  %嵌入的辅助信息
num_Ext=Num_Ext-num_S;     %净嵌入信息数量
ExD(1:num_Ext)=Ext_Info(num_S+1:Num_Ext);
% %% 恢复参考像素值
% for k=1:8:100
%     stego_I(1,floor(k/8)+1)=Binary_Decimalism(Side_Info(k:k+7));
% end
% %% 恢复不可嵌入信息值
% Side_num=800;%前800位是参考像素值
% for i1=2:row
%     for j1=2:col
%        value = stego_I(i1,j1); %当前载密像素值 
%        [bin2_8] = Decimalism_Binary(value); %当前载密像素值对应的8位二进制
%        %bin2_8 = fliplr(bin2_8); %将8位二进制bin2_8翻转
%        [~,x1]=size(dict_re{1,2});
%        if bin2_8(1:x1)== dict_re{1,2} %寻找标记对应Huffman编码
%            PE_I(i1,j1)=15;
%            bin2_8(1:x1)=Side_Info(Side_num+1:Side_num+x1);%恢复值
%            Side_num=Side_num+x1;
%        end
%     end
% end
% %% 提取嵌入的信息
% for i=2:row
%     for j=2:col
%         sign = 0; %标记信息，判断是嵌入点还是不可嵌入点
%         value = stego_I(i,j); %当前载密像素值
%         [bin2_8] = Decimalism_Binary(value); %当前载密像素值对应的8位二进制
%         bin2_8 = fliplr(bin2_8); %将8位二进制bin2_8翻转
%         for k=1:pa_2
%             if bin2_8(k) ~= 0
%                 sign = 1; %表示前pa_2位不全为0，即为可嵌入点
%             end
%         end
%         if sign == 1 %可嵌入点
%             bin_mark = bin2_8(1:pa_1); %提取标记值
%             [mark] = Binary_Decimalism(bin_mark); %将表机制转换成十进制
%             PE_I(i,j) = mark - dv; %预测误差与标记值相差dv
%             Info(t+1:t+8-pa_1) = bin2_8(pa_1+1:8); %标记位之外的记为嵌入的信息
%             t = t + 8-pa_1;
%         else %不可嵌入点
%             num_side = num_side + pa_2; %前pa_2位作为辅助信息
%             PE_I(i,j) = pe_min - 1; %将其测误差设为嵌入预范围之外
%         end 
%     end
% end
% %% 记录辅助信息和加密的秘密数据
% num_side = num_side + 8; %特殊像素8位也作为辅助信息
% Side_Info = Info(1:num_side);
% Encrypt_exD = Info(num_side+1:num_side+num_emD);
% end