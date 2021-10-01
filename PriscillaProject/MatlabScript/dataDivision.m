function res = dataDivision(src, ~)

Audio = src{1};
CO2 = src{2};
TVOC = src{3};

L = max(size(Audio));
AF1 = 25;            %放大因子，判断Frame
MAE = 0.95;          %移动平均系数
Counter = 0;         %失效计数器
Index = 1;           %ST&EN 索引
ADDF = 9;          %延申长度
ADDA = 70;          %延申长度
WW = 10;            %窗口宽度
NL = 0;           %噪音长度
flag = true;         %只计算一次Sigma
Sigma = 5;           %噪音标准差
DL = 100;           %失效长度
ST = uint32(zeros(1, L));
EN = uint32(zeros(1, L));

%% STEP 1
DATA_P = zeros(1, L - 1);
DATA_A = zeros(1, L - 2);
DATA_P(1) = Audio(1);
WE = zeros(1,L - WW - 1);
for i = 2 : L - 1
    DATA_P(i) = DATA_P(i-1) * MAE + Audio(i) * (1 - MAE);
    DATA_A(i-1) = abs(Audio(i) - DATA_P(i));
%% STEP 2
    if i > WW
        WE(i - WW) =...
        sum(DATA_A(i - WW : i - 1));
    end
%% STEP 3
    if ~flag
        if Counter <= 0
            if WE(i - WW) > AF1 * Sigma
                ST(Index) = i - WW - ADDF;
                EN(Index) = i - WW + ADDA;
                Index = Index + 1;
                Counter = DL;
            end
        else
            Counter = Counter - 1;
        end
    end
%% 计算标准差
    if i > NL + WW -1 && flag == true
        flag = false;
    end
end

ST(ST == 0 | ST > L)=[];
EN(EN == 0 | EN > L)=[];

SP = [double(ST);Audio(ST)];
EP = [double(EN);Audio(EN)];
hold on;
plot((1:L)/50,Audio,'K');
plot(SP(1,:)/50,SP(2,:),'go','MarkerSize',10,'MarkerFaceColor','g');
plot(EP(1,:)/50,EP(2,:),'ro','MarkerSize',10,'MarkerFaceColor','r');
% plot((1:L)/50,Audio,'K');
% plot((1:size(WE,2))/50,WE,'K');
xlim([20,40]);
% set(Wave,'position',get(0,'ScreenSize'));
xlabel('时间/s')
ylabel('能量');
grid on;

res.audioSegments = {};
res.CO2Segments = {};
res.TVOCSegments = {};

for i = 1 : size(ST, 2) - 1
    res.audioSegments{i} = Audio(ST(i) : EN(i));
    res.CO2Segments{i} = CO2(ST(i)/10 : EN(i)/10);
    res.TVOCSegments{i} = TVOC(ST(i)/10 : EN(i)/10);
end

end