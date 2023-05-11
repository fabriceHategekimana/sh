#! /bin/python3

import sys
import json

FILE_NAME="/home/fabrice/sh/myopen_module/extension_software.json"


def load_extension_software_list():
    f = open(FILE_NAME)
    res = json.load(f)
    f.close()
    return res


def save_extension_software_list(extension_software_list):
    f = open(FILE_NAME, "w")
    json.dump(extension_software_list, f) 
    f.close()


def add(args):
    extension_software_list = load_extension_software_list()
    extension_software_list[args[0]]= args[1]
    save_extension_software_list(extension_software_list)


def delete(args):
    extension_software_list = load_extension_software_list()
    del extension_software_list[args[0]]
    save_extension_software_list(extension_software_list)


def get_software(arg):
    extension_software_list = load_extension_software_list()
    return extension_software_list.get(arg)

"""
add [ext] [soft]
delete [ext] [soft]
get [ext]
"""
if sys.argv[1] == "add":
    add(sys.argv[2:])
elif sys.argv[1] == "delete":
    delete(sys.argv[2:])
else:
    res = get_software(sys.argv[1])
    print(res)
