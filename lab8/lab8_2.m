k1 = 0 : 0.025 : 1;
p1 = sin(4 * pi * k1);
t1 = -ones(size(p1));

k2 = 2.16 : 0.025 : 4.04;
p2 = cos(cos(k2) .* k2 .* k2 - k2);
t2 = ones(size(p2));

R = [1 4 7]; 
P = con2seq([repmat(p1, 1, R(1)), p2, repmat(p1, 1, R(2)), p2, repmat(p1, 1, R(3)), p2]);
T = con2seq([repmat(t1, 1, R(1)), t2, repmat(t1, 1, R(2)), t2, repmat(t1, 1, R(3)), t2]);

network = distdelaynet({0 : 4, 0 : 4}, 8, 'trainoss');
network.layers{1}.transferFcn = 'tansig';
network.layers{2}.transferFcn = 'tansig';
network = configure(network, P, T);
network.trainParam.epochs = 300;
network.trainParam.goal =  1.0e-5;
[Xs, Xi, Ai, Ts] = preparets(network, P, T); 
network = train(network, Xs, Ts, Xi, Ai);
view(network);

Result = sim(network, Xs, Xi, Ai);

figure
hold on;
grid on;
plot(cell2mat(Ts), '-b');
plot(cell2mat(Result), '-r');

test = zeros(1, numel(Result));
for i = 1 : numel(Result)
    if Result{i} >= 0
        test(i) = 1;
    else
        test(i) = -1;
    end
end

T = [repmat(t1, 1, R(1)), t2, repmat(t1, 1, R(2)), t2, repmat(t1, 1, R(3)), t2];
display(nnz(test == T(5 : end)))