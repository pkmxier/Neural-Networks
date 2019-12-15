% generating classes points
h = 0.025;
[X1, Y1] = Ellipse(0.2, 0.2, 0, 0.25, -0.25, h);
[X2, Y2] = Ellipse(0.7, 0.5, -pi/3, 0, 0, h);
[X3, Y3] = Ellipse(1, 1, 0, 0, 0, h);

Permutation = randperm(length(X1));

n1 = 60;
Points1 = Permutation(1 : n1);
Target1 = zeros(3, n1);
Target1(1,:) = ones(1, n1);

n2 = 100;
Points2 = Permutation(1 : n2);
Target2 = zeros(3, n2);
Target2(2,:) = ones(1, n2);


n3 = 120;
Points3 = Permutation(1 : n3);
Target3 = zeros(3, n3);
Target3(3,:) = ones(1, n3);

% splitting data
[trainInd1, valInd1, testInd1] = dividerand(length(Points1), 0.7, 0.2, 0.1);
[trainInd2, valInd2, testInd2] = dividerand(length(Points2), 0.7, 0.2, 0.1);
[trainInd3, valInd3, testInd3] = dividerand(length(Points3), 0.7, 0.2, 0.1);

% plotting ellipses
figure

Class1 = plot(X1, Y1, '-r', 'LineWidth', 2);
hold on;
Train1 = plot(X1(Points1(trainInd1)), Y1(Points1(trainInd1)), 'or', ...
    'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r', 'MarkerSize', 7);
hold on;
Validation1 = plot(X1(Points1(valInd1)), Y1(Points1(valInd1)), 'rV', ...
    'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'c', 'MarkerSize', 7);
hold on;
Test1 = plot(X1(Points1(testInd1)), Y1(Points1(testInd1)), 'rs', ...
    'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'c', 'MarkerSize', 7);
hold on;

Class2 = plot(X2, Y2, '-g', 'LineWidth', 2);
hold on;
Train2 = plot(X2(Points2(trainInd2)), Y2(Points2(trainInd2)), 'og', ...
    'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 7);
hold on;
Validation2 = plot(X2(Points2(valInd2)), Y2(Points2(valInd2)), 'gV', ...
    'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'c', 'MarkerSize', 7);
hold on;
Test2 = plot(X2(Points2(testInd2)), Y2(Points2(testInd2)), 'gs', ...
    'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'c', 'MarkerSize', 7);
hold on;

Class3 = plot(X3, Y3, '-b', 'LineWidth', 2);
hold on;
Train3 = plot(X3(Points3(trainInd3)), Y3(Points3(trainInd3)), 'ob', ...
    'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'b', 'MarkerSize', 7);
hold on;
Validation3 = plot(X3(Points3(valInd3)), Y3(Points3(valInd3)), 'bV', ...
    'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'c', 'MarkerSize', 7);
hold on;
Test3 = plot(X3(Points3(testInd3)), Y3(Points3(testInd3)), 'bs', ...
    'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'c', 'MarkerSize', 7);
hold on;
grid on;

% generating train set
trainSet = [trainInd1, trainInd2 + n1, trainInd3 + n1 + n2,...
            valInd1, valInd2 + n1, valInd3 + n1 + n2, ...
            testInd1, testInd2 + n1, testInd3 + n1 + n2];


% creating network
neurons = 20;
network = feedforwardnet(neurons);
network = configure(network, [-1.2 1.2; 0 1]);
network.layers{:}.transferFcn = 'tansig';
network.trainFcn = 'trainrp';

% dividing train set
network.divideFcn = 'divideind';

trnInd = length(trainInd1) + length(trainInd2) + length(trainInd3);
tstInd = length(valInd1) + length(valInd2) + length(valInd3);
proInd = length(testInd1) + length(testInd2) + length(testInd3);

network.divideParam.trainInd = 1 : trnInd;
network.divideParam.valInd = trnInd + (1 : tstInd);
network.divideParam.testInd = tstInd + trnInd + (1 : proInd);

% initializing network with default values
network = init(network);

% setting training parameters
network.trainParam.epochs = 1500;
network.trainParam.max_fail = 1500;
network.trainParam.goal = 1e-5;

% training
Points = [Points1, Points2 + length(X1), Points3 + length(X1) * 2];
X = [X1, X2, X3];
Y = [Y1, Y2, Y3];
Target = [Target1, Target2, Target3];

[network, tr] = train(network, ...
    [X(Points(trainSet)); Y(Points(trainSet))], Target(:,trainSet));

% network structue
display(network)
view(network)

% network train out
trainInd = [trainInd1, trainInd2 + 60, trainInd3 + 160];
valInd = [valInd1, valInd2 + 60, valInd3 + 160];
testInd = [testInd1, testInd2 + 60, testInd3 + 160];

Ans = network([X(Points(trainInd)); Y(Points(trainInd))]) >= 0.5;
fprintf('Количество точек в обучающем подмножестве: %d\n', ...
    length(trainInd));
fprintf('Количество правильно классифицированных точек: %d\n\n', ...
    sum((sum(Target(:, trainInd) == Ans)) == 3));

Ans = network([X(Points(valInd)); Y(Points(valInd))]) >= 0.5;
fprintf('Количество точек в контрольном подмножестве: %d\n', ...
    length(valInd));
fprintf('Количество правильно классифицированных точек: %d\n\n', ...
    sum((sum(Target(:, valInd) == Ans)) == 3));

Ans = network([X(Points(testInd)); Y(Points(testInd))]) >= 0.5;
fprintf('Количество точек в тестовом подмножестве: %d\n', ...
    length(testInd));
fprintf('Количество правильно классифицированных точек: %d\n\n', ...
    sum((sum(Target(:, testInd) == Ans)) == 3));

% testing on selected region
Region = -1.2 : 0.025 : 1.2;
[RegionX, RegionY] = meshgrid(Region);

Ans = network([RegionX(:)'; RegionY(:)'])';
cmap = unique(Ans, 'rows');
Result = [];

for i = 1 : length(Ans)
    Result = [Result, find(ismember(cmap, Ans(i,:), 'rows') == 1)];
end

figure;
Result = reshape(Result, length(RegionX), length(RegionY));
image(RegionX(:), RegionY(:), Result);
colormap(cmap);