Dots = Ellipse(0.7, 0.2, -pi / 6, 0, -0.1, 0.025);

Points = con2seq(Dots);
network = feedforwardnet(1, 'trainlm');
network.layers{1}.transferFcn = 'purelin';
network = configure(network, Points, Points);
network = init(network);
network.trainParam.epochs = 100;
network.trainParam.goal = 1e-5;
network = train(network, Points, Points);
display(network);
view(network);

Result = cell2mat(sim(network, Points));

figure
plot(Dots(1, :), Dots(2, :), '-r', Result(1, :), Result(2, :), '-b', 'LineWidth', 2);