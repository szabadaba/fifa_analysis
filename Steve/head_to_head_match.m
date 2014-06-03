function [ winner ] = head_to_head_match( team1, team2 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
head_2_head = load('matchup_results.mat');
goal_rank = load('rank_by_goals.mat');

team1_idx = find(strcmp(head_2_head.results.team_list, team1));
team2_idx = find(strcmp(head_2_head.results.team_list, team2));

disp([team1 ':']);
disp(head_2_head.results.matchup_mtx(team1_idx, team2_idx));
disp([team2 ':']);
disp(head_2_head.results.matchup_mtx(team2_idx, team1_idx));

%is the difference great enough?
THRESH = 0.015;
if abs(head_2_head.results.matchup_mtx(team1_idx, team2_idx) - head_2_head.results.matchup_mtx(team2_idx, team1_idx)) > THRESH
    disp('Using head to head');
    if head_2_head.results.matchup_mtx(team1_idx, team2_idx) > head_2_head.results.matchup_mtx(team2_idx, team1_idx)
        disp(['Winner: ' team1]);
        winner = team1;
    else
        disp(['Winner: ' team2]);
        winner = team2;
    end
else
    team1_idx = find(strcmp(goal_rank.results.rank_by_goals, team1));
    team2_idx = find(strcmp(goal_rank.results.rank_by_goals, team2));
    if team1_idx > team2_idx
        disp(['Winner: ' team1]);
        winner = team1;
    else
        disp(['Winner: ' team2]);
        winner = team2;
    end
end

end

