function [centers,err,new_assignment] = k_means(X,NC,varargin)
%function [centers,dist,assignments] = k_means(X,NC,varargin)
%
%   Applies the k-means algorithm to the data in 'X'. 'NC' is the requested
%   number of clusters. 'X' is a 2D matrix structured as: (n-observations x
%   m-variables).
%
%   Returns:
%   'centers' - The final cluster centers
%   'dist' - The distance metric at each iteration
%   'assignments' - The final cluster assignments for each observation
%
%   Input flags are:
%   'gpu' - Does computation on gpu, only worthwhile for very large data
%   'zerocluster' - Modified version of the k-means algorithm where there
%       is always a cluster center that is all zeros
%   'verbose' - Print progress to command window
%   'maxiter' - Followed by an integer value. Maximum number of iterations
%       before k-means terminates without converging
%

%parse optional inputs:
gpu_mode = false;
null_cluster = false;
verbose = false;
max_iter = 1000;
for i = 1:length(varargin)
    switch varargin{i}
        case 'gpu'
            gpu_mode = true;
        case 'zerocluster'
            null_cluster = true;
        case 'verbose'
            verbose=true;
        case 'maxiter'
            i = i+1;
            max_iter = varargin{i};
    end
end

%get number of samples and initialize cluster centers matrix
N = length(X);
if null_cluster
    centers = zeros(NC,size(X,2));
else
    centers = repmat(X(randi(N,1),:),[NC 1]);
end

%transfer data to GPU when using GPU:
if gpu_mode
    X = gpuArray(X);
    centers = gpuArray(centers);
end

%initialize the centers:
for i = 2:NC
    [~,idx] = max(min(get_distances(centers,X),[],2));
    centers(i,:) = X(idx,:);
end

%re-assign data until converged:
nmoved = 1;
[~,old_assignment] = min(get_distances(centers,X),[],2);
err = [];
iter = 0;
while nmoved~=0 && iter<max_iter
    err(end+1) = gather(mean(sum((centers(old_assignment,:)-X).^2,2)));
    %recompute cluster averages
    for i = 1:NC
        centers(i,:) = mean(X(old_assignment==i,:));
    end
    if null_cluster
        centers(1,:) = 0;
    end
    %reassign data points:
    [~,new_assignment] = min(get_distances(centers,X),[],2);
    %check to see if converged
    nmoved = sum(new_assignment ~= old_assignment);
    old_assignment = new_assignment;
    iter = iter+1;
    %output progress
    if verbose
        disp(['Iteration: ' num2str(iter) '    #Moved: ' num2str(nmoved) ...
            '    Mean Dist: ' num2str(err(end))]);
    end
end
centers = gather(centers);

%display a warning if maxiter was reached:
if iter == max_iter
    warning('K-means did not converge, maximum iteration reached');
end

function [dist] = get_distances(centers,X)
%computes the euclidean distance between all points in X and all cluster
%centers:
N = length(X);
NC = size(centers,1);
dist = repmat(sum(X.*X,2),[1 NC]) + repmat(sum(centers.*centers,2),[1 N])'-2*X*centers';
