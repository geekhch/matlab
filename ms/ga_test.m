% clc
clear;

Size = 100;
CodeL = 2;
G = 2000;
% BsJ = 0;

% ����ȡֵ��Χ
X1 = [-2.048, 2.048];
X2 = [-2.048, 2.048];

% �����ʼ����
E = rand(Size,CodeL);
E(:,1) = X1(1) + (X1(2) - X1(1)).*E(:,1);
E(:,2) = X1(1) + (X2(2) - X2(1)).*E(:,2);

figure;
pplt = axes();
for kg = 1:1:G
    
    % ��������㺯��ֵ
    % ѡ����Ѹ���
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
%     Ji = Ji + 1E-10; % �������Ϊ��

%     fi = F;
    
    [Orderfi, Indexfi] = sort(F);
    bfi(kg) = Orderfi(Size);        % �����ֵ����
    BestS = E(Indexfi(Size),:);     % ���ֵ�����Ӧʵ������
    
    % ѡ���븴�Ʋ���
    % ������Ӧֵ���㣨ռ������Ӧֵ�ı�����Size*rate��ʾ��ֳ�����������
    fi_Size = (Orderfi/sum(F))*Size;    % ��ֳ�����
    
    fi_S = floor(fi_Size);  % ����ȡ��
    r = Size-sum(fi_S);     % ���䵽Size������
    
    % ��������ȡ��������˳���������ĸ��壨���Ч����
    Rest = fi_Size - fi_S;
    [RestValue, Index] = sort(Rest);
    
    for i = Size:-1:Size-r+1
        fi_S(Index(i)) = fi_S(Index(i)) + 1; %������Ⱥ����
    end
    
    k = 1;
    
    % ѡ���븴��
    for i = Size:-1:1
        for j=1:1:fi_S(i) % �ȼ�Խ�ߣ����Խ�࣬������Ӧѡ��
            TempE(k,:) = E(Indexfi(i),:);
            k = k+1;
        end
    end
    
    % ����
    
    pc = 0.90; %���ڸ��彻�����
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
    
    % ����
    Pm = 0.1 - [1:1:Size] * 0.01/Size; % ����Ӧ�������
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