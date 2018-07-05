X3 = x2(:,1:length(x)/2)
D3 = t(:,1:length(t)/2)
% 9. Evaluate performance on a separate set of data.
% Use the same basis functions (same number, centres, standard
% deviation) and weights, but recalculate the distances and therefore F.
% Calculate F but using the same centres
% and dmax. This means calculating a new distance matrix for X2
N = size(X3,2);         % calculate number of data points
points = [X3 c];        % append the centres to the data
dist = squareform(pdist(points')); % calculate the distance matrix, from
                                   % every point or centre to
                                   % every other point or centre
dist = dist(1:N,N+1:N+m1); % extract the section with distances
                           % from points to centres

                           
% 10. Once you have the distance matrix, calculate the new F matrix using the same expression, and
% then calculate classes using the same W as before:
F2 = exp((-m1/(dmax*dmax))*(dist.*dist)); % using new distances, calculate F2
Dcalc = F2*W;           % calculated outputs based on F2 and W
Dthresh = Dcalc > 0.5;  % and compare
MSE2 = sum((D3 - Dcalc').^2)/numel(D3);

y = Dthresh';
X4 = x2(:,length(x)/2+1:end)
D4 = t(:,length(t)/2+1:end)

% 9. Evaluate performance on a separate set of data.
% Use the same basis functions (same number, centres, standard
% deviation) and weights, but recalculate the distances and therefore F.
% Calculate F but using the same centres
% and dmax. This means calculating a new distance matrix for X2
N = size(X4,2);         % calculate number of data points
points = [X4 c];        % append the centres to the data
dist = squareform(pdist(points')); % calculate the distance matrix, from
                                   % every point or centre to
                                   % every other point or centre
dist = dist(1:N,N+1:N+m1); % extract the section with distances
                           % from points to centres

                           
% 10. Once you have the distance matrix, calculate the new F matrix using the same expression, and
% then calculate classes using the same W as before:
F2 = exp((-m1/(dmax*dmax))*(dist.*dist)); % using new distances, calculate F2
Dcalc = F2*W;           % calculated outputs based on F2 and W
Dthresh = Dcalc > 0.5;  % and compare
MSE2 = sum((D4 - Dcalc').^2)/numel(D4);

y = [y, Dthresh']