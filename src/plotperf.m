nodes = mtr.nodes;
reps = mtr.reps;
std_coefitients = mtr.std_coefitients;

x1ticklabels = cell(1, length(nodes)*length(std_coefitients));
close all;
count =0;
for i=nodes
    for j = std_coefitients
        count = count+1;
        x1ticklabels{count} = sprintf('m=%d,e=%2.1f', i,j);
    end
end

xaxis = std_coefitients;
XLABEL = 'Number of hidden nodes';
XLABEL = 'Spread coefficient \epsilon';

% MSE plot
mseplot = figure(17002); 
plot(xaxis, mtr.mse, '-b', xaxis, mtrr.mse, '--r');
hold on;
h=errorbar(xaxis, mtr.mse, mtr.std_mse  ,'b'); set(h,'linestyle','none')
set(gca, 'YScale', 'log')


xlabel(XLABEL);
myString = sprintf('Mean MSE value out of %d runs', reps);
ylabel(myString);
legend('Test', 'Train', 'Test Std')
% xticklabels(x1ticklabels)
% xtickangle(20)


% Error plot
errorplot = figure(17000); 
plot(xaxis, mtr.err_diff, '-bx', ...
    xaxis, mtr.err0 + mtr.err1, '-rx');
legend('Mean absolute difference', 'Total')
xlabel(XLABEL);
ylabel('% errors')

% xticklabels(x1ticklabels)
% xtickangle(20)

% Error bar
errorbarplot = figure(17001);
hb = bar(xaxis, [mtr.err0 ; mtr.err1]');
hold on;
xData = hb(1).XData+hb(1).XOffset;
h=errorbar(xData, mtr.err0, mtr.std_err0  ,'+m'); set(h,'linestyle','none')
hold on;
xData = hb(2).XData+hb(2).XOffset;
h=errorbar(xData, mtr.err1, mtr.std_err1  ,'m'); set(h,'linestyle','none')

legend('Class0 err', 'Class1 err', 'Standart Deviation')
xlabel(XLABEL);
ylabel('% errors')
% xticklabels(x1ticklabels)
% xtickangle(20)
