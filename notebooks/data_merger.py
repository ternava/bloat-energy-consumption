import os
import pandas as pd

def merge_csv_files(directory_path, output_file):
    # Get a list of all CSV files in the directory
    csv_files = [file for file in os.listdir(directory_path) if file.endswith('.csv')]

    # Initialize an empty list to hold DataFrames
    dataframes = []

    # Read each CSV file into a DataFrame and append it to the dataframes list
    for file in csv_files:
        file_path = os.path.join(directory_path, file)
        df = pd.read_csv(file_path)
        dataframes.append(df)

    # Concatenate all DataFrames into a single DataFrame
    merged_df = pd.concat(dataframes, ignore_index=True)

    # Export the merged DataFrame to a new CSV file
    merged_df.to_csv(output_file, index=False)
    print("Merged CSV files have been exported to:", output_file)

if __name__ == '__main__':

    directory = './data/repeat21'

    # Create a set to store the unique filenames
    commands = set()
    utilities = set()

    # Iterate over the files in the directory
    for filename in os.listdir(directory):
        # Split the filename by "-"
        parts = filename.split("-")
        if len(parts) > 1:
            # Extract the command without the suffix
            name = parts[0]
            # Add the command to the set
            commands.add(name)

        # Split the filename by "_"
        parts = filename.split("_")
        if len(parts) > 1:
            # Extract the utility without the prefix
            name = parts[1].split(".")[0]
            # Add the utility to the set
            utilities.add(name)

    # Get a list of directories starting with "repeat_" and sort them in lexical order
    directories = sorted(
        [directory for directory in os.listdir('./data') if directory.startswith('repeat')])

    # Iterate over the configurations
    for config in ["01", "02"]:
        # Iterate over commands
        for command in commands:
            data = {}
            # Iterate over directories
            for directory in ["./data/" + x for x in directories]:
                #Iterate over utilities (GNU, Toybox, etc)
                for utility in utilities:
                    file_path = os.path.join(directory, command + "-" + config + "_" + utility + ".csv")
                    print(file_path)
                    # Read the CSV file in the current directory
                    if os.path.exists(file_path):
                        df = pd.read_csv(file_path, delimiter=";")

                        # Get the PSYS value and append it to the data dictionary
                        column_name = directory.split('repeat')[1]  # Extract the numeric suffix
                        print(column_name)
                        if "PSYS_repeat" + column_name not in data.keys():
                            data["PSYS_repeat" + column_name] = [df['PSYS'].values[0]]
                            data["DURATION_repeat" + column_name] = [df['DURATION'].values[0]]
                            data["Utilities"] = [utility]
                            data["Program"] = [command]
                            data["config"] = [config]
                        else:
                            data["PSYS_repeat" + column_name].append(df['PSYS'].values[0])
                            data["DURATION_repeat" + column_name].append(df['DURATION'].values[0])
                            data["Utilities"].append(utility)
                            data["Program"].append(command)
                            data["config"].append(config)

            # Create a new DataFrame using the data dictionary
            new_df = pd.DataFrame(data)
            # Write the new DataFrame to a CSV file
            new_df.to_csv("./merged_data_"+ config + "/"  + command + "-" + config + '.csv', index=False)

    merge_csv_files("./merged_data_01", "./merged_data_01/all_data_01.csv")
    merge_csv_files("./merged_data_02", "./merged_data_02/all_data_02.csv")