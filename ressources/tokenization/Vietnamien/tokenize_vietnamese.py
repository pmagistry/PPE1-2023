from pyvi import ViTokenizer
import errno
import fileinput

try:
    for line in fileinput.input():
        print(ViTokenizer.tokenize(line))
except IOError as e:
    if e.errno != errno.EPIPE:
        raise
