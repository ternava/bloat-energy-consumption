#!/usr/bin/env python3

"""
Usage example: 
./main.py --path /home/xternava/Documents/GitHub/bloat-energy-consumption/src/debloat_examples/
"""

"""calculates the binary size of the executable"""

import os
import csv
import re
import argparse
import subprocess
import random

def get_args():
    """get command-line arguments"""

    parser = argparse.ArgumentParser(
                description="For input directory",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('--path', type=dir_path)

    return parser.parse_args()


def dir_path(path):
    if os.path.isdir(path):
        return path
    else:
        raise argparse.ArgumentTypeError(
            f"{path} is not a valid path. Should be /your/path/to/the/project/src/debloat_examples/"
        )

# You need to create a "results" directory
stats_file = "./results/binary_size.csv"

def binary_size(executable):
    exe_stats = os.stat(executable)
    binary_size = exe_stats.st_size
    return os.path.basename(executable), binary_size

"""
Usage example: 
sudo ./jouleit.sh ./debloat_examples/mkdir-5.2.1.origin oDIR
"""

def consumed_energy():
    """ measuring the energy consumption 
    before and after debloating an application"""
    
    rand = random.sample(range(1, 100), 10)
    
    for i in range(10):
        subprocess.run(["sudo", 
                        "./jouleit.sh", 
                        "-b",
                        "./debloat_examples/mkdir-5.2.1.origin", 
                        "oDIR"+str(rand[i])])

    


def main():
    directory = get_args().path
    
    f = open(stats_file, "w")
    writer = csv.writer(f)
    header = ['System', "BinarySize"]
    writer.writerow(header)
    
    for file in os.listdir(directory):
            print(file)
            #match = re.search("^[^.]+$", file) 
            
            #if match:
            #if file.endswith('.'):
            fn = os.path.join(directory, file)
            bs = binary_size(fn)
            print(bs)
            writer.writerow(bs)
    f.close()
    
    consumed_energy()


if __name__ == "__main__":
    main()
