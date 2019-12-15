n3 = [-1 -1 +1 +1 +1 +1 +1 +1 -1 -1;
      -1 -1 +1 +1 +1 +1 +1 +1 +1 -1;
      -1 -1 -1 -1 -1 -1 -1 +1 +1 -1;
      -1 -1 -1 -1 -1 -1 -1 +1 +1 -1;
      -1 -1 -1 -1 -1 -1 -1 +1 +1 -1;
      -1 -1 -1 -1 +1 +1 +1 +1 -1 -1;
      -1 -1 -1 -1 +1 +1 +1 +1 -1 -1;
      -1 -1 -1 -1 -1 -1 -1 +1 +1 -1;
      -1 -1 -1 -1 -1 -1 -1 +1 +1 -1;
      -1 -1 -1 -1 -1 -1 -1 +1 +1 -1;
      -1 -1 +1 +1 +1 +1 +1 +1 +1 -1;
      -1 -1 +1 +1 +1 +1 +1 +1 -1 -1];
  
n1 = [-1 -1 -1 +1 +1 +1 +1 -1 -1 -1;
      -1 -1 -1 +1 +1 +1 +1 -1 -1 -1;
      -1 -1 -1 +1 +1 +1 +1 -1 -1 -1;
      -1 -1 -1 +1 +1 +1 +1 -1 -1 -1;
      -1 -1 -1 +1 +1 +1 +1 -1 -1 -1;
      -1 -1 -1 +1 +1 +1 +1 -1 -1 -1;
      -1 -1 -1 +1 +1 +1 +1 -1 -1 -1;
      -1 -1 -1 +1 +1 +1 +1 -1 -1 -1;
      -1 -1 -1 +1 +1 +1 +1 -1 -1 -1;
      -1 -1 -1 +1 +1 +1 +1 -1 -1 -1;
      -1 -1 -1 +1 +1 +1 +1 -1 -1 -1;
      -1 -1 -1 +1 +1 +1 +1 -1 -1 -1;];
  
n0 = [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1;
      -1 -1 -1 +1 +1 +1 +1 -1 -1 -1;
      -1 -1 +1 +1 +1 +1 +1 +1 -1 -1;
      -1 +1 +1 +1 -1 -1 +1 +1 +1 -1;
      -1 +1 +1 +1 -1 -1 +1 +1 +1 -1;
      -1 +1 +1 +1 -1 -1 +1 +1 +1 -1;
      -1 +1 +1 +1 -1 -1 +1 +1 +1 -1;
      -1 +1 +1 +1 -1 -1 +1 +1 +1 -1;
      -1 +1 +1 +1 -1 -1 +1 +1 +1 -1;
      -1 -1 +1 +1 +1 +1 +1 +1 -1 -1;
      -1 -1 -1 +1 +1 +1 +1 -1 -1 -1;
      -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];

       
P = [n3(:), n1(:), n0(:)];
network = newhop(P);

n_iterations = 600;
Result = sim(network, {1 n_iterations}, {}, n3(:));
Result = reshape(Result{n_iterations}, 12, 10);
Result(Result >=0 ) = 2;
Result(Result < 0 ) = 1;
view(network)

figure('Name', 'Цифра 3');
map = [1, 1, 1; 0, 0, 0];
image(Result); colormap(map)
axis off
axis image

r = rand([12,10]);
M = 0.2;
in = n1;
for i = 1 : 12
    for j = 1 : 10
        if r(i,j) < M
            in(i,j) = -in(i,j);
        end
    end
end

Result = reshape(in, 12, 10);
Result(Result >= 0) = 2;
Result(Result < 0) = 1;
map = [1, 1, 1; 0, 0, 0];
figure('Name', 'Цифра 1, зашумленная на 20%');
image(Result); colormap(map)
axis off
axis image

n_iterations = 600;
Result = sim(network, {1 n_iterations},  {}, in(:));
Result = reshape(Result{n_iterations}, 12, 10);
Result(Result >=0 ) = 2;
Result(Result < 0 ) = 1;
map = [1, 1, 1; 0, 0, 0];
figure('Name', 'Цифра 1')
image(Result); colormap(map)
axis off
axis image

r = rand([12,10]);
M = 0.3;
in = n0;
for i=1 : 12
    for j = 1 : 10
        if r(i,j) < M
            in(i,j) = -in(i,j);
        end
    end
end

Result = reshape(in, 12, 10);
Result(Result >= 0) = 2;
Result(Result < 0) = 1;
map = [1, 1, 1; 0, 0, 0];
figure('Name', 'Цифра 0, зашумленная на 30%');
image(Result); colormap(map)
axis off
axis image

n_iterations = 600;
Result = sim(network, {1 n_iterations},  {}, in(:));
Result = reshape(Result{n_iterations}, 12, 10);
Result(Result >=0 ) = 2;
Result(Result < 0 ) = 1;
map = [1, 1, 1; 0, 0, 0];
figure;
image(Result); colormap(map)
axis off
axis image