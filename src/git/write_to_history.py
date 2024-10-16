import os
from sys import argv
from time import time 

# create toml file
def create_toml(path):
    meta = open(path, 'w')

    meta.write("# this toml was automatically generated by baur.")
    meta.write("# please do not edit anything here as you might break something\n")

    meta.close()

# each package we install we write a new toml entry for it
def write_toml_entry(path, package_name, aurdir):
    entry = open(path, 'a')

    # write header of entry first
    entry.write(f"[package]")
    entry.write(f"package-name = {package_name}")
    entry.write(f"location = {aurdir}")
    entry.write(f"install-date = {time()}")
    entry.write("\n")

    entry.close()


if argv[1] == "new plis":
    create_toml(argv[2])

write_toml_entry(argv[1], argv[2], argv[3])
