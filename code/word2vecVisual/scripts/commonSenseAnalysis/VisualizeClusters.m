% Script to analyze the clusters initially formed
% Flags to show relevant parts
% showImgs = show the top images close to the cluster center
% showPRS = show the tsne of P,R,S separately
% showPRStog = sow the tsne of P,R,S together
showImgs = false;

% Read the file
clustIdPath = '../modelsNdata/cluster_id_save.txt';
cIds = dlmread(clustIdPath);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Show the TSNE for P,R,S
% Read the tuples and feature files
rootPath = '/home/satwik/VisualWord2Vec/';

addpath(fullfile(rootPath, 'code/io/'));
addpath(genpath(fullfile(rootPath, 'libs')));
psrPath = fullfile(rootPath, 'data/PSR_features.txt');
featPath = fullfile(rootPath, 'data/float_features_withoutheader.txt');

% Dont read if already exists in workspace
if(~exist('Rfeats', 'var'))
    [Plabel, Slabel, Rlabel, Rfeats] = readFromFile(psrPath, featPath);
end

noDims = 2;
noInitDims = [];
perplexity = 50;

% tsneEmbed = tsne(Rfeats, [], noDims, noInitDims, perplexity);
load('cluster-visualization.mat');
% Visualizations based on visual features
% Get the tuples
tupleLabels = strcat('<', Plabel, ':', Slabel, ':', Rlabel, '>');

%figure(1); gscatter(tsneEmbed(:, 1), tsneEmbed(:, 2), cIds(:, 1), [], ['o', 'x', 's', 'd'], 2)

% PLot just one cluster
noClusters = length(unique(cIds(:, 1)));
for k = 1:noClusters
    members = cIds(:, 1) == k;
    figure(1); scatter(tsneEmbed(members, 1), tsneEmbed(members, 2))
    dx = 0.1; dy = 0.1;
    text(tsneEmbed(members, 1) + dx, tsneEmbed(members, 2) + dy, tupleLabels(members))
    pause()
end
    %figure(1); gscatter(tsneEmbed(:, 1), tsneEmbed(:, 2), cIds(:, 1), [], ['o', 'x', 's', 'd'], 2)
    %dx = 0.1; dy = 0.1;
    %text(tsneEmbed(:, 1) + dx, tsneEmbed(:, 2) + dy, tupleLabels)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Show the abstract images for each cluster
if(showImgs)
    % Read the association file
    rootPath = '/srv/share/al/data_model/image_data/';
    dumpPath = '../modelsNdata/trainListings.mat';
    iccv = load(dumpPath);

    noImgs = length(iccv.listing);
    imgPaths = cell(noImgs, 1);
    % Store image names with full path
    for i = 1:noImgs
        imgPaths{i} = fullfile(rootPath, strrep(iccv.listing(i).name, '.mat', '.png'));
    end

    % Get the top 25 images for each cluster
    noTop = 10;
    noClusters = max(cIds(:, 1));

    topMembers = zeros(noClusters, noTop);
    for k = 1:noClusters
        members = find(cIds(:, 1) == k);
        [~, topIds] = sort(cIds(members, 2));

        % Account for clusters having fewer number of elements
        noPresent = min(noTop, length(members));
        topMembers(k, 1:noPresent) = members(topIds(1:noPresent));
    end

    % Display the top 5 images for each cluster
    imgSize = 200;
    for k = 1:noClusters
        % Creating the montage image
        dispImg = uint8(zeros(imgSize, imgSize, 3, noTop));
        % Display only if noTop exists, else a very small cluster
        if(all(topMembers(k, :) > 0))
            % Fetch the images
            for i = 1:noTop
                img = imread(imgPaths{topMembers(k, i)});
                dispImg(:, :, :, i) = imresize(img, [imgSize, imgSize]);
            end
            %figure(k); montage(dispImg)
            %pause()
        end
    end
end