temp = [x;t];

indices = find(temp(6,:)==1 | temp(7,:)<6*3600 | temp(7,:)>19*3600);
indices = find(temp(8,:)~=1);

perm_idx = randsample(indices', 0.7 * length(indices))

temp(:, perm_idx) = [];

%xnew = [temp(1:5,:), temp(1:5, perm_idx)];
%tnew = [temp(8,:), temp(8, perm_idx)];

xnew = [temp(1:5,:)];
tnew = [temp(8,:)];

clear indices;
%clear temp;