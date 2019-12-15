h = 0.025;
Dots = Polar(h);

network = feedforwardnet([10 2 10], 'trainlm');
network = configure(network, Points, Points);
network = init(network);
network.trainParam.epochs = 100;
network.trainParam.goal = 1e-5;
network = train(network, Points, Points);
view(network);

Result = cell2mat(sim(network, Points));

plot3(Dots(1, :), Dots(2, :), Dots(3, :), '-r', ...
      Result(1, :), Result(2, :), Result(3, :), '-b', 'LineWidth', 2);