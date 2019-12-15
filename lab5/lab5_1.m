k1 = 0 : 0.025 : 1;
p1 = sin(4 * pi * k1);
t1 = -ones(size(p1));

k2 = 2.16 : 0.025 : 4.04;
p2 = cos(cos(k2) .* k2 .* k2 - k2);
t2 = ones(size(p2));

R = [1 4 7]; 
P = con2seq([repmat(p1, 1, R(1)), p2, repmat(p1, 1, R(2)), p2, repmat(p1, 1, R(3)), p2]);
T = con2seq([repmat(t1, 1, R(1)), t2, repmat(t1, 1, R(2)), t2, repmat(t1, 1, R(3)), t2]);

network = layrecnet(1 : 2, 20, 'trainoss');
network.layers{1}.transferFcn = 'tansig';
network.layers{2}.transferFcn = 'tansig';
network = configure(network, P, T);

[p, Xi, Ai, t] = preparets(network, P, T);

network.trainParam.epochs = 100;
network.trainParam.goal = 1e-5;

network = train(network, p, t, Xi, Ai);
view(network);
Result = sim(network, p, Xi, Ai);

figure
hold on;

Predict = plot(cell2mat(Result), 'r');
Target = plot(cell2mat(t), 'b');
legend([Target, Predict], 'Эталон', 'Прогноз');

test = zeros(0, length(Result));
for i=1 : length(Result)
    if Result{i} >= 0
        test(i) = 1;
    else 
        test(i) = -1;
    end
end

fprintf('Количество точек в обучающем подмножестве: %d\n', length(T)-3);
T = [repmat(t1, 1, R(1)), t2, repmat(t1, 1, R(2)), t2, repmat(t1, 1, R(3)), t2];
fprintf('Количество правильно классифицированных точек: %d\n', nnz(test == T(3 : end)));

R = [1 1 7]; 
P = con2seq([repmat(p1, 1, R(1)), p2, repmat(p1, 1, R(2)), p2, repmat(p1, 1, R(3)), p2]);
T = con2seq([repmat(t1, 1, R(1)), t2, repmat(t1, 1, R(2)), t2, repmat(t1, 1, R(3)), t2]);

network = layrecnet(1 : 2, 20, 'trainoss');
network.layers{1}.transferFcn = 'tansig';
network.layers{2}.transferFcn = 'tansig';
network = configure(network, P, T);

[p, Xi, Ai, t] = preparets(network, P, T);

network.trainParam.epochs = 100;
network.trainParam.goal = 1e-5;

network = train(network, p, t, Xi, Ai);
Result = sim(network, p, Xi, Ai);

figure
hold on;

Predict = plot(cell2mat(Result), 'r');
Target = plot(cell2mat(t), 'b');
legend([Target, Predict], 'Эталон', 'Прогноз');

test = zeros(0, length(Result));
for i = 1 : length(Result)
    if Result{i} >= 0
        test(i) = 1;
    else 
        test(i) = -1;
    end
end


fprintf('Количество точек в обучающем подмножестве: %d\n', length(T) - 3);
T = [repmat(t1, 1, R(1)), t2, repmat(t1, 1, R(2)), t2, repmat(t1, 1, R(3)), t2];
fprintf('Количество правильно классифицированных точек: %d\n', nnz(test == T(3 : end)));