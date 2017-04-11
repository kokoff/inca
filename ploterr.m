nodes = mtr.nodes;
reps = mtr.reps;
std_coefitients = mtr.std_coefitients;

close all;

x1ticklabels = cell(1, length(nodes)*length(std_coefitients));
x2ticklabels = cell(1, length(nodes)*length(std_coefitients));

count =0;
for i=nodes
    for j = std_coefitients
        count = count+1;
        x1ticklabels{count} = sprintf('%d', i);
        x2ticklabels{count} = sprintf('%2.1f', j);
    end
end

%% Plot MSE
mseplot = figure(17002);
ax2 = axes('XAxisLocation','top',...
           'YAxisLocation','right',...
           'XColor','k','YColor','k','ActivePositionProperty','OuterPosition');
xlabel(ax2, 'Spread coefficient \epsilon');
yticklabels([]);

data=rand(10,2);
line(1:count, 1:count, 'Color', 'k','Parent', ax2);

xticklabels(x2ticklabels)

ax1 = axes('Position',get(ax2,'Position'),...
           'Color','none',... % necessary, or you do not see the second graph
           'XColor','k','YColor','k');
xlabel(ax1, '1st Axis');

plot(1:count, mtr.mse, '-b', 1:count, mtrr.mse, '--r');
hold on;
h=errorbar(1:count, mtr.mse, mtr.std_mse  ,'b'); set(h,'linestyle','none')

xlabel(ax1, 'Number of centres m');

myString = sprintf('Mean MSE value out of %d runs', reps);
ylabel(myString);
legend('Test', 'Train', 'Test Std')
xticklabels(x1ticklabels)
set(ax1, 'YScale', 'log')

%% Plot Error Plot
errorplot = figure(17000);

ax2 = axes('XAxisLocation','top',...
           'YAxisLocation','right',...
           'XColor','k','YColor','k','ActivePositionProperty','OuterPosition');
xlabel(ax2, 'Spread coefficient \epsilon');
yticklabels([]);

data=rand(10,2);
line(1:count, 1:count, 'Color', 'k','Parent', ax2);

xticklabels(x2ticklabels)

ax1 = axes('Position',get(ax2,'Position'),...
           'Color','none',... % necessary, or you do not see the second graph
           'XColor','k','YColor','k');
xlabel(ax1, '1st Axis');



plot(1:count, mtr.err_diff, '-bx', ...
    1:count, mtr.err0 + mtr.err1, '-rx');
legend('Mean absolute difference', 'Total')
ylabel('% errors')
xlabel(ax1, 'Number of centres m');
xticklabels(x1ticklabels)

%% Plot Error Bar
errorbarplot = figure(17001);

ax2 = axes('XAxisLocation','top',...
           'YAxisLocation','right',...
           'XColor','k','YColor','k','ActivePositionProperty','OuterPosition');
xlabel(ax2, 'Spread coefficient \epsilon');
yticklabels([]);

data=rand(10,2);
line(1:count, 1:count, 'Color', 'k','Parent', ax2);



ax1 = axes('Position',get(ax2,'Position'),...
           'Color','none',... % necessary, or you do not see the second graph
           'XColor','k','YColor','k');
xlabel(ax1, '1st Axis');


hb = bar(1:count, [mtr.err0 ; mtr.err1]');
hold on;
xData = hb(1).XData+hb(1).XOffset;
h=errorbar(xData, mtr.err0, mtr.std_err0  ,'+m'); set(h,'linestyle','none')
hold on;
xData = hb(2).XData+hb(2).XOffset;
h=errorbar(xData, mtr.err1, mtr.std_err1  ,'m'); set(h,'linestyle','none')

legend('Class0 err', 'Class1 err', 'Standart Deviation')
xlabel('Number of hidden nodes');
ylabel('% errors')
xlabel(ax1, 'Number of centres m');
xticklabels(x1ticklabels)
xticklabels(ax2,x2ticklabels)
