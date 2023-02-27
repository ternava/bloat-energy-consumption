#!/usr/bin/env python3
"""calculates the binary size of the executable"""

import os


def binary_size(branch, repo, exe):

    cwd = os.getcwd()
    os.chdir(repo)

    exe_stats = os.stat(exe)
    binary_size = exe_stats.st_size
    write_bs_to_afile(branch, binary_size)

    os.chdir(cwd)


def write_bs_to_afile(b, bs):
    """write the value of binary size to a textual file"""

    with open('binary_size.txt', 'w') as f:
        f.write("".join(str(b) + ":" + str(bs)))
