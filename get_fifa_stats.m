function [ results ] = get_fifa_stats( file_name )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


c = csv2cell(file_name,'fromfile');

team_list = {};
goals_vs_mtx = [];
games_vs_mtx = [];
numb_games = [];

for i = 2:length(c)
    %copy team names
    home_team = c{i,2};
    away_team = c{i,3};
    
    %do we need to add the team to the list?
    if isempty(find(strcmp(team_list,home_team)))
        team_list{length(team_list)+1} = home_team;
        goals_vs_mtx(end+1, end+1) = 0;
        games_vs_mtx(end+1, end+1) = 0;
        numb_games = [numb_games; 0];
    end
    if isempty(find(strcmp(team_list,away_team)))
        team_list{length(team_list)+1} = away_team;
        goals_vs_mtx(end+1, end+1) = 0;
        games_vs_mtx(end+1, end+1) = 0;
        numb_games = [numb_games; 0];
    end
    
    %fine indeces for teams
    home_idx = find(strcmp(team_list,home_team));
    away_idx = find(strcmp(team_list,away_team));
    
    %add goals for home team
    goals_vs_mtx(home_idx, away_idx) = goals_vs_mtx(home_idx, away_idx) + str2num(c{i,4});
    goals_vs_mtx(away_idx, home_idx) = goals_vs_mtx(away_idx, home_idx) + str2num(c{i,5});
    
    games_vs_mtx(home_idx, away_idx) = games_vs_mtx(home_idx, away_idx) + 1;
    games_vs_mtx(away_idx, home_idx) = games_vs_mtx(away_idx, home_idx) + 1;
    
    %
    
    %add games
    numb_games(home_idx) = numb_games(home_idx) + 1;
    numb_games(away_idx) = numb_games(away_idx) + 1;
    
end

results.team_list = team_list;
results.goals_vs_mtx = goals_vs_mtx;
results.numb_games = numb_games;
results.games_vs_mtx = games_vs_mtx;

