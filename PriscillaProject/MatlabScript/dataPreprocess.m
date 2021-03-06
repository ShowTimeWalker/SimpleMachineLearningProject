function [input, target, sampleNums] = dataPreprocess(RowDataDir)

MAX_SAMPLE = 100;
SELECTOR_1 = [true, true, false, true, true, false, false, false...
         , false, false, false, false, true, true, true, true];
SELECTOR_2 = [true, true, false, true, true, false, false, false...
         , false, false, false, false, false, false, false, false];
SELECTOR_3 = [true, true, false, true, true, false, false, false...
         , false, false, false, false, false, false, false, false];
     
listing = dir(RowDataDir);
indexes = 4 : 2 : size(listing, 1);
input = zeros(sum(SELECTOR_1) + sum(SELECTOR_2) + sum(SELECTOR_3), MAX_SAMPLE * size(indexes, 2));
target = zeros(size(indexes, 2), MAX_SAMPLE * size(indexes, 2));
sampleNum = 0;
sampleNums = zeros(size(indexes, 2), 1);


for groupIndex = 1 : size(indexes, 2)
    filename = "./TrainData/" + listing(indexes(groupIndex)).name;
    load(filename, "dataSegments")
    for sampleIndex = 1 : size(dataSegments.audioSegments, 2)
        sampleNum = sampleNum + 1;
        feature = FeatureExtract(dataSegments.audioSegments{sampleIndex}', SELECTOR_1);
        input(1 : sum(SELECTOR_1), sampleNum) = feature;
        feature = FeatureExtract(dataSegments.CO2Segments{sampleIndex}', SELECTOR_2);
        input(sum(SELECTOR_1) + 1 : sum(SELECTOR_1) + sum(SELECTOR_2), sampleNum) = feature;
        feature = FeatureExtract(dataSegments.TVOCSegments{sampleIndex}', SELECTOR_3);
        input(sum(SELECTOR_1) + sum(SELECTOR_2) + 1 :...
            sum(SELECTOR_1) + sum(SELECTOR_2) + sum(SELECTOR_3), sampleNum) = feature;
    end
    target(groupIndex, sum(sampleNums) + 1 : sampleNum) = 1;
    sampleNums(groupIndex) = sampleNum - sum(sampleNums);
end

input(:, sampleNum + 1 : end) = [];
target(:, sampleNum + 1 : end) = [];