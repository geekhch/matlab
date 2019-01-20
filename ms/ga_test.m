% clc
clear;

Size = 100;
CodeL = 2;
G = 2000;
% BsJ = 0;

% 变量取值范围
X1 = [-2.048, 2.048];
X2 = [-2.048, 2.048];

% 随机初始变量
E = rand(Size,CodeL);
E(:,1) = X1(1) + (X1(2) - X1(1)).*E(:,1);
E(:,2) = X1(1) + (X2(2) - X2(1)).*E(:,2);

figure;
pplt = axes();
for kg = 1:1:G
    
    % 计算随机点函数值
    % 选择最佳个体
    for i=1:1:Size
        xi = E(i,:);
        F(i) = Rosenbrock(xi(1), xi(2));
    end
    Ji = 1./F;
    if(mod(kg,50) == 0)
        scatter(E(:,1),E(:,2),'Parent',pplt);
        pplt.XLim = [-2.1, 2.1];
        pplt.YLim = [-2.1, 2.1];
        pause(0.001);
    end
    
%     [OrderJi, IndexJi] = sort(Ji);
%     Ji = Ji + 1E-10; % 避免除数为零

%     fi = F;
    
    [Orderfi, Indexfi] = sort(F);
    bfi(kg) = Orderfi(Size);        % 最大函数值个体
    BestS = E(Indexfi(Size),:);     % 最大值个体对应实数编码
    
    % 选择与复制操作
    % 个体适应值计算（占总体适应值的比例，Size*rate表示繁殖后代个体数）
    fi_Size = (Orderfi/sum(F))*Size;    % 繁殖后代数
    
    fi_S = floor(fi_Size);  % 向下取整
    r = Size-sum(fi_S);     % 补充到Size个个体
    
    % 根据向下取整余数的顺序决定补充的个体（随机效果）
    Rest = fi_Size - fi_S;
    [RestValue, Index] = sort(Rest);
    
    for i = Size:-1:Size-r+1
        fi_S(Index(i)) = fi_S(Index(i)) + 1; %增加种群个体
    end
    
    k = 1;
    
    % 选择与复制
    for i = Size:-1:1
        for j=1:1:fi_S(i) % 等级越高，后代越多，即自适应选择
            TempE(k,:) = E(Indexfi(i),:);
            k = k+1;
        end
    end
    
    % 交叉
    
    pc = 0.90; %相邻个体交叉概率
    for i = 1:2:(Size-1)
        temp = rand;
        if pc > temp 
            alfa = rand;
            TempE(i,:) = alfa*E(i+1,:) +(1-alfa)*E(i,:);
            TempE(i+1,:) = alfa*E(i,:) + (1-alfa)*E(i+1,:);
        end
    end
    TempE(Size,:) = BestS;
    E = TempE;
    
    % 变异
    Pm = 0.1 - [1:1:Size] * 0.01/Size; % 自适应变异概率
    Pm_rand = rand(Size, CodeL);
    Mean = [sum(X1)/2 sum(X2)/2];
    Diff = [X1(2)- X1(1) X1(2)- X1(1)];
    
    for i = 1:1:Size
        for j = 1:1:CodeL
            if Pm(i) > Pm_rand(i,j)
                TempE(i,j) = Mean(j)+ Diff(j)*(rand-0.5);
            end
        end
    end
    
    TempE(Size, :) = BestS;
    E = TempE;
end
BestS
bfi(G)