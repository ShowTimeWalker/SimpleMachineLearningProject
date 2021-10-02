clear

LAYERS = [80 30 10];
TRAIN_RATIO = 0.6;
VALIDATION_RATIO = 0.2;
TEST_RATIO = 0.2;

[input, target, sampleNums] = dataPreprocess("TrainData");
net = BPNN_Construction(input, target, LAYERS, TRAIN_RATIO, VALIDATION_RATIO, TEST_RATIO);

%% the data below(predict and result) should be prepared by user
predict = input;
result = target;
[Accuracy, ConfusionTable] = Predict(net, predict, target);

display(ConfusionTable)