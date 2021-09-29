function readSineWaveData(src, ~)

data = readline(src);
document = tokenizedDocument(data);
words = string(document);

for i = 1:10
    src.UserData.Microphone(end+1) = str2double(words(i));
end

src.UserData.TVOC(end+1) = str2double(words(11));
src.UserData.CO2(end+1) = str2double(words(12));

% If 1001 data points have been collected from the Arduino, switch off the
% callbacks and plot the data.
if size(src.UserData.Microphone, 2) >= 4500
    configureCallback(src, "off");
    plot(src.UserData.Microphone);
    Audio = src.UserData.Microphone(1301:end);
    TVOC = src.UserData.TVOC(131:end);
    CO2 = src.UserData.CO2(131:end);
    save("./DATA/test_5.mat", "Audio", "TVOC", "CO2");
end
end