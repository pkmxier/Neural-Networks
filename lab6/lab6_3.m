X = [0 1.5; 0 1.5];
clusters = 8;
points = 10;
deviation = 0.1;
Points = nngenc(X, clusters, points, deviation);

network = selforgmap([2 4], 'topologyFcn', 'hextop', 'distanceFcn', 'linkdist');
network = configure(network, X);
view(network);

network.inputWeights{1,1}.learnParam.init_neighborhood = 3;
network.inputWeights{1,1}.learnParam.steps = 100;
network.trainParam.epochs = 150;
network = train(network, Points);

Dots = zeros(2, 5) + 2 * rand(2, 5);
res = vec2ind(sim(network, Dots));

figure;
hold on;
grid on;
scatter(Points(1, :), Points(2, :), 5, [0 1 0], 'filled');
scatter(network.IW{1}(:, 1), network.IW{1}(:, 2), 5, [0 0 1], 'filled');
scatter(Dots(1, :), Dots(2, :), 5, [1 0 0], 'filled');
plotsom(network.IW{1, 1}, network.layers{1}.distances);
N = 20;
T = -1.5 * ones(2, N) + 3 * rand(2, N);

figure;
hold on;
grid on;
plot(T(1,:), T(2,:), '-V', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 7), grid

network = selforgmap(N);
network = configure(network, T);
view(network);
network.divideFcn = '';
network.trainParam.epochs = 600;
network = train(network, T);

figure;
hold on;
grid on;
plotsom(network.IW{1,1}, network.layers{1}.distances);
plot(T(1,:), T(2,:), 'V', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 7), grid