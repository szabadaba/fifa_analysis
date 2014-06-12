
import pylab as pl
import pandas as pd
import sklearn as sk
import datetime


fn = '../results.csv'

game_data = pd.read_csv(fn,parse_dates=['date'])

## home team
ht_win = game_data[(game_data.home_goals > game_data.away_goals) & (game_data.neutral == 0)].home_team.value_counts()
## traveling team 
at_win = game_data[(game_data.home_goals < game_data.away_goals) & (game_data.neutral == 0)].away_team.value_counts()

teams = sorted(list(set(game_data.home_team).union(game_data.away_team)))

## opponents for each team 
# game_data[game_data.home_team == game_data.home_team.value_counts().keys()[0]].away_team.value_counts()

time_span = (game_data.date.max() - game_data.date.min()).total_seconds()

M = pl.zeros((len(teams),len(teams)))
p = pl.zeros(len(teams))
for ind,row in game_data.iterrows():
	i = teams.index(row['home_team'])
	j = teams.index(row['away_team'])

	w = (row['date'] - game_data.date.min()).total_seconds() / time_span

	M[i,i] += w
	M[j,j] += w
	M[i,j] += -w
	M[j,i] += -w

	p[i] += w * (row['home_goals'] - row['away_goals']) 
	p[j] += w * (row['away_goals'] - row['home_goals'])

r = pl.matrix(pl.linalg.pinv(M)) * pl.matrix(p).T

def team_pred(team1,team2):
	i = teams.index(team1)
	j = teams.index(team2)

	return r[i] - r[j]

