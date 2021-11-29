import glob
import numpy as np
from persim.landscapes import PersLandscapeApprox
from ripser import ripser
import sys
import os
from progress.bar import Bar
from time import sleep

persistence = False
persistence_only = False

sys.path.insert(0, 'Analysis/Python')
from parse_simout import *
from helper_functions import tic, toc

my_files = glob.glob("../../Desktop/simout_files/run-121918-cuspp-couple1/fa0.03-fr3-fal1.5-active2700-pause90-rproba0.5-occlu25-jumpD0.15/**/*.simout", recursive=True)
tic()
count = 0
with Bar() as bar:
    for file in my_files:
        count += 1
        if count % (len(my_files) // 1) == 0:
            bar.next()

        
        # if not os.path.isfile(os.path.dirname("processed_data/" + new_loc + ".csv")):
        simout_dict = parse_simout(file)
        coord_counts, coords, counts = parse_last_frame(simout_dict, density = False)
        data = np.hstack((coords, counts.reshape(len(counts),1)))
        new_loc = os.path.splitext(file)[0].split('../../')[-1]
        os.makedirs(os.path.dirname("processed_data/" + new_loc), exist_ok=True)
        np.savetxt("processed_data/" + new_loc + ".csv", data, delimiter=",", header = "x,y,z", comments="")

toc()

        if persistence:

            my_diag = ripser(coord_counts, n_perm=500, maxdim=1)
            idx_perm = my_diag['idx_perm']

            pers_land_0 = PersLandscapeApprox(dgms = my_diag['dgms'], hom_deg = 0)
            pers_land_0.values = pers_land_0.values[0:10,:]

            pers_land_1 = PersLandscapeApprox(dgms = my_diag['dgms'], hom_deg = 1)
            pers_land_1.values = pers_land_1.values[0:10,:]


            pers_out = [
                round(pers_land_0.p_norm(2),6),
                round(pers_land_0.sup_norm(),6),
                round(pers_land_1.p_norm(2),6),
                round(pers_land_1.sup_norm(),6)
            ]
            
            np.savetxt("processed_data/" + new_loc + "_persistence.tsv", pers_out, delimiter="\t", header = "2_norm_0\tsup_norm_0\t2_norm_1\tsup_norm_1", comments="")


toc()




os.path.isfile(os.path.dirname("processed_data/" + new_loc + ".csv"))

## might need to work out how to add functionality about which frame to parse


os.path.splitext(tmp)[0]