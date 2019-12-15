X = [0 1.5; 0 1.5];
clusters = 8;
points = 10;
deviation = 0.1;
Points = nngenc(X, clusters, points, deviation);

network = newsom(X, [2 4]);
network.trainParam.epochs = 150;
network = selforgmap([2 4],'topologyFcn','hextop','distanceFcn','linkdist');
network = configure(network, X);

network = train(network, Points);
view(network)

Dots = zeros(2, 5) + 2 * rand(2, 5);
res = vec2ind(sim(network, Dots));
display(res);

size = 30;
figure
hold on;
grid on;
scatter(Points(1, :), Points(2, :), size, [0 1 0], 'filled');
scatter(network.IW{1}(:, 1), network.IW{1}(:, 2), size, [0 0 1], 'filled');
scatter(Dots(1, :), Dots(2, :), size, [1 0 0], 'filled');