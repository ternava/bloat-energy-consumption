#!/usr/bin/env python3
"""main program"""

import os
from git import Repo
from build import build
from change_ppc_values import change_spec_values
from options import spec_to_array
from exe_bsize import binary_size

dir_path = "/home/xternava/Documents/GitHub/x264-ec/"
repo = Repo(dir_path)

def main():
    "calling to build"

    for branch in repo.branches:
        print(branch)

    lst_with_directives = spec_to_array()
    print(lst_with_directives)

    for key, value in lst_with_directives.items():
        
        """x264-bsl is a branch of x264-rmv 
        (used before for specialization),
        which has the removeoption.h file"""
        repo.git.checkout("x264-bsl")

        """create a new branch and checkout"""
        repo.git.branch(str(key))
        repo.git.checkout(str(key))

        """prepare it for specialization"""
        change_spec_values(value, dir_path)

        """specialize the system"""
        build(dir_path)

        """calculate the executables binary size 
        and save it to a file within the branch"""
        binary_size(key, dir_path, dir_path + "x264")

        """stage all changes (i.e., object files) and commit"""
        repo.git.add(all=True, force=True)
        repo.index.commit('build of x264 - ' + str(key))
        
        """copy the executable file"""
        os.system(f"cp '{dir_path}'x264 /home/xternava/Documents/GitHub/bloat-energy-consumption/src/specializations/x264-'{key}'") 
        
        

if __name__ == "__main__":
    main()
