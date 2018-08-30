% 经济生产批量存储模型
% 1.min C(V,S)
function [x,Cmin]=EPVSM1(cd,cp,cs,P,D)
%得到的矩阵第一项为周期T，第二项为库存为零的时刻t2
%D0为预估市场需求量
%cd为准不变成本
%cp为单位产品存贮费用
%cs为单位产品因短缺而导致的费用
%P为年产量
%D为需求速度
%V为最大库存
%S为最大缺货量

C =@(x) (cp*x(1).^2+cs*x(2).^2)./(2*(x(1)+x(2))) + cd*D*(P-D)/(P*(x(1)+x(2)));
x0=[0 0];
[x,Cmin]=fminsearch(C,x0);
V = x(1);
S = x(2);
end

% 2. min C(Q,S)
function [x,Cmin]=EPVSM2(cd,cp,cs,P,D)
%得到的矩阵第一项为周期T，第二项为库存为零的时刻t2
%D0为预估市场需求量
%cd为准不变成本
%cp为单位产品存贮费用
%cs为单位产品因短缺而导致的费用
%P为年产量
%D为需求速度
%Q为一个周期内的总产量
%S为最大缺货量
C =@(x) cp*(x(1)*(1-D/P)-x(2)).^2 ./ (2*x(1)*(1-D/P)) + cd*D/x(1) + cs*x(2).^2/(2*x(1)*(1-D/P));
x0=[0 0];
[x,Cmin]=fminsearch(C,x0);
Q = x(1);
S = x(2);
end

%带有约束的确定型允许缺货存贮模型
function [x,fval]=DAOSMC(WT,J,CD,P,D,K,CP,W,CS) 
%返回值x为Q1,Q2...Qn,S1,S2...Sn的向量
%最大库容量为WT
%可用资金上限为J
%准不变成本为CD
%物资年产量为行向量P
%物资年需求量为行向量D
%单价为行向量K
%存贮费为行向量CP
%占用库存行向量W
%缺货损失费用行向量CS
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

%单周期随机库存模型
function [q]=SRIM(pdf, U, K, V) 
%销售价格U，成本价格K，折扣价格V
%pdf为假设概率密度函数的句柄。
syms x;
Opt = @(q)(U-K)*q - (U-V)*int((q-x)*pdf(x),x,0,q);
[q,fval] = fminsearch(Opt,0);
end
