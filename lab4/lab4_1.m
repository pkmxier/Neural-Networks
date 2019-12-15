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

[trainInd1, testInd1] = dividerand(n1, 0.8, 0.2);
[trainInd2, testInd2] = dividerand(n2, 0.8, 0.2);
[trainInd3, testInd3] = dividerand(n3, 0.8, 0.2);

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

trainSet = [trainInd1, trainInd2 + n1, trainInd3 + n1 + n2];
testSet = [testInd1, testInd2 + n1, testInd3 + n1 + n2];
X = [X1, X2, X3];
Y = [Y1, Y2, Y3];
Points = [Points1, Points2 + length(X1), Points3 + length(X1) * 2];
Target = [Target1, Target2, Target3];

spread = 0.3;
network = newpnn([X(Points(trainSet)); Y(Points(trainSet))], Target(:, trainSet), spread);

view(network);

PredictedClasses = network([X(Points(trainSet)); Y(Points(trainSet))]);
TargetClasses = Target(:, trainSet);

fprintf('Количество точек в обучающем подмножестве: %d\n', length(trainSet));
fprintf('Количество правильно классифицированных точек: %d\n\n', ...
    sum(TargetClasses(TargetClasses == PredictedClasses)));

PredictedClasses = network([X(Points(testSet)); Y(Points(testSet))]);
TargetClasses = Target(:,testSet);

fprintf('Количество точек в обучающем подмножестве: %d\n', length(testSet));
fprintf('Количество правильно классифицированных точек: %d\n\n', ...
    sum(TargetClasses(TargetClasses == PredictedClasses)));

Region = -1.2 : 0.025 : 1.2;
[RegionX, RegionY] = meshgrid(Region, Region);

Ans = network([RegionX(:)'; RegionY(:)']);
Ans = max(0, min(1, Ans));
Ans = round(Ans * 10) * 0.1;

ctable = unique(Ans', 'rows');
cmap = zeros(length(RegionX), length(RegionX));

for i = 1 : size(ctable, 1)
    cmap(ismember(Ans', ctable(i, :), 'rows')) = i; 
end

figure
hold on;
axis([-1.2 1.2 -1.2 1.2]);
grid on;
image([-1.2, 1.2], [-1.2, 1.2], cmap); 
colormap(ctable);

figure
hold on;
axis([-1.2 1.2 -1.2 1.2]);
grid on;

spread = 0.1;
network = newpnn([X(Points(trainSet)); Y(Points(trainSet))], Target(:,trainSet), spread);
view(network);

Ans = network([RegionX(:)';RegionY(:)']);
Ans = max(0, min(1, Ans));
Ans = round(Ans * 10) * 0.1;

ctable = unique(Ans', 'rows');
cmap = zeros(length(RegionX), length(RegionX));

for i = 1 : size(ctable, 1)
    cmap(ismember(Ans', ctable(i, :), 'rows')) = i; 
end
image([-1.2, 1.2], [-1.2, 1.2], cmap); 
colormap(ctable);