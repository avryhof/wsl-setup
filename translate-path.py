#!/usr/bin/env python
import getpass
import re
import sys
from argparse import ArgumentParser

parser = ArgumentParser()
parser.add_argument(dest="path", help="Translate this PATH", metavar="PATH", nargs="?")
parser.add_argument(
    "-w", help="prints Windows form of NAME (C:\\WINNT)", action="store", dest="winpath", nargs="?"
)
parser.add_argument(
    "-m",
    help="like -w, but with regular slashes (C:/WINNT)",
    action="store",
    dest="winslash",
    nargs="?",
)
parser.add_argument(
    "-u",
    help="(default) prints Unix form of NAME (/mnt/c/winnt)",
    action="store",
    dest="unix",
    nargs="?",
)
parser.add_argument(
    "-c",
    help="(default) prints Cygwin/Git Bash form of NAME (/C/winnt)",
    action="store",
    dest="cygwin",
    nargs="?",
)

default_windows = False
default_unix = False

args = parser.parse_args()

if args.winpath:
    path = args.winpath

elif args.winslash:
    path = args.winslash

elif args.unix:
    path = args.unix

elif args.cygwin:
    path = args.cygwin

else:
    path = args.path
    if '\\' in path:
        default_unix = True
    elif '/' in path:
        default_windows = True


if "\\" not in path and "/" not in path:
    sys.stdout.write("No path separator found in argument. (you might need to put quotes around it)")
    exit(1)

username = getpass.getuser()

drive_letter = None

path_parts = re.split(r'/|\\', path)

if args.winpath or args.winslash or default_windows:
    if '~' in path:
        path_parts = ['C:', 'Users', username] + path_parts[1:]

    try:
        if path_parts[0][-1] == ':':
            drive_letter = path_parts[0]
    except IndexError:
        drive_letter = ''

elif args.unix or args.cygwin or default_unix:
    if args.cygwin and '~' in path:
        path_parts = ['C', 'Users', username] + path_parts[1:]

    if (args.unix or default_unix) and '~' in path:
        path_parts = ['home', username] + path_parts[1:]

    try:
        if path_parts[0][-1] == ':':
            drive_letter = path_parts[0][0]
    except IndexError:
        drive_letter = None

    if drive_letter:
        path_parts = ['mnt', drive_letter.lower()] + path_parts[1:]

        if args.cygwin:
            path_parts.remove(path_parts[0])
            path_parts[0] = path_parts[0].upper()

if args.winpath or default_windows:
    if drive_letter not in path_parts:
        sys.stdout.write("%s\\%s" % (drive_letter, "\\".join(path_parts)))
    else:
        sys.stdout.write("\\".join(path_parts))

elif args.winslash:
    if drive_letter not in path_parts:
        sys.stdout.write("%s/%s" % (drive_letter, "/".join(path_parts)))
    else:
        sys.stdout.write("/".join(path_parts))

elif args.cygwin or args.unix or default_unix:
    if drive_letter:
        sys.stdout.write("/%s" % "/".join(path_parts))
    else:
        sys.stdout.write("/".join(path_parts))
