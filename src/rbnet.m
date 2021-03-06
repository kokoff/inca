%% Set parameters of the RBF network
% 1. Center selection algorithm - kmeans = 1 for kmeans algorithm; random
% center selection otherwise
% 2. Number of centers/hidden nodes - 
% 3. Scaling coefficient for the standard deviation of each hidden layer 
% neuron - if coefficient = 1, use maximum distance between centers. 
% 4. Input data matrix
% 5. Target class vector
use_kmeans = use_kmeans;
m1 = m1;       % number of centres
std_coef = std_coef;
x = x;
t = t;

%% Train and evaluate Network
% 1. Preprocess inputs
x1 = mapstd(x);
x2 = processpca(x1, 0.02);
inputs = x2;


% 2. Split Data into training and test sets
N = size(x,2); % Calculate number of data points
training_set_part = 75;
perm_idx = randperm(N);
X1 = inputs(:, perm_idx(1:(N*training_set_part/100)));
D1 = t(:, perm_idx(1:(N*training_set_part/100)));
X2 = inputs(:, perm_idx((N*training_set_part/100)+1:end));
D2 = t(:, perm_idx((N*training_set_part/100)+1:end));


% 3. Select centers using either Kmeans algorithm or randomly select points from data set.
if use_kmeans
    [~,c] = kmeans(X1',m1);     % find m1 points as centres
    c = c';
else
    N = size(X1,2);             % calculate number of data points
    sample = randsample(N,m1);  % generate m1 random numbers
    c = X1(:,sample');          % sample m1 points from N as centres
end;


% 4. Calculate the distance from each of these centres to all of these data points. 
% Use the function pdist() to generate a matrix of distances, then select that part of
% the matrix containing the distances required.
N = size(X1,2);  % calculate number of data points
points = [X1 c]; % append the centres to the data
dist = squareform(pdist(points')); % calculate the distance matrix, from
                                   % every point or centre to
                                   % every other point or centre
distance = dist(1:N,N+1:N+m1); % extract the section with distances
                               % from points to centres
dc = dist(N+1:end,N+1:end); % extract the section with distances
                            % from centre to centre

                            
% 5. Find the maximum centre to centre distance times a coeeficient to use as the 
% standard deviation of the basis functions.
% The matrix �dc� will contain the distance from every centre (in rows) to every other centre (in
% columns). 
dmax = std_coef * max(max(dc)); % find the maximum of these

% 6. Calculate the matrix F composed of the individual basis functions responses to each
% data point.
% Take 'dmax' as an estimate of the standard deviation of the RBF
% nodes.
% The response from each RBF node to each data point depends on the distance
% between the node centre and the data point. The operation dist.^2 squares all these
% distances. The calculation of F is the exp() function applied to each element of the matrix.
F = exp((-m1/(dmax*dmax))*(distance.^2)); % using these distances, calculate the
                                          % response from each centre
 
 
% 7. Using the pseudo-inverse of F and the target data, find the weights.
pF = pinv(F); % calculate the pseudoinverse of F
W = pF * D1'; % use pF instead of F-1 to calculate the weights 
              % required to give the outputs D


% 8. Check how well the network classifies the training data
% Compare the calculated and desired outputs. Apply a threshold on the
% output to turn the low responses into a �no classification�.
Dcalc = F*W;            % calculated outputs based on F and W
Dclass = Dcalc > 0.5;   % and compare to find the bigger output
MSE1 = sum((D1 - Dcalc').^2)/numel(D1);


% 9. Evaluate performance on a separate set of data.
% Use the same basis functions (same number, centres, standard
% deviation) and weights, but recalculate the distances and therefore F.
% Calculate F but using the same centres
% and dmax. This means calculating a new distance matrix for X2
N = size(X2,2);         % calculate number of data points
points = [X2 c];        % append the centres to the data
dist = squareform(pdist(points')); % calculate the distance matrix, from
                                   % every point or centre to
                                   % every other point or centre
dist = dist(1:N,N+1:N+m1); % extract the section with distances
                           % from points to centres

                           
% 10. Once you have the distance matrix, calculate the new F matrix using the same expression, and
% then calculate classes using the same W as before:
F2 = exp((-m1/(dmax*dmax))*(dist.*dist)); % using new distances, calculate F2
Dcalc = F2*W;           % calculated outputs based on F2 and W
Dthresh = Dcalc > 0.5;  % and compare
MSE2 = sum((D2 - Dcalc').^2)/numel(D2);