
# ADIOS COPY
# See README.adoc for usage

import sys

import adios as ad
import numpy as np

class Copier:
    """
    This is just global state for the ad module init and finalize
    """
    def __init__(self):
        ad.init_noxml()

    def __del__(self):
        ad.finalize()
        pass

def copier_read(filename, group, key):
    f = ad.file(filename)
    v = f.vars[key]
    return v.read()

def copier_write(filename, group, key, value):
    g = ad.declare_group(group, "", ad.FLAG.YES)
    ad.define_var(g, key, "", ad.DATATYPE.string, "", "", "")
    ad.select_method(g, "POSIX1", "", "")
    dtype = ad.adios2npdtype(ad.DATATYPE.string, len(str(value)))
    fd = ad.open(group, filename, "w")
    ad.write(fd, key, value, dtype)
    ad.close(fd)

def read_string(tokens):
    if len(tokens) == 1:
        with open(tokens[0], "r") as fp:
            result = fp.read()
    elif len(tokens) == 4:
        result = copier_read(tokens[1], tokens[2], tokens[3])
    return result

def write_string(tokens, data):
    if len(tokens) == 1:
        with open(tokens[0], "w") as fp:
            result = fp.write(data)
    elif len(tokens) == 4:
        result = copier_write(tokens[1], tokens[2], tokens[3], data)
    return result

def do_cmd_line(args):
    if len(args) != 3:
        # args includes the program name
        print("requires 2 arguments!")
        exit(1)
    url_in  = args[1]
    url_out = args[2]
    tokens_in  = tokenize(url_in)
    tokens_out = tokenize(url_out)
    data = read_string(tokens_in)
    write_string(tokens_out, data)

def run_cmd(args):
    copier = Copier()
    do_cmd_line(args)
    
def tokenize(url):
    """
    URL is either a simple Unix filename or 
    a combination: adios:filename:group:variable 
    This may become more complex in the future.
    """
    tokens = url.split(":")
    count = len(tokens)
    if not (count == 1 or (count == 4 and tokens[0] == "adios")):
        raise ValueError("received bad URL: " + url)
    return tokens
    
if __name__ == "__main__":
    try:
        run_cmd(sys.argv)
    except IOError as e:
        print(e)
        exit(1)
    except ValueError as e:
        print(e)
        exit(1)
    exit(0)
