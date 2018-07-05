iters = zeros(1, length(nodes)*length(std_coefitients));
count =0;
for i=nodes
    for j = std_coefitients
        count = count+1;
        iters(count) = i + 0.1 * j;
    end
end


figure(mseplot.Number)
name = 'mseplot';
filename = sprintf('figures/perf/%s_m(%d-%d)_e(%d-%d)', name, min(nodes), max(nodes), ...
                        10*min(std_coefitients), 10*max(std_coefitients));
 print(filename, '-dpng');
 
figure(errorbarplot.Number)
name = 'errorbar';
filename = sprintf('figures/perf/%s_m(%d-%d)_e(%d-%d)', name, min(nodes), max(nodes), ...
                        10*min(std_coefitients), 10*max(std_coefitients));
 print(filename, '-dpng');
 
 
figure(errorplot.Number)
name = 'errorplot';
filename = sprintf('figures/perf/%s_m(%d-%d)_e(%d-%d)', name, min(nodes), max(nodes), ...
                        10*min(std_coefitients), 10*max(std_coefitients));
 print(filename, '-dpng');
 
 clear name;
