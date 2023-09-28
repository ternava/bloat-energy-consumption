#Code genereated with the help of chatgpt
###########################################
#Description :

# This script allow you to have an insight on the configuration option of an utility
# It use the help page to pares with a regex the option
# Actually it extract all the option of utilities contained in three folder and export the result in a csv file
# You can customize the end of this script to extract the options of your folder 

#Limitations :

# The script do not handle properly option with a dash like "-aaaaa-bbbbb" it will return "-aaaaa"
# Only the first option of each line is return (allow us to avoid many false positive match)
# The option must be at the begining of line (it can have space or tab before)
# It is not handling help template that have two different option on the same line (cf toybox ex)
# Since it only keep one option per line you do not have both the reduce and long version of an option "-r vs --recursive"
# We do not handle option that are not at the begining of a line (cf timeout of busybox "Usage: timeout [-s SIG] [-k KILL_SECS] SECS PROG ARGS")

#Perspective :

# We could use an LLM to perform such task
# Customize this script to be 


##########################################
import os
import subprocess
import pandas as pd
import re
def extract_options(folder_path):
    folder_name=os.path.basename(folder_path)
    utilities = []
    all_options_list = []

    for filename in os.listdir(folder_path):
        filepath = os.path.join(folder_path, filename)
        print(filename)
        if os.path.isfile(filepath) and os.access(filepath, os.X_OK):
            utility = os.path.splitext(filename)[0]
            utilities.append(utility)
            try:
                result = subprocess.run([filepath, "--help"], capture_output=True, text=True)
                
                option_list = extract_option_list(result.stdout)
                
                if result.returncode != 0 :
                    #ToyBox utilities have no --help option, the help page is displayed when you use a bad option
                    #In some case the return code is 1/2 with help page in either stdout or stderr ...
                    print("[WARN] Exit code not 0, trying to find something on stderr or stdout,  for "+filepath)
                    stderr_option_list = extract_option_list(result.stderr)
                    option_list += stderr_option_list                
                all_options_list.append(option_list)
            except subprocess.CalledProcessError as e:
                all_options_list.append([])
    option_size = [len(options_list) for options_list in all_options_list]
    df = pd.DataFrame({'Utility': utilities, 'Options '+folder_name: all_options_list, 'Number of options'+folder_name: option_size})
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
    folder_path = f'./inputs/{folder}'
    folder_df = pd.DataFrame(extract_options(folder_path)).sort_values("Utility")
    folder_df.sort_values("Utility").to_csv(f'./inputs/options_{folder}.csv')

    print(folder_df)
    result_df = folder_df if result_df is None else pd.merge(result_df, folder_df,on="Utility")


# Print the final DataFrame
print(result_df)
result_df.sort_values("Utility").to_csv("./inputs/options.csv")

