close all 
clear all


res = get_fifa_stats('results.csv');
numb_games = res.numb_games;
goals_vs_mtx = res.goals_vs_mtx;
games_vs_mtx = res.games_vs_mtx;
team_list = res.team_list;


idx_remove = find(numb_games < 30);

goals_vs_mtx(idx_remove,:) = [];
goals_vs_mtx(:,idx_remove) = [];
games_vs_mtx(idx_remove,:) = [];
games_vs_mtx(:,idx_remove) = [];
numb_games(idx_remove) = [];
idx = 1;
for i = 1:length(team_list)
   if isempty(find( idx_remove == i))
       small_team_list{idx} = team_list{i};
       idx = idx+1;
   end
end

match_played = zeros(size(res.games_vs_mtx));
score_mtx = zeros(size(res.games_vs_mtx));
for i = 1:size(games_vs_mtx,1)
    for j = 1:size(games_vs_mtx,2)
        if games_vs_mtx(i,j)
            match_played(i,j) = 1;
            
            %calc scores
            score_mtx(i,j) = goals_vs_mtx(i,j)/games_vs_mtx(i,j);
        end
    end
end

%normalize
score_mtx = score_mtx/max(max((score_mtx)));

num_users = size(score_mtx, 2);
num_movies = size(score_mtx, 1);
num_features = 3;

% Set Initial Parameters (Theta, X)
X = randn(num_movies, num_features);
Theta = randn(num_users, num_features);
initial_parameters = [X(:); Theta(:)];

% Set options for fmincg
% options = optimset('GradObj', 'on', 'MaxIter', 100);
options = optimset('MaxIter', 1000);


% Set Regularization
lambda = 1;
theta = fmincg (@(t)(cofiCostFunc(t, score_mtx, match_played, num_users, num_movies, ...
                                num_features, lambda)), ...
                initial_parameters, options);

% Unfold the returned theta back into U and W
X = reshape(theta(1:num_movies*num_features), num_movies, num_features);
Theta = reshape(theta(num_movies*num_features+1:end), ...
                num_users, num_features);
            
res_mtx = X * Theta';

res_cell = {};

for i = 1:length(small_team_list)
    res_cell{i + 1,1} = small_team_list{i};
    res_cell{1,i + 1} = small_team_list{i};
end

for i = 1:length(res_mtx)
    for j = 1:length(res_mtx)
        res_cell{i + 1, j + 1} = res_mtx(i,j);
    end
end

results.team_list = small_team_list;
results.matchup_mtx = res_mtx;

save('matchup_results', 'results');


% match = {'Russia', 'Germany'};
% 
% op1_idx = find(strcmp(small_team_list, match{1}));
% op2_idx = find(strcmp(small_team_list, match{2}));
% 
% disp(match{1});
% disp(res_mtx(op1_idx, op2_idx));
% disp(match{2});
% disp(res_mtx(op2_idx, op1_idx));
% 
% for i = 1:length(small_team_list)
%    if  res_mtx(op1_idx,i) < res_mtx(i,op1_idx)
%        disp(small_team_list{i})
%    end
% end


