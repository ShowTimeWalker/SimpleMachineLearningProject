%step1: ��ԭʼ���ݲ����ƶ�ƽ��Ԥ����
%step2: ����һ��ʱ�򴰣����糤��100�������㴰������ֵ
%step3: ��������ֵ�ж϶���֡
%step4: ȷ����ʼ�㣬��ȡ����


clear;
load('.\DATA\test_5.mat');

A = Audio;
L = max(size(A));
AF1 = 25;            %�Ŵ����ӣ��ж�Frame
MAE = 0.95;          %�ƶ�ƽ��ϵ��
Counter = 0;         %ʧЧ������
Index = 1;           %ST&EN ����
ADDF = 10;          %���곤��
ADDA = 70;          %���곤��
WW = 10;            %���ڿ��
NL = 0;           %��������
flag = true;         %ֻ����һ��Sigma
Sigma = 5;           %������׼��
DL = 100;           %ʧЧ����
ST = uint32(zeros(1, L));
EN = uint32(zeros(1, L));

%% STEP 1
DATA_P = zeros(1, L - 1);
DATA_A = zeros(1, L - 2);
DATA_P(1) = A(1);
WE = zeros(1,L - WW - 1);
for i = 2 : L - 1
    DATA_P(i) = DATA_P(i-1) * MAE + A(i) * (1 - MAE);
    DATA_A(i-1) = abs(A(i) - DATA_P(i));
%% STEP 2
    if i > WW
        WE(i - WW) =...
        sum(DATA_A(i - WW : i - 1));
    end
%% STEP 3
    if ~flag
        if Counter <= 0
            if WE(i - WW) > AF1 * 5
                ST(Index) = i - WW - ADDF;
                EN(Index) = i - WW + ADDA;
                Index = Index + 1;
                Counter = DL;
            end
        else
            Counter = Counter - 1;
        end
    end
%% �����׼��
    if i > NL + WW -1 && flag == true
        Sigma = std(WE(1:NL));
        flag = false;
    end
end

ST(ST == 0 | ST > L)=[];
EN(EN == 0 | EN > L)=[];

SP = [double(ST);Audio(ST)];
EP = [double(EN);Audio(EN)];
Wave = figure(1);
hold on;
plot((1:L)/50,Audio,'K');
plot(SP(1,:)/50,SP(2,:),'go','MarkerSize',10,'MarkerFaceColor','g');
plot(EP(1,:)/50,EP(2,:),'ro','MarkerSize',10,'MarkerFaceColor','r');
plot((1:L)/50,A,'K');
% plot((1:size(WE,2))/1000,WE,'K');
% line([150 162],[1 1],'LineWidth',2);
xlim([20,40]);
set(Wave,'position',get(0,'ScreenSize'));
xlabel('ʱ��/s')
ylabel('����');
grid on;
%% END



