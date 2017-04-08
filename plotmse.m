figure; 
plot(nodes, mtr.mse, '-b', nodes, mtrr.mse, '--r');
hold on;
h=errorbar(nodes, mtr.mse, mtr.std_mse  ,'b'); set(h,'linestyle','none')
set(gca, 'YScale', 'log')

xlabel('Number of hidden nodes');
myString = sprintf('Mean MSE value out of %d runs', reps);
ylabel(myString);
legend('Test', 'Train', 'Test Std')