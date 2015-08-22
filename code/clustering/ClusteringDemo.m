% Wrapper for showing the usage of clustering of relationship words

% Reading the relationship features from the features file
tic

run('../addPaths');
rootPath = '/home/satwik/VisualWord2Vec/';
dataPath = '/home/satwik/VisualWord2Vec/data';

% Reading the features and relations
psrFeaturePath = fullfile(dataPath, 'PSR_features.txt');
numFeaturePath = fullfile(dataPath, 'Num_features.txt');

[Plabel, Slabel, Rlabel, Rfeatures] = readFromFile(psrFeaturePath, numFeaturePath);

% Assigning the cluster ids (each relation word is a cluster)
[clusterR, ~, uniqIds] = unique(Rlabel);

% Visualization
noDims = 2;
noInitDims = 50;
perplexity = 30;
tsnePts = tsne(Rfeatures, uniqIds, noDims, noInitDims, perplexity);

figure; gscatter(tsnePts(:, 1), tsnePts(:, 2), uniqIds);

% Clustering the features
% yael k-means
% Usage: yael_kmeans(vectors, noClusters)
noClusters = 10;
[clusterCentres, clusterIds] = yael_kmeans(single(Rfeatures)', noClusters);

% Assigning the cluster ids after clustering
% Visualization
figure; gscatter(tsnePts(:, 1), tsnePts(:, 2), clusterIds);

time = toc;
fprintf('Total time taken : %f\n', time);

% Saving the session
save('clusteringSession_Aug3.mat');