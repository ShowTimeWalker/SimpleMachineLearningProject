function [net] = BPNN_Construction(Input,Target,NeuronNum,trRatio,vRation,tRation)
%% 建立BPNN模型,输出神经网络模型，输入测试用的参数以及BPNN超参数
% Input 用于创建BPNN的数据
% Target 监督学习的标签
% NeuronNum 隐含层神经元个数
% trRatio 训练比例
% vRation 验证比例
% tRation 测试比例
% net 输出BPNN模型

x = Input;
t = Target;
trainFcn = 'trainscg';              % 训练函数
hiddenLayerSize = NeuronNum;        % 隐含层神经元个数
net = patternnet(hiddenLayerSize, trainFcn);
net.input.processFcns = {'removeconstantrows','mapminmax'};
net.divideFcn = 'dividerand';       % Divide data randomly
net.divideMode = 'sample';          % Divide up every sample
net.divideParam.trainRatio = trRatio;
net.divideParam.valRatio = vRation;
net.divideParam.testRatio = tRation;
net.performFcn = 'crossentropy';    % Cross-Entropy
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotconfusion', 'plotroc'};
% Train the Network
[net] = train(net,x,t);
% Test the Network
% y = net(x);
% e = gsubtract(t,y);
% performance = perform(net,t,y);
% tind = vec2ind(t);
% yind = vec2ind(y);
% percentErrors = sum(tind ~= yind)/numel(tind);
% % Recalculate Training, Validation and Test Performance
% trainTargets = t .* tr.trainMask{1};
% valTargets = t .* tr.valMask{1};
% testTargets = t .* tr.testMask{1};
% trainPerformance = perform(net,trainTargets,y);
% valPerformance = perform(net,valTargets,y);
% testPerformance = perform(net,testTargets,y);
% view(net)
return