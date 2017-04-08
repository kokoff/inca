figure; 
subplot(1,2,1);
plot(nodes, mtr.err_diff, '-bx', ...
    nodes, mtr.err0 + mtr.err1, '-rx');
legend('Difference', 'Total')
xlabel('Number of hidden nodes');
ylabel('% errors')

subplot(1,2,2);
hb = bar(nodes, [mtr.err0 ; mtr.err1]');
hold on;
xData = hb(1).XData+hb(1).XOffset;
h=errorbar(xData, mtr.err0, mtr.std_err0  ,'+m'); set(h,'linestyle','none')
hold on;
xData = hb(2).XData+hb(2).XOffset;
h=errorbar(xData, mtr.err1, mtr.std_err1  ,'+m'); set(h,'linestyle','none')

legend('Class0 err', 'Class1 err', 'Standart Deviation')
xlabel('Number of hidden nodes');
ylabel('% errors')

