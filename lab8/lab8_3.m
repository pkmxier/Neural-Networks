a = 0;
b = 10;
h = 0.01;
n = (b - a) / h + 1;

u = zeros(1, n);
u(1) = sin(3);
y = zeros(1, n);

for i = 2 : n
    t = a + (i - 1) * h;
    y(i) = y(i - 1) ./ (1 + y(i - 1) .^ 2) + u(i - 1) .^ 3;
    u(i) = sin(t .* t - 10 * t + 3);
end

D = 3;
trainSize = 700;
validationSize = 200;
testSize = 97;

trainInd = 1 : trainSize;
valInd = trainSize + 1 : trainSize + validationSize;
testInd = trainSize + validationSize + 1 : trainSize + validationSize + testSize;

network = narxnet(1 : 3, 1, 8);
network.trainFcn = 'trainlm';
network.divideFcn = 'divideind';
network.divideParam.trainInd = trainInd;
network.divideParam.valInd = valInd;
network.divideParam.testInd = testInd;
network.trainParam.epochs = 600;
network.trainParam.max_fail = 600;
network.trainParam.goal = 1e-5;

[Xs, Xi, Ai, Ts] = preparets(network, con2seq(u), {}, con2seq(y)); 

network = train(network, Xs, Ts, Xi, Ai);
view(network);

Result = cell2mat(sim(network, Xs, Xi));

t = a : h : b;

figure
subplot(3, 1, 1)
plot(t, u, '-b'),grid
ylabel('”правл€ющий сигнал')
subplot(3, 1, 2)
plot(t, y, '-b', t, [y(1:D) Result], '-r'), grid
ylabel('¬ходной сигнал')
subplot(3, 1, 3)
plot(a + D * h : h : b, y(D + 1 : end) - Result), grid
ylabel('ќшибка')
xlabel('t')