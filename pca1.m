x1 = mapstd([x(1:4,:); x(6:7,:)]);
[a,b,eigenValues] = pca(x1');
eigenValues

[x2, ps] = processpca(x1,0.02);

x3 = processpca('reverse',x2, ps);