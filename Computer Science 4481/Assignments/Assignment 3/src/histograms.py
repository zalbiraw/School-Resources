import sys
import numpy

import matplotlib.mlab as mlab
import matplotlib.pyplot as plot

file = sys.argv[1]
size = int(sys.argv[2])
filename = 'output/compressed/{0}.{1}.lz77'.format(file, size)

def semiLogHistogram(frequencies, type):

    plot.bar(range(len(frequencies)), frequencies, 1.0, log = True)
    plot.savefig('output/stats/{0}.{1}.{2}.png'.format(file, size, type))
    plot.clf()

with open(filename, 'r') as f:

    lines = f.readlines()

    offsets = []
    lengths = []
    offsets_frequencies = [0] * size
    lengths_frequencies = [0] * size

    for line in lines[1:]:
        try:
            offset, length, char = line.rstrip().split(',')

            offset = int(offset)
            length = int(length)

            offsets.append(offset)
            lengths.append(length)

            offsets_frequencies[offset] += 1
            lengths_frequencies[length] += 1
        
        except Exception as e:
            pass

    j = 0
    for i in range(len(lengths_frequencies)):
        if (lengths_frequencies[i]):
            j = i

    lengths_frequencies = lengths_frequencies[: j + 1]

    semiLogHistogram(offsets_frequencies, 'offsets')
    semiLogHistogram(lengths_frequencies, 'lengths')

    print 'Offsets: -'
    print '\t - Average: ', numpy.mean(offsets)
    print '\t - SD: ', numpy.std(offsets)

    print 'Lengths: -'
    print '\t - Average: ', numpy.mean(lengths)
    print '\t - SD: ', numpy.std(lengths)
