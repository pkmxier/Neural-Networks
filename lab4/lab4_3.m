a = 1;
b = 4.5;
h = 0.01;
n = (b - a) / h + 1;

X = a : h : b;
Y = sin(sin(X) .* X .* X - X);
Xtest = b * 0.9 : h : b;
Ytest = sin(sin(Xtest) .* Xtest .* Xtest - Xtest);

spread = h;

network = newgrnn(X, Y, spread);
view(network);

ResultTrain = sim(network, X);
ResultTest = sim(network, Xtest);
fprintf('Ошибка обучения: %d\n', sqrt(mse(Y - ResultTrain)));

figure
plot(Xtest, Ytest, 'r');
hold on;
plot(Xtest, ResultTest, '-b');
grid on;

figure
plot(Xtest, abs(Ytest - ResultTest), 'r');
grid on;


[trainInd, testInd] = dividerand(n, 0.8, 0.2);

network = newgrnn(X(trainInd), Y(trainInd), spread);
Result = sim(network, X);

figure
plot(X, Y, 'r');
hold on;
plot(X, Result, '--b');
grid on;

figure
plot(X, abs(Y - Result), 'r');
grid on;