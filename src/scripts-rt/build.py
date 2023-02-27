#!/usr/bin/env python3
"""building x264, whatever its specialization"""

import subprocess
import os


def build(repo):
    """build x264"""

    cwd = os.getcwd()
    os.chdir(repo)
    subprocess.run(["make", "clean"])
    subprocess.run(["./configure"])
    subprocess.run(["make"])
    os.chdir(cwd)
