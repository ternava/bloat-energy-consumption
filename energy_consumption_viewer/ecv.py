import argparse
import re
import subprocess
import sys
import time

from statistics import mean

import pandas as pd

from progress.bar import FillingSquaresBar
from progress.colors import color


def get_psys_energy():
    with open('/sys/class/powercap/intel-rapl:0/energy_uj') as f:
        psys_energy = int(f.read().strip())
    return psys_energy  # Convert from microjoules to joules


if __name__ == '__main__':

    consumption_equivalences = {}

    # HDD power
    # Seagate BarraCuda 3.5" 1 To 7200 RPM 64 Mo Serial ATA 6 Gb/s (bulk)
    consumption_equivalences["hdd"] = {}
    consumption_equivalences["hdd"]["model"] = "Seagate BarraCuda 3.5\" 1To 7200 RPM 64 Mo SATA"
    consumption_equivalences["hdd"]["power"] = 5.3
    consumption_equivalences["hdd"]["device"] = "HDD"

    # LED light bulb power
    # Lexman 125 mm E27, 1521Lm = 100W, P= 10,5W
    power_led_light_bulb = 10.5
    consumption_equivalences["light_bulb"] = {}
    consumption_equivalences["light_bulb"]["model"] = "Lexman 125 mm E27, 1521Lm"
    consumption_equivalences["light_bulb"]["power"] = 10.5
    consumption_equivalences["light_bulb"]["device"] = "LED light bulb"

    # GPU power
    # NVidia RTX 4080
    consumption_equivalences["gpu"] = {}
    consumption_equivalences["gpu"]["model"] = "NVidia RTX 4080"
    consumption_equivalences["gpu"]["power"] = 320
    consumption_equivalences["gpu"]["device"] = "GPU"

    # Create the ArgumentParser object
    parser = argparse.ArgumentParser(description="Energy Consumption Viewer (ECV), "
                                                 "a program to see the results of the paper: On the Effect of Feature "
                                                 "Reduction on Energy Consumption: An Empirical Study")

    # Add the options/arguments you want to support
    parser.add_argument('--command', '-c', type=str, help="Linux command without options (example ls)")
    parser.add_argument('--repeat', '-r', type=int, help="Number of repetitions for measurement")
    parser.add_argument('--show', '-s', action='store_true', help="Show the results of our studies for a given command")
    parser.add_argument('--measure', '-m', action='store_true',
                        help="Measure the energy consumption of the command given in parameter with option --command")
    parser.add_argument('--equivalent', '-e', action='store_true',
                        help="Display an equivalence in time of use of a light bulb, a GPU and an HDD.")
    parser.add_argument('--details', '-d', action='store_true', help="Get details for each configuration tested")

    # Parse the command-line arguments
    args = parser.parse_args()

    # Access the option values
    if args.command and args.show:
        # print(f"Input file: {args.command}")
        command = args.command

        # Get the min and the max of the power consumption
        df_data = pd.read_csv("merged_all_data.csv")
        df_command = df_data.loc[df_data["Program"] == command]

        utilities = ["GNU", "ToyBox", "BusyBox"]

        # Define the regular expression pattern to match columns with two numbers followed by an underscore
        pattern = r'^\d{2}_'

        # Extract values for columns matching the specified pattern and store them in the dictionary
        merged_columns = []
        for col in df_command.columns:
            match = re.match(pattern, col)
            if match:
                merged_columns.append(col)

        # Find the global maximum and minimum values
        max_value_utilities = df_command[merged_columns].values.max()
        min_value_utilities = df_command[merged_columns].values.min()

        for utility in utilities:
            df = df_command.loc[df_command["Utilities"] == utility]
            # Create a dictionary to store the extracted values for each pattern
            extracted_values = {}
            # print(df)
            print("\n============", command, "|", utility, "============", flush=True)

            # Extract values for columns matching the specified pattern and store them in the dictionary
            for col in df.columns:
                match = re.match(pattern, col)
                if match:
                    key = match.group()
                    if key not in extracted_values:
                        extracted_values[key] = []
                    extracted_values[key].extend(df[col].values.tolist())

            if not args.details:
                keys = list(extracted_values)

                extracted_values["all"] = []

                for key in keys:
                    extracted_values["all"] += extracted_values[key]
                for key in keys:
                    if "all" not in key:
                        del (extracted_values[key])

            # print("Values for columns starting with the pattern '{}':".format(pattern))
            for config, values in extracted_values.items():

                max_val = max(values)
                min_val = min(values)
                mean_val = mean(values)
                config = config.replace("_", "")
                print(''.join(
                    ["==> Config ", config, " == Max (µJ): ", str(round(max_val, 0)), " | Min (µJ): ",
                     str(round(min_val, 0)), " | Mean (x",
                     str(len(values)), ") config (µJ): ", str(round(mean_val, 0))]))

                bar = FillingSquaresBar(color("(Less)", 'green'), suffix=color("(More)\n", 'red'),
                                        index=mean_val, max=max_value_utilities, min=min_value_utilities)
                bar.update()

                if args.equivalent:
                    # divide by 1000 000 to have Joules and after by 3600 to have Wh
                    e_wh = mean_val / 1000000 / 3600

                    # string_consumption_equivalences = "|-------------- Consumption equivalences for "+utility+" - "+ command+" - config "+config+" ----------------|"
                    # dash_string = "|"+''.join(["-" for _ in range(0,len(string_consumption_equivalences)-2)])+"|"

                    # print(dash_string, flush=True)
                    # print(string_consumption_equivalences, flush=True)
                    # print(dash_string, flush=True)

                    for key_device in consumption_equivalences.keys():
                        # t of use (in seconds) = E (Wh) command / power of the device * 3600 (to have the time in seconds
                        # and not in hours)
                        time_device_use = round((e_wh / consumption_equivalences[key_device]["power"]) * 3600, 6)
                        # print(''.join(["| ", str(time_device_use), " seconds of ",
                        #                str(consumption_equivalences[key_device]["device"]),
                        #                " use (", str(consumption_equivalences[key_device]["power"]), "W, ",
                        #                str(consumption_equivalences[key_device]["model"]), ")"]), flush=True)

                        print(''.join([str(time_device_use), " seconds of ",
                                       str(consumption_equivalences[key_device]["device"]),
                                       " use (", str(consumption_equivalences[key_device]["power"]), "W)"]), flush=True)

                    # print(dash_string, flush=True)

    elif args.measure and args.command:
        n = 1
        values_measured = []
        if args.repeat:
            n = args.repeat

        for i in range(0, n):
            # Execute the command
            start_time = time.time()
            initial_psys_energy = get_psys_energy()
            subprocess.run(args.command, shell=True)
            final_psys_energy = get_psys_energy()
            end_time = time.time()

            psys_energy_consumption = final_psys_energy - initial_psys_energy
            values_measured.append(psys_energy_consumption)

        max_val = max(values_measured)
        min_val = min(values_measured)
        mean_val = mean(values_measured)

        print(''.join(
            ["==> Command ", args.command, " == Max (µJ): ", str(round(max_val, 0)), " | Min (µJ): ",
             str(round(min_val, 0)),
             " | Mean (x",
             str(len(values_measured)), ") config (µJ): ", str(round(mean_val, 0))]))

        if n > 1:
            bar = FillingSquaresBar(color("(Less)", 'green'), suffix=color("(More)\n", 'red'),
                                    index=mean_val, max=max_val, min=min_val)
            bar.update()

        # divide by 1000 000 to have Joules and after by 3600 to have Wh
        e_wh = mean_val / 1000000 / 3600

        string_consumption_equivalences = "|-------------- Consumption equivalences for " + args.command + " ----------------|"
        dash_string = "|" + ''.join(["-" for _ in range(0, len(string_consumption_equivalences) - 2)]) + "|"

        # print(dash_string, flush=True)
        # print(string_consumption_equivalences, flush=True)
        # print(dash_string, flush=True)

        for key_device in consumption_equivalences.keys():
            # t of use (in seconds) = E (Wh) command / power of the device * 3600 (to have the time in seconds
            # and not in hours)
            time_device_use = round((e_wh / consumption_equivalences[key_device]["power"]) * 3600, 6)
            # print(''.join(["| ", str(time_device_use), " seconds of ",
            #                str(consumption_equivalences[key_device]["device"]),
            #                " use (", str(consumption_equivalences[key_device]["power"]), "W, ",
            #                str(consumption_equivalences[key_device]["model"]), ")"]), flush=True)

            print(''.join([str(time_device_use), " seconds of ",
                           str(consumption_equivalences[key_device]["device"]),
                           " use (", str(consumption_equivalences[key_device]["power"]), "W)"]), flush=True)

        # print(dash_string, flush=True)
    else:
        parser.print_help()
        sys.exit(2)
