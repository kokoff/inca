use_kmeans = 1;
nodes = [20];
std_coefitients = [0.8];
reps = 1;

% Create structure to hold mean training results
s = length(nodes) * length(std_coefitients);
mtrr.mse = zeros(1, s);
mtrr.std_mse = zeros(1, s);
mtrr.err0 = zeros(1, s);
mtrr.std_err0 = zeros(1, s);
mtrr.err1 = zeros(1, s);
mtrr.std_err1 = zeros(1, s);
mtrr.err_diff = zeros(1, s);
mtrr.std_err_diff = zeros(1, s);
mtrr.nodes = nodes;
mtrr.reps = reps;
mtrr.std_coefitients = std_coefitients;

% Create structure to hold mean test results
mtr.mse = zeros(1, s);
mtr.std_mse = zeros(1, s);
mtr.err0 = zeros(1, s);
mtr.std_err0 = zeros(1, s);
mtr.err1 = zeros(1, s);
mtr.std_err1 = zeros(1, s);
mtr.err_diff = zeros(1, s);
mtr.std_err_diff = zeros(1, s);
mtr.nodes = nodes;
mtr.reps = reps;
mtr.std_coefitients = std_coefitients;

% Create structure to hold intermediate training results
train_res.mse = zeros(1, reps);
train_res.err0 = zeros(1, reps);
train_res.err1 = zeros(1, reps);
train_res.err_diff = zeros(1, reps);

% Create structure to hold intermediate test results
test_res.mse = zeros(1, reps);
test_res.err0 = zeros(1, reps);
test_res.err1 = zeros(1, reps);
test_res.err_diff = zeros(1, reps);

count = 1;

for m1 = nodes
for std_coef = std_coefitients

    fprintf('Hidden Nodes = %i; std coefficient = %5.3f\n', m1, std_coef)

    for i=1:reps

        rbnet % Create, train and evalueate network

        temp = D1-Dclass';
        train_res.mse(i) = MSE1;
        train_res.err0(i) = sum(temp(temp>0))*100/numel(temp);
        train_res.err1(i) = abs(sum(temp(temp<0)))*100/numel(temp);
        train_res.err_diff(i) = abs(train_res.err0(i) - train_res.err1(i));
        
        temp = D2-Dthresh';
        test_res.mse(i) = MSE2;
        test_res.err0(i) = sum(temp(temp>0))*100/numel(temp);
        test_res.err1(i) = abs(sum(temp(temp<0)))*100/numel(temp);
        test_res.err_diff(i) = abs(test_res.err0(i) - test_res.err1(i));
        
        plotconfusion(D1, Dclass', 'Training', D2, Dthresh', 'Test');
        fprintf('MSE1 = %6.4f; MSE2 = %6.4f; Err0 = %4.2f; Err1 = %4.2f \n', MSE1, MSE2, test_res.err0(i), test_res.err1(i));

    end;
    
    mtrr.mse(count) = mean(train_res.mse);
    mtrr.std_mse(count) = std(train_res.mse);
    mtrr.err0(count) = mean(train_res.err0);
    mtrr.std_err0(count) = std(train_res.err0);
    mtrr.err1(count) = mean(train_res.err1);
    mtrr.std_err1(count) = std(train_res.err1);
    mtrr.err_diff(count) = mean(train_res.err_diff);
    mtrr.std_err_diff(count) = std(train_res.err_diff);

    mtr.mse(count) = mean(test_res.mse);
    mtr.std_mse(count) = std(test_res.mse);
    mtr.err0(count) = mean(test_res.err0);
    mtr.std_err0(count) = std(test_res.err0);
    mtr.err1(count) = mean(test_res.err1);
    mtr.std_err1(count) = std(test_res.err1);
    mtr.err_diff(count) = mean(test_res.err_diff);
    mtr.std_err_diff(count) = std(test_res.err_diff);
    
    count = count+1;
end;
end;
clear temp s count 