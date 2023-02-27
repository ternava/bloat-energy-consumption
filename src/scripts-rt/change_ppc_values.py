#!/usr/bin/env python3
"""change the preprocessor values to 1, 
i.e., the system is back to the baseline configuration S0"""

import os


def change_spec_values(opt, repo):
    cwd = os.getcwd()
    os.chdir(repo)

    # Read in the file
    with open("removeoption.h", 'r') as file:
        filedata = file.read()
    for o in opt:
        # Replace the target string
        filedata = filedata.replace(str(o) + str(" 1"), str(o) + (" 0"))
    # Write the file out again
    with open("removeoption.h", 'w') as file:
        file.write(filedata)

    os.chdir(cwd)


def change_values(opt, o_value, r_value, repo):

    cwd = os.getcwd()
    os.chdir(repo)

    #read input file with options to be remained or removed
    fin = open("removeoption.h", "rt")
    #read all options to string
    data = fin.read()
    #replace the occurrence of 1/0 with the 0/1 for an option
    data = data.replace(str(opt) + str(o_value), str(opt) + str(r_value))
    #close the input file
    fin.close()
    #open the input file with options
    fin = open("removeoption.h", "wt")
    #overrite the input file with the resulting data
    fin.write(data)
    #close the file
    fin.close()

    os.chdir(cwd)


lst_opt = [
    "MIXED_REFS_YES", "MIXED_REFS_NO", "CABAC_YES", "CABAC_NO", "MBTREE_YES",
    "MBTREE_NO", "PSY_YES", "PSY_NO", "WEIGHTB_YES", "WEIGHTB_NO"
]


def change_all_0to1(repo):
    for optb in lst_opt:
        change_values(optb, " 0", " 1", repo)


#dir_path = "/home/xternava/Documents/GitHub/x264-portfolio/"
#change_all_0to1(dir_path)
