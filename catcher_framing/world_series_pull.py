import pybaseball as pb
import pandas as pd
import xgboost as xgb

data = pb.statcast(start_dt='2023-10-26', end_dt='2023-11-01')

fastball = xgb.XGBRegressor()
fastball.load_model('fastball_final_model.json')
offspeed = xgb.XGBRegressor()
offspeed.load_model('offspeed_final_model.json')

data = data.loc[(data['description'] == 'called_strike') | (data['description'] == 'ball')].copy() # only called strikes and balls

#map pitch types to numbers
pitch_type_dict = {'FF': 1, 'SL': 2, 'CH': 2, 'CU': 2, 'SI': 1, 'FC': 1, 'KC': 2, 'FS': 2, 'KN': 2, 'EP': 2, 'FO': 2, 'SC': 2, 'ST': 2, 'FA': 1, 'SV': 2, 'CS': 2, 'nan': 17}

data['pitch_type_dict'] = data['pitch_type'].map(pitch_type_dict)
data['likely_strike'] = ((data['plate_x'].abs() <= .708) &
                            (data['plate_z'] <= data['sz_top']) &
                            (data['plate_z'] >= data['sz_bot'])).astype(int)
data['is_strike'] = data['description'].map({'called_strike': 1, 'ball': 0}) # convert to binary
data['p_throws'] = data['p_throws'].map({'R': 1, 'L': 0}) # convert to binary
data['stand'] = data['stand'].map({'R': 1, 'L': 0}) # convert to binary
heaters_2023 = data[data['pitch_type_dict'] == 1].copy()
offspeed_2023 = data[data['pitch_type_dict'] == 2].copy()
# Select only the features you used for training the models
features = ['zone', 'stand', 'strikes', 'plate_x', 'plate_z',  'likely_strike']
# Make predictions
heaters_2023['prediction'] = fastball.predict(heaters_2023[features])
offspeed_2023['prediction'] = offspeed.predict(offspeed_2023[features])

# Merge the two dataframes back together
complete = pd.concat([heaters_2023, offspeed_2023], axis=0)
complete['probability_added'] = 0.0

# Correct the conditions and assignment for 'probability_added'
condition1 = (complete['is_strike'] == 1)
complete.loc[condition1, 'probability_added'] = 1.0 - complete.loc[condition1, 'prediction']

condition2 = (complete['is_strike'] == 0)
complete.loc[condition2, 'probability_added'] = 0.0 - complete.loc[condition2, 'prediction']

players = pd.read_csv("Y:/departments/research_and_development/baseball_operations/clayton_goodiez/csv/players_query.csv")

completed = complete.merge(players, left_on='fielder_2', right_on='mlb_id', how='left')
strike_probs = completed.loc[completed['probability_added'] != 0].copy()

#Use Savant's Change in Run Expectancy to calculate the framing runs
strike_probs['framing_runs'] = (strike_probs['delta_run_exp'] * -1) * strike_probs['probability_added'].abs()

strike_probs.to_csv('world_series_2023.csv')