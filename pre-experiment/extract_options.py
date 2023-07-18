#Code genereated with the help of chatgpt
import os
import subprocess
import pandas as pd
import re
def extract_options(folder_path):
    folder_name=os.path.basename(folder_path)
    utilities = []
    options = []

    for filename in os.listdir(folder_path):
        filepath = os.path.join(folder_path, filename)
        if os.path.isfile(filepath) and os.access(filepath, os.X_OK):
            utility = os.path.splitext(filename)[0]
            utilities.append(utility)
            try:
                result = subprocess.run([filepath, "--help"], capture_output=True, text=True)
                if result.returncode == 0:
                    option_list = extract_option_list(result.stdout)
                    options.append(option_list)
                else:
                    #ToyBox utilities have no --help option, the help page is displayed when you use a bad option
                    print("Nothing on stdout, trying to find something on stderr,  for "+filepath)
                    option_list = extract_option_list(result.stderr)
                    options.append(option_list)
            except subprocess.CalledProcessError as e:
                options.append([])
    
    df = pd.DataFrame({'Utility': utilities, 'Options '+folder_name: options})
    return df


def extract_option_list(help_text):
    lines = help_text.split('\n')
    option_list = []
    for line in lines:
       #Todo handle option with "-"
       pattern = r'^(?:\t|\s)*((?:-|--)\w+)'
       matches = re.findall(pattern, line)
       if len(matches) > 0 :
        option_list.append(matches[0])
    return option_list

# Folders
folders = ['ToyBox', 'BusyBox', 'GNU']

# Empty DataFrame to store the results
result_df = None

# Perform extraction for each folder
for folder in folders:
    folder_path = f'./pre-experiment/{folder}'
    folder_df = pd.DataFrame(extract_options(folder_path)).sort_values("Utility")
    folder_df.sort_values("Utility").to_csv(f'./pre-experiment/options_{folder}.csv')

    print(folder_df)
    result_df = folder_df if result_df is None else pd.merge(result_df, folder_df,on="Utility")

result_df = result_df.rename(columns={'Options_x': 'Options_df1',
                                      'Options_y': 'Options_df2',
                                      'Options': 'Options_df3'})

# Print the final DataFrame
print(result_df)
result_df.sort_values("Utility").to_csv("./pre-experiment/options.csv")

