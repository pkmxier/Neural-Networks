Points = [1.2 -1.3 -0.5 -1.1 -1.2 -0.1 0.6 1.1 0.5 -1.5 0 1.2
          0.8 -0.8 0.5 0.6 0.4 0.8 1.2 -0.5 -1 0.7 -0.1 0.3];
Target = [-1 -1 1 1 -1 -1 1 -1 -1 -1 -1 -1];
Target_i = Target;
Target_i(Target_i == 1) = 2;
Target_i(Target_i == -1) = 1;
Target_i = ind2vec(Target_i);

network = lvqnet(12, 0.1);
network = configure(network, Points, Target_i);
view(network)
network.IW{1,1}
network.LW{2,1}

network.trainParam.epochs = 300;
network = train(network, Points, Target_i);

h = 0.1;
[X,Y] = meshgrid(-1.5 : h : 1.5, -1.5 : h : 1.5);
Result = sim(network, [X(:)'; Y(:)']);
Result = vec2ind(Result) - 1;

figure
plotpv([X(:)'; Y(:)'], Result);
point = findobj(gca, 'type', 'line');
set(point, 'Color', 'g');
hold on;
plotpv(Points, max(0, Target));
hold off;