function [Accuracy, ConfusionTable] = Predict(NET, Predict, Target)
%% 实验测试，获得精确度和混淆矩阵

Result = NET(Predict);
Maximum = max(Result);
PredictNum = size(Predict,2);
MotionNum = size(Result,1);
Speices = cell(MotionNum,1);
for i = 1:MotionNum
    Speices{i,1} = ['Motion' num2str(i)];
end
SampleNum = sum(Target,2)';
SampleIndex = ones(1,MotionNum+1);
for i = 1:MotionNum
    SampleIndex(i+1) = sum(SampleNum(1:i)) + 1;
end
Label_1 = zeros(MotionNum,PredictNum);        % 用于获得精确度
Label_2 = zeros(MotionNum,PredictNum);        % 用于获得混淆矩阵
for i = 1:MotionNum
    for j = 1:SampleNum(i)
        Label_1(i,SampleIndex(i)-1+j) = Result(i,SampleIndex(i)-1+j) ==...
            Maximum(SampleIndex(i)-1+j);
    end
    for j = 1:PredictNum
        Label_2(i,j) = Result(i,j) == Maximum(j);
    end
end

Accuracy = sum(sum(Label_1))/PredictNum;

ConfusionMatrix = zeros(MotionNum,MotionNum);
for i = 1:MotionNum
    ConfusionMatrix(i,:) = sum(Label_2(:,SampleIndex(i):SampleIndex(i+1)-1),2);
end
ConfusionMatrix = ConfusionMatrix';
ConfusionTable = array2table(ConfusionMatrix);
Tspeice = cell(1,MotionNum);
for i = 1:MotionNum
    Tspeice{1,i} = Speices{i,1};
end
ConfusionTable.Properties.VariableNames = Tspeice;
ConfusionTable.Properties.RowNames = Speices;
return