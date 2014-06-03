close all 
clear all


res = get_fifa_stats('results.csv');
numb_games = res.numb_games;
goals_vs_mtx = res.goals_vs_mtx;
team_list = res.team_list;

idx_remove = find(numb_games < 30);

goals_vs_mtx(idx_remove,:) = [];
goals_vs_mtx(:,idx_remove) = [];
numb_games(idx_remove) = [];


SCALE_M = diag(1./numb_games);
[e_vect, ~] = eig(SCALE_M*goals_vs_mtx);

team_rank = abs(e_vect(:,1));


[x, I] = sort(team_rank, 'descend');
Ranked_Teams = team_list(I);

[x, I] = sort(sum(goals_vs_mtx')./numb_games', 'descend');
Rank_By_Goals = team_list(I);

results.rank_by_goals = Rank_By_Goals;
save('rank_by_goals.mat', 'results');

% Ranked_Teams{1:25}



