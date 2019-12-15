file = fopen('sunspots.txt','r');
formatSpec = '%f %f';
sizeData = [1 Inf];
sunspots = fscanf(file,formatSpec,sizeData);
fclose(file);

sunspots = smooth(sunspots, 12);

D = 5;
trainSize = 500;
ValidationSize = 100;
testSize = 50;

trainInd = 1 : trainSize;
valInd = trainSize + 1 : trainSize + ValidationSize;
testInd = trainSize + ValidationSize + 1 : trainSize + ValidationSize + testSize;

network = timedelaynet(1 : D, 10, 'trainlm');
network.divideFcn = 'divideind';
network.divideParam.trainInd = trainInd;
network.divideParam.valInd = valInd;
network.divideParam.testInd = testInd;

sunspots = con2seq(sunspots(1 : trainSize + ValidationSize + testSize)');
network = configure(network, sunspots, sunspots);
network = init(network);
network.trainParam.epochs = 600;
network.trainParam.max_fail = 600;
network.trainParam.goal = 1e-5;
view(network);

[Xs, Xi, Ai, Ts] = preparets(network, sunspots, sunspots); 
network = train(network, Xs, Ts, Xi, Ai);

Result = sim(network, Xs, Xi);

figure;
hold on;
grid on;
plot(cell2mat(sunspots), '-b');
plot([cell2mat(Xi) cell2mat(Result)], '-r');

figure;
hold on;
grid on;
plot([cell2mat(Xi) cell2mat(Result)] - cell2mat(sunspots), '-r');

xm = cell2mat(sunspots);
ym = cell2mat(Result);

figure;
hold on;
grid on;
plot(xm(trainSize + ValidationSize + 1 : trainSize + ValidationSize + testSize), '-b');
plot(ym(trainSize + ValidationSize - 9 : trainSize + ValidationSize + testSize - 10), '-r');