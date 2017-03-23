import sys
import numpy as np

import matplotlib.mlab as mlab
import matplotlib.pyplot as plot

file = sys.argv[1]
rule = int(sys.argv[2])
filename = 'output/compressed/{0}.{1}.dpcm'.format(file, rule)

def semiLogHistogram(frequencies):

    plot.bar(range(len(frequencies)), frequencies, 1.0, log = True)
    plot.savefig('output/stats/{0}.{1}.png'.format(file, rule))
    plot.clf()

with open(filename, 'r') as f:

    lines = f.readlines()

    maxGrayValue = int(lines[0].rstrip().split(' ')[2])

    predictions = lines[1].rstrip().split(' ')

    for i in range(len(predictions)):
        predictions[i] = np.absolute(int(predictions[i]))

    frequencies = [0] * maxGrayValue

    for i in range(len(predictions)):
        frequencies[predictions[i]] += 1

    semiLogHistogram(frequencies)

    print 'Average: ', np.mean(predictions)
    print 'SD: ', np.std(predictions)
