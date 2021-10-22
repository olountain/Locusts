from ctypes import pythonapi
from inspect import signature
import matplotlib.pyplot as plt
import numpy as np
from persim import plot_diagrams
from persim.landscapes import PersLandscapeApprox, snap_pl
from persim.landscapes.visuals import plot_landscape_approx, plot_landscape_approx_simple, plot_landscape_exact, plot_landscape_exact_simple, plot_landscape_simple, plot_landscape
from ripser import ripser
import os
import sys
from sklearn.decomposition import PCA

# include this folder in the path and import parse_simout
sys.path.insert(0, 'Analysis/Python')
from parse_simout import *

# include tictoc folder in the path
sys.path.append("~/usr/local/oliverlountain/Desktop/tictoc")
tictocpath = os.path.relpath("/usr/local/oliverlountain/Desktop/tictoc")
sys.path.insert(1, "/../../Desktop/tictoc")
from tictoc import *


## rep 43
file1 = "simout/rep43/job-fa0.01-fr0.1-fal1-active2700-pause900-rproba0.001-occlu25-jumpD0-replicat43.simout"
simout_dict = parse_simout(file1)
last_frame = parse_last_frame(simout_dict, density = False)
# get locust coords
locust_coords = last_frame

# plot locust coords
plt.scatter(locust_coords[:, 0], locust_coords[:, 1])
plt.axis('equal')
plt.show()

tic()
res = ripser(locust_coords, n_perm=700, maxdim=1) 
toc()

dgms_sub = res['dgms']
idx_perm = res['idx_perm']
r_cover = res['r_cover']

pers_land = PersLandscapeApprox(dgms = dgms_sub, hom_deg = 0)
pers_land.values = pers_land.values[0:10,:] # consider only the first ten landscapes

plt.figure(figsize=(8, 8))
plt.subplot(221)
plt.scatter(locust_coords[:, 0], locust_coords[:, 1])
plt.title("Original Point Cloud (%i Points)"%(locust_coords.shape[0]))
plt.axis("equal")
plt.subplot(222)
plt.scatter(locust_coords[idx_perm, 0], locust_coords[idx_perm, 1])
plt.title("Subsampled Cloud (%i Points)"%(idx_perm.size))
plt.axis("equal")
plt.subplot(223)
plot_diagrams(dgms_sub)
plt.title("Subsampled persistence diagram")
plt.subplot(224)
plot_landscape_simple(pers_land)
plt.title("Subsampled persistence landscape")
plt.show()






## rep1
file2 = "simout/rep1/job-fa0-fr1-fal1-active2700-pause900-rproba0.001-occlu25-jumpD0.3-replicat1.simout"

simout_dict = parse_simout(file2)
last_frame = parse_last_frame(simout_dict, density = False)
# get locust coords
locust_coords_1 = last_frame

plt.scatter(locust_coords_1[:, 0], locust_coords_1[:, 1])
plt.axis('equal')
plt.show()

tic()
res_1 = ripser(locust_coords_1, n_perm=700, maxdim=1) 
toc()

dgms_sub_1 = res_1['dgms']
idx_perm_1 = res_1['idx_perm']
r_cover_1 = res_1['r_cover']

pers_land_1 = PersLandscapeApprox(dgms = dgms_sub_1, hom_deg = 0)
pers_land_1.values = pers_land_1.values[0:10,:] # consider only the first ten landscapes

plt.figure(figsize=(8, 8))
plt.subplot(221)
plt.scatter(locust_coords_1[:, 0], locust_coords_1[:, 1])
plt.title("Original Point Cloud (%i Points)"%(locust_coords_1.shape[0]))
plt.axis("equal")
plt.subplot(222)
plt.scatter(locust_coords_1[idx_perm, 0], locust_coords_1[idx_perm, 1])
plt.title("Subsampled Cloud (%i Points)"%(idx_perm.size))
plt.axis("equal")
plt.subplot(223)
plot_diagrams(dgms_sub_1)
plt.title("Subsampled persistence diagram")
plt.subplot(224)
plot_landscape_simple(pers_land_1)
plt.title("Subsampled persistence landscape")
plt.show()

## compare via landscapes
[pers_land_snapped, pers_land_snapped_1] = snap_pl([pers_land, pers_land_1])
true_diff_pl = pers_land_snapped - pers_land_snapped_1
significance = true_diff_pl.sup_norm()
significance

## this comparison can be done with permutation testing or ML etc


plt.figure(figsize=(12,8))
plt.subplot(121)
plot_landscape_simple(pers_land_snapped)
plt.subplot(122)
plot_landscape_simple(pers_land_snapped_1)
plt.show()


plt.figure(figsize=(12,8))
plt.subplot(121)
plot_diagrams(dgms_sub)
plt.subplot(122)
plot_diagrams(dgms_sub_1)
plt.show()


plt.figure(figsize=(12,8))
plt.subplot(221)
plot_diagrams(dgms_sub)
plt.subplot(222)
plot_diagrams(dgms_sub_1)
plt.subplot(223)
plot_landscape_simple(pers_land)
plt.subplot(224)
plot_landscape_simple(pers_land_1)
plt.show()



# sampling to create training data for ML
from random import sample

smpl_sz = 100
n_smpls = 10
sample_1 = [[[0]*2] * n_smpls] * smpl_sz
sample_1 = np.array(sample_1)

for i in range(100):
    row_smpl = sample(range(locust_coords.shape[0]),n_smpls)
    sample_1[i,:,:] = locust_coords[row_smpl,:]



sample_1[0,:,:]