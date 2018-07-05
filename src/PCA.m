x1 = mapstd(x);
[COEFF, SCORE, LATENT, TSQUARED, EXPLAINED] = pca(x1');


figure; 
subplot(1,2,1); 
bar(LATENT); 
text(1:5,LATENT, num2str(round(LATENT*1000)/1000), 'HorizontalAlignment','center', 'VerticalAlignment','bottom'); 

subplot(1,2,2); 
bar(EXPLAINED); 
text(1:5,EXPLAINED, num2str(round(EXPLAINED*100)/100), 'HorizontalAlignment','center', 'VerticalAlignment','bottom');