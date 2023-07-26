#!/usr/bin/env python3
"""tests for scripts"""

import os

prg = "src/scripts/ecv.py"

def test_exists():
    """exists"""
    
    assert os.path.isfile(prg)