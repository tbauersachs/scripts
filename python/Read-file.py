# output the contents of a file from a passed argument
# added comment - tsox

import sys

if len(sys.argv) < 2:
    # thisfile = open("C:/log.txt")
    print ("Must enter a file as an argument")
else:
    thisfile = open(sys.argv[1])
    print(thisfile.read())
    


