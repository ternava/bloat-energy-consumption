#!/usr/bin/env python3
"""extracting the preprocessors used for system specialization"""

from fileinput import filename
import glob
import ntpath


def path_leaf(path):
    head, tail = ntpath.split(path)
    return tail or ntpath.basename(head)


def spec_to_array():

    # Add considered sets with configurations
    specializations = {}
    for variant in glob.glob("/home/xternava/Documents/GitHub/bloat-energy-consumption/src/configurations/*.config"):
        file_name = path_leaf(variant[:-7])
        lineList = [line.rstrip('\n') for line in open(variant)]
        specializations[file_name] = lineList
        
    return specializations


"""def main():
    lst_with_directives = spec_to_array()
    print(lst_with_directives)
    
if __name__ == "__main__":
    main()"""