function [net] = BPNN_Construction(Input,Target,NeuronNum,trRatio,vRation,tRation)
%% ����BPNNģ��,���������ģ�ͣ���������õĲ����Լ�BPNN������
% Input ���ڴ���BPNN������
% Target �ලѧϰ�ı�ǩ
% NeuronNum ��������Ԫ����
% trRatio ѵ������
% vRation ��֤����
% tRation ���Ա���
% net ���BPNNģ��

x = Input;
t = Target;
trainFcn = 'trainscg';              % ѵ������
hiddenLayerSize = NeuronNum;        % ��������Ԫ����
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