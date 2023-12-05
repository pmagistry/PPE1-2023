from sudachipy import Dictionary, SplitMode
import errno
import fileinput

tokenizer = Dictionary().create()

try:
    for line in fileinput.input():
        tokens = tokenizer.tokenize(line, SplitMode.B)
        print(" ".join([m.surface() for m in tokens]))
except IOError as e:
    if e.errno != errno.EPIPE:
        raise
