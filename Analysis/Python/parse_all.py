import glob
import sys
import os

sys.path.insert(0, 'Analysis/Python')
from parse_simout import *
from helper_functions import tic, toc

my_files = glob.glob("simout/pattern_ex/**/*.simout", recursive=True)
tic()
for file in my_files:
    simout_dict = parse_simout(file)
    _, coords, counts = parse_last_frame(simout_dict, density = False)
    data = np.hstack((coords, counts.reshape(len(counts),1)))
    os.makedirs(os.path.dirname("processed_data/" + os.path.splitext(file)[0]), exist_ok=True)
    np.savetxt("processed_data/" + os.path.splitext(file)[0] + ".csv", data, delimiter=",", header = "x,y,z", comments="")

toc()



## might need to work out how to add functionality about which frame to parse