% �������������洢ģ��
% 1.min C(V,S)
function [x,Cmin]=EPVSM1(cd,cp,cs,P,D)
%�õ��ľ����һ��Ϊ����T���ڶ���Ϊ���Ϊ���ʱ��t2
%D0ΪԤ���г�������
%cdΪ׼����ɱ�
%cpΪ��λ��Ʒ��������
%csΪ��λ��Ʒ���ȱ�����µķ���
%PΪ�����
%DΪ�����ٶ�
%VΪ�����
%SΪ���ȱ����

C =@(x) (cp*x(1).^2+cs*x(2).^2)./(2*(x(1)+x(2))) + cd*D*(P-D)/(P*(x(1)+x(2)));
x0=[0 0];
[x,Cmin]=fminsearch(C,x0);
V = x(1);
S = x(2);
end

% 2. min C(Q,S)
function [x,Cmin]=EPVSM2(cd,cp,cs,P,D)
%�õ��ľ����һ��Ϊ����T���ڶ���Ϊ���Ϊ���ʱ��t2
%D0ΪԤ���г�������
%cdΪ׼����ɱ�
%cpΪ��λ��Ʒ��������
%csΪ��λ��Ʒ���ȱ�����µķ���
%PΪ�����
%DΪ�����ٶ�
%QΪһ�������ڵ��ܲ���
%SΪ���ȱ����
C =@(x) cp*(x(1)*(1-D/P)-x(2)).^2 ./ (2*x(1)*(1-D/P)) + cd*D/x(1) + cs*x(2).^2/(2*x(1)*(1-D/P));
x0=[0 0];
[x,Cmin]=fminsearch(C,x0);
Q = x(1);
S = x(2);
end

%����Լ����ȷ��������ȱ������ģ��
function [x,fval]=DAOSMC(WT,J,CD,P,D,K,CP,W,CS) 
%����ֵxΪQ1,Q2...Qn,S1,S2...Sn������
%��������ΪWT
%�����ʽ�����ΪJ
%׼����ɱ�ΪCD
%���������Ϊ������P
%������������Ϊ������D
%����Ϊ������K
%������Ϊ������CP
%ռ�ÿ��������W
%ȱ����ʧ����������CS
n= length(D);
f=@(x) sum((CP.*(x(1:n) .*(1-D./P)-x(n+1:2*n)).^2+CS.*x(n+1:2*n).^2)./(2.*x(1:n).*(1-D./P))+CD*D./x(1:n));
N=zeros(1,n);
A=[K N];
b=J;
Aeq = []; beq = [];
lb=N;ub = [];
G=@(x) sum(W.*(Q.*(1-D./P)-x(n+1:2*n)))-WT;
cont2 =@(x) fun2nonlcon(x,G);
x0=zeros(1,2*n);
[x,fval] = fmincon(f,x0,A,b,Aeq,beq,lb,ub,cont2);
end
function [c,ceq]=fun2nonlcon(x,G)
ceq = 0;
c = G(x);
end

%������������ģ��
function [q]=SRIM(pdf, U, K, V) 
%���ۼ۸�U���ɱ��۸�K���ۿۼ۸�V
%pdfΪ��������ܶȺ����ľ����
syms x;
Opt = @(q)(U-K)*q - (U-V)*int((q-x)*pdf(x),x,0,q);
[q,fval] = fminsearch(Opt,0);
end
