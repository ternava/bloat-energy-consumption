#!/usr/bin/env python3

import os
import re
from anytree import Node, RenderTree

def find_indentations(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    indentations = []
    for line in lines:
        match = re.match(r'^(\s+)', line)
        if match:
            indentation = match.group(1)
            indentations.append(indentation)

    return indentations

def build_tree(file_path, parent_node):
    indentations = find_indentations(file_path)

    for indentation in indentations:
        node = Node(indentation, parent=parent_node)
        if indentation.strip() != '':
            build_tree(file_path, node)

def visualize_indentations(file_path):
    root = Node("Root")
    build_tree(file_path, root)

    for pre, fill, node in RenderTree(root):
        print("%s%s" % (pre, node.name))

# Provide the path to your .c project
project_path = '/path/to/your/project'

# Iterate over all .c files in the project directory
for root, dirs, files in os.walk(project_path):
    for file in files:
        if file.endswith('.c'):
            file_path = os.path.join(root, file)
            print("Indentations for file:", file_path)
            visualize_indentations(file_path)
            print("\n")
