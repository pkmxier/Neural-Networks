h = 0.025;
Dots = Polar(h);

Points = con2seq(Dots);
network = feedforwardnet([10 1 10], 'trainlm');
network = configure(network, Points, Points);
network = init(network);
network.trainParam.epochs = 300;
network.trainParam.goal = 1e-5;
network = train(network, Points, Points);
view(network);

Result = cell2mat(sim(network, Points));

figure
plot(Dots(1, :), Dots(2, :), '-r', Result(1, :), Result(2, :), '-b', 'LineWidth', 2);