function [p,s]= Huffman_code(P,Pre_PE_op,Pre_PE_ne)
p=zeros();
s=zeros();
[x,y]=size(P);
for t=1:x
    if P(t,1)<Pre_PE_ne || P(t,1)>Pre_PE_op
        p(1)=P(t,3)/100+p(1);
        s(1)=31;
    elseif P(t,1) >= Pre_PE_ne && Pre_PE_ne < 1
        p(P(t,1)-Pre_PE_ne+2)=P(t,3)/100;
        s(P(t,1)-Pre_PE_ne+2)= P(t,1);
    else %P(t,1) <= Pre_PE_op && Pre_PE_op > 0
        p(P(t,1)+Pre_PE_op+1)=P(t,3)/100;
        s(P(t,1)+Pre_PE_op+1)= P(t,1);
    end
end