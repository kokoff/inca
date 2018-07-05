function [out] = search(nodes, x, t, reps)

% Number of times each architecture is evaluated
if nargin <4
    reps = 50;
end

% Number of architectures to be evaluated
s = size(nodes, 2);

% Mean performance measures for each architecture
meanPerformances = zeros(4, s);
varPerformances = zeros(4, s);
confusion = zeros(3, s);

% Number of architectures evaluated so far
count = 1;

% Create figure and title of plot 
titl = createTitle(nodes);

figures = findobj('type','figure','name',titl);
close(figures(:));
    for i = 1:2
        figures(i) =  figure('Name', titl);
    end



for i=nodes
hiddenLayerSize = i';

    % Initialise temporary numeric arrays for performances
    temp = zeros(4, reps);
    conf = zeros(3, reps);

    for j=1:reps
        % Call script generated from NN toolbox
        getNet;
        
        temp(:,j) = [trainPerformance, valPerformance, testPerformance, performance]';
        
        val_errors =  valTargets - round(y);
        test_errors = testTargets - round(y);
        conf(1:2,j) = [abs(sum( [val_errors(val_errors == -1), test_errors(test_errors == -1)] )) * 100 / numel([valTargets(~isnan(valTargets)), testTargets(~isnan(testTargets))]),...
                       abs(sum( [val_errors(val_errors == 1), test_errors(test_errors == 1)] )) * 100 / numel([valTargets(~isnan(valTargets)), testTargets(~isnan(testTargets))])];
        conf(3,j) = abs(conf(1,j) - conf(2,j));
    end
    
    meanPerformances(:, count) = mean(temp,2);
    varPerformances(:, count) = std(temp,0,2);
    confusion(:,count) = mean(conf,2);
    
    % Plot Mean and Standard Deviation
    plotPerformances(nodes, meanPerformances, varPerformances, confusion, count, figures);

    
    count = count + 1;
end

% Output performances
out = table(nodes', ...
    [meanPerformances(1,:)', varPerformances(1,:)'],... 
    [meanPerformances(2,:)', varPerformances(2,:)'],...
    [meanPerformances(3,:)', varPerformances(3,:)'],...
    [meanPerformances(4,:)', varPerformances(4,:)'],...
    confusion(1,:)', confusion(2,:)', confusion(3,:)', ...
    ones(size(nodes,2)) * reps,...
        'VariableNames', {'Architecture', 'Training', 'Validation', 'Test', 'Total', 'Class0Err', 'Class1Err', 'ErrDiff', 'Runs'});

    
filename = 'Architectures.xlsx';
if exist(filename, 'file') == 2
    [~, sheets] = xlsfinfo(filename);
    numOfSheets = numel(sheets);
else
    numOfSheets = 0;
end
writetable(out,filename ,'Sheet',numOfSheets+1);
end


function  plotPerformances(nodes ,performances, varPerformances, confusion, count, figures)
% Select figure

%title(titl);

% Plot performances
% subplot(3,2,1);
% errorbar(nodes(end,1:count), performances(1,1:count), varPerformances(1,1:count), '-gx'); hold on;
% title('Train');
% subplot(3,2,2);
% errorbar(nodes(end,1:count), performances(2,1:count), varPerformances(2,1:count), '-bx'); hold on;
% title('Validation');
% subplot(3,2,3);
% errorbar(nodes(end,1:count), performances(3,1:count), varPerformances(3,1:count), '-rx'); hold on;
% title('Test');
% subplot(3,2,4);
% errorbar(nodes(end,1:count), performances(4,1:count), varPerformances(4,1:count), '-yx');
% title('Total');
% set(gca,'yscale','log');

figure(figures(1));
plot(nodes(end,1:count), performances(1,1:count), '-g'); hold on;
plot(nodes(end,1:count), performances(2,1:count), '-bx'); hold on;
plot(nodes(end,1:count), performances(3,1:count), '-rx'); hold on;
plot(nodes(end,1:count), performances(4,1:count), '-y');
title('Performances');
legend('Train', 'Val', 'Test', 'Perf');
set(gca,'yscale','log');

figure(figures(2));
plot(nodes(end,1:count), confusion(1, 1:count), '-bx',...
     nodes(end,1:count), confusion(2, 1:count), '-rx',...
     nodes(end,1:count), confusion(3, 1:count), '-gx');
legend('Class0', 'Class1', 'Difference');
%set(gca,'yscale','log');
title('Class Error Ratio');



end


function titl = createTitle(nodes)
%Set title of plot
titl = 'Architecture  ';
for i=1:size(nodes, 1)
    titl = strcat(titl, ' (',num2str(min(nodes(i,:))));
    if min(nodes(i,:)) ~= max(nodes(i,:))
        titl = strcat(titl, ':', num2str(nodes(i,2) -  nodes(i,1)));
        titl = strcat(titl, ':', num2str(max(nodes(i,:))));
        
    end
    titl = strcat(titl, ')');
end
end
