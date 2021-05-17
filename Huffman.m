function [dict,Pre_PE_op,Pre_PE_ne]= Huffman(PE_I)
% I = imread('²âÊÔÍ¼Ïñ\7003.pgm');
% origin_I = double(I); 
% [PE_I] = Predictor_Error(origin_I) ;
% % 
  [m,n] = size(PE_I);
%  PE_Pro=zeros(m-1,n-1);
% subplot(1,2,1);
% imshow(h);
% title('Ô­Í¼');
% h = h(:);

%s = 0:255;
for i=2:m
    for j=2:n
       PE_Pro(i-1,j-1)=PE_I(i,j); 
    end
end
P=tabulate(PE_Pro(:));
[x,y]=size(P);
for h1=1:x
    if P(h1,3) > 100/256
        Pre_PE_ne = P(h1,1);
        break;
    end
    
end
for h2=x:-1:1
    if P(h2,3) > 100/256
        Pre_PE_op = P(h2,1);
        break;
    end
    
end

% for t=1:x
%     if P(t,1)<Pre_PE_ne || P(t,1)>Pre_PE_op
%         p(1)=P(t,3)/100+p(1);
%         s(1)=15;
%     else
%         p(P(t,1)+Pre_PE_op+2)=P(t,3)/100;
%         s(P(t,1)+Pre_PE_op+2)= P(t,1);
%     end
% end
[p,s]= Huffman_code(P,Pre_PE_op,Pre_PE_ne);


% 
 dict=huffmandict(s,p); 
 [m1,n1]=size(dict);
 for x=1:m1
     if length(dict{x,2})>8
         Pre_PE_op = Pre_PE_op-1;
         Pre_PE_ne = Pre_PE_ne+1;
         break;
     end
 end
[p,s]= Huffman_code(P,Pre_PE_op,Pre_PE_ne);
dict=huffmandict(s,p); 
[m1,n1]=size(dict); 

for x=1:m1
     if length(dict{x,2})>8
         Pre_PE_op = Pre_PE_op-1;
         Pre_PE_ne = Pre_PE_ne+1;
         break;
     end
 end
[p,s]= Huffman_code(P,Pre_PE_op,Pre_PE_ne);
dict=huffmandict(s,p); 
[m1,n1]=size(dict); 

for x=1:m1
     if length(dict{x,2})>8
         Pre_PE_op = Pre_PE_op-1;
         Pre_PE_ne = Pre_PE_ne+1;
         break;
     end
 end
[p,s]= Huffman_code(P,Pre_PE_op,Pre_PE_ne);
dict=huffmandict(s,p); 
[m1,n1]=size(dict); 

for x=1:m1
     if length(dict{x,2})>8
         Pre_PE_op = Pre_PE_op-1;
         Pre_PE_ne = Pre_PE_ne+1;
         break;
     end
 end
[p,s]= Huffman_code(P,Pre_PE_op,Pre_PE_ne);
dict=huffmandict(s,p); 
[m1,n1]=size(dict);         
         
 
 
%  for q=1:m1/2
%      if length(dict{q,2})<9
%          continue;
%      else
%          Pre_PE_op = Pre_PE_op-1;
%          Pre_PE_ne = Pre_PE_ne+1;
%      end
%          
%         [p,s]= Huffman_code(P,Pre_PE_op,Pre_PE_ne);
%          dict1=huffmandict(s,p); 
%          [m1,n1]=size(dict);
%  end

% enco=huffmanenco(h,dict); 
% deco=huffmandeco(enco,dict);? 
% deco=col2im(deco,[m,n],[m,n],'distinct'); 
% subplot(1,2,2);
% imshow(uint8(deco));
% imWrite(deco,'1234.bmp')
% title('¹þ·òÂü±àÂë');
