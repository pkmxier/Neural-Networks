% function
a = 1;
b = 4.5;
h = 0.01;
n = (b - a) / h + 1;

X = a : h : b;
Y = sin(sin(X) .* X .* X - X);

% creating network
neurons = 25;
network = feedforwardnet(neurons, 'trainbfg');
network = configure(network, X, Y);

% splitting
trainInd = 1 : floor(n * 0.9);
valInd = floor(n * 0.9) + 1 : n;
testInd = [];
network.divideFcn = 'divideind';
network.divideParam.trainInd = trainInd;
network.divideParam.valInd = valInd;
network.divideParam.testInd = testInd;

% network initialization
network = init(network);

% network params
network.trainParam.epochs = 600;
network.trainParam.max_fail = 600;
network.trainParam.goal = 1e-8;

% training
network = train(network, X, Y);
view(network)

% testing
Result = sim(network, X);
sqrt(mse(Y(trainInd) - Result(trainInd)))
sqrt(mse(Y(valInd) - Result(valInd)))

figure;
hold on;
plot(X, Y, '-b');
plot(X, Result, '-r');
grid on;

figure;
plot(X, abs(Y - Result));
grid on;