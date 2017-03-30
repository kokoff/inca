nodes = [25, 30,35,40];
spread_coefitients = [0.8, 0.9];
reps = 1;

s = length(nodes) * length(spread_coefitients);
mean_mse = zeros(2, s);
mean_train_errors = zeros(2, s);
mean_test_errors = zeros(2, s);

count = 0;

for hiddenLayerSize = nodes
for spread_coef = spread_coefitients

fprintf('Hidden Nodes = %i; spread = %d * max distance', hiddenLayerSize, spread_coef)

MSEs = zeros(2,reps);
train_errors = zeros(2,reps);
test_errors = zeros(2,reps);

for i=1:reps

N = size(x,2);
perm_idx = randperm(N);

x2 = mapstd(x);
x1 = processpca(x2, 0.02);

training_set_part = 75;
X1 = x1(:, perm_idx(1:(N*training_set_part/100)));
D1 = t(:, perm_idx(1:(N*training_set_part/100)));
X2 = x1(:, perm_idx((N*training_set_part/100)+1:end));
D2 = t(:, perm_idx((N*training_set_part/100)+1:end));

% 1. Select random points from the data to act as centres of the basis functions.
% You can use the function randsample() to select a random sample from the
% training data.
N = size(X1,2);             % calculate number of data points


m1 = hiddenLayerSize;    % calculate number of centres
sample = randsample(N,m1);  % generate m1 random numbers
[~,c] = kmeans(X1',m1);     % sample m1 points from N as centres
c = c';

% 2. Calculate the distance from each of these centres to all of these data points.
% One way to do this is to append the selected centres to the complete data, use
% the function pdist() to generate a matrix of distances, then select that part of
% the matrix containing the distances required.
points = [X1 c]; % append the centres to the data
dist = squareform(pdist(points')); % calculate the distance matrix, from
                                   % every point or centre to
                                   % every other point or centre
distance = dist(1:N,N+1:N+m1); % extract the section with distances
                               % from points to centres
dc = dist(N+1:end,N+1:end); % extract the section with distances
                           % from centre to centre

% 3. Find the maximum centre to centre distance to use as the standard deviation of the
% basis functions.
% 4. Calculate the matrix F composed of the individual basis functions responses to each
% data point.
% Remember that you want to calculate a matrix with rows corresponding to data
% points and columns corresponding to centres (basis functions). You can still do
% this in one line!
% The matrix ‘dc’ will contain the distance from every centre (in rows) to every other centre (in
% columns). Take the maximum values as an estimate of the standard deviation of the RBF
% nodes. The response from each RBF node to each data point depends on the distance
% between the node centre and the data point. The operation dist.*dist squares all these
% distances. The calculation of F is the exp() function applied to each element of the matrix.
dmax = spread_coef * max(max(dc)); % find the maximum of these
F = exp((-m1/(dmax*dmax))*(distance.^2)); % using these distances, calculate the
                                          % response from each centre
 
 
% 5. Using the pseudo-inverse of F and the target data, find the weights.
% You can approximate W = F-1D once you have F (and its pseudo-inverse)
pF = pinv(F); % calculate the pseudoinverse of F
W = pF * D1'; % use pF instead of F-1 to calculate the weights 
% required to give the outputs D


% 6. Check how well the network classifies the training target data
% Compare the calculated and desired outputs. You may apply a threshold on the
% output to turn the low responses into a ‘no classification’.
Dcalc = F*W; % calculated outputs based on F and W
Dclass = Dcalc > 0.5; % and compare to find the bigger output
MSE = sum((D1 - Dcalc').^2)/numel(D1)

% 7. Evaluate performance on a separate set of data.
% To do this, you use the same basis functions (same number, centres, standard
% deviation) and weights, but you need to recalculate the distances and therefore F.
% To repeat this on a different set of data, you need to calculate F but using the same centres
% and dmax. This means calculating a new distance matrix. If the new data are in X2 (for
% example), you could use:
N = size(X2,2);         % calculate number of data points
points = [X2 c];        % append the centres to the data
dist = squareform(pdist(points')); % calculate the distance matrix, from
                                   % every point or centre to
                                   % every other point or centre
dist = dist(1:N,N+1:N+m1); % extract the section with distances
                           % from points to centres

% Once you have the distance matrix, you can calculate the new F matrix using the same expression, and
% then calculate classes using the same W as before:
F2 = exp((-m1/(dmax*dmax))*(dist.*dist)); % using new distances, calculate F2
Dcalc = F2*W; % calculated outputs based on F2 and W
Dthresh = Dcalc > 0.5; % and compare
MSE2 = sum((D2 - Dcalc').^2)/numel(D2)

plotconfusion(D1, Dclass', 'Training', D2, Dthresh', 'Test');

% plotconfusion([D2], [Dthresh']);

MSEs(:,i) =  [MSE, MSE2];

temp = D1-Dclass';
train_errors(:,i) = [sum(temp(temp>0))*100/numel(temp), abs(sum(temp(temp<0)))*100/numel(temp)];

temp = D2-Dthresh';
test_errors(:,i) = [sum(temp(temp>0))*100/numel(temp), abs(sum(temp(temp<0)))*100/numel(temp)];

end;
count = count+1;
mean_mse(:, count) = mean(MSEs,2);
mean_train_errors(:, count) = mean(train_errors, 2);
mean_test_errors(:, count) = mean(test_errors, 2);

end;
end;
% 8. Repeat the process for different random centres (basis functions) and numbers of
% centres. How does the classification ability of the network vary?