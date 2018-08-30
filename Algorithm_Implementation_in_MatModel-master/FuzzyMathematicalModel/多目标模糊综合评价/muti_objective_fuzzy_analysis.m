function f = muti_objective_fuzzy_analysis(x)
    % 建立各项指标的隶属度函数,这一部分是建模的内容
    % 案例中有5项指标，如下
    f(1,:) = x(1,:) / 8800;
    f(2,:) = 1 - x(2,:)/8000;
    
    f(3,:) = 0;
    f(3,find(x(3,:)<=5.5) == 1);
    flag = find(x(3,:)>5.5 & x(3,:)<=8.0);
    f(3,flag) = (8-x(3,flag)) / 2.5;

    f(4,:) = 1 - x(4,:)/200;
    f(5,:) = (x(5,:)-50) / 1450;
    
end