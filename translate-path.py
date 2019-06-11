#!/usr/bin/env python
from argparse import ArgumentParser

parser = ArgumentParser()
parser.add_argument(dest="path", help="Translate this PATH", metavar="PATH")

args = parser.parse_args()

path = args.path

path_parts = []

if "\\" not in path and "/" not in path:
    print("No path separator found in argument. (you might need to put quotes around it)")
    exit(1)
elif "/" in path:
    path_type = "unix"
    path_separator = "/"
    path_parts = path.split(path_separator)
    if path_parts[0] == "":
        path_parts.remove("")
else:
    path_type = "windows"
    path_separator = "\\"
    path_parts = path.split("\\")
    if path_parts[0][-1] == ":":
        path_parts[0] = path_parts[0][0].lower()
        path_parts = ["mnt"] + path_parts

print("/%s" % "/".join(path_parts))
