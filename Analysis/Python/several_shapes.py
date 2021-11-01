from ctypes import pythonapi
from inspect import signature
import matplotlib.pyplot as plt
from matplotlib.axes import Axes
import numpy as np
import pandas as pd
from pandas.io.formats.format import common_docstring
from persim import plot_diagrams
from persim.landscapes import PersLandscapeApprox, snap_pl
from persim.landscapes.visuals import plot_landscape_approx, plot_landscape_approx_simple, plot_landscape_exact, plot_landscape_exact_simple, plot_landscape_simple, plot_landscape
from ripser import ripser
import sys
from sklearn.decomposition import PCA

sys.path.insert(0, 'Analysis/Python')
from parse_simout import *
from helper_functions import tic, toc



## comet
file = "simout/pattern_ex/comet/comet_job-fa0-fr1-fal1.5-active2700-pause900-rproba0.001-occlu25-jumpD0.2-replicat50.simout"
simout_dict = parse_simout(file)
comet, comet_coords, comet_counts = parse_last_frame(simout_dict, density = False)
comet_data = np.hstack((comet_coords, comet_counts.reshape(len(comet_counts),1)))
np.savetxt("comet_data" + ".csv", comet_data, delimiter=",", header = "x,y,z", comments="")

## compact
file = "simout/pattern_ex/compact/compact-job-fa0.001-fr0.1-fal0.1-active2700-pause900-rproba0.001-occlu25-jumpD0-replicat50.simout"
simout_dict = parse_simout(file)
compact, compact_coords, compact_counts = parse_last_frame(simout_dict, density = False)
compact_data = np.hstack((compact_coords, compact_counts.reshape(len(compact_counts),1)))
np.savetxt("compact_data" + ".csv", compact_data, delimiter=",", header = "x,y,z", comments="")

## dense blob
file = "simout/pattern_ex/dense_blob/dense_blob_job-fa0.001-fr1-fal1.5-active2700-pause900-rproba0.001-occlu25-jumpD0-replicat1.simout"
simout_dict = parse_simout(file)
dense_blob, dense_blob_coords, dense_blob_counts = parse_last_frame(simout_dict, density = False)
dense_blob_data = np.hstack((dense_blob_coords, dense_blob_counts.reshape(len(dense_blob_counts),1)))
np.savetxt("dense_blob_data" + ".csv", dense_blob_data, delimiter=",", header = "x,y,z", comments="")

## dense fanning blob
file = "simout/pattern_ex/dense_fanning_blob/dense_fanning_blob-job-fa0.001-fr3-fal1.5-active2700-pause900-rproba0.001-occlu25-jumpD0-replicat6.simout"
simout_dict = parse_simout(file)
dense_fanning_blob, dense_fanning_blob_coords, dense_fanning_blob_counts = parse_last_frame(simout_dict, density = False)
dense_fanning_blob_data = np.hstack((dense_fanning_blob_coords, dense_fanning_blob_counts.reshape(len(dense_fanning_blob_counts),1)))
np.savetxt("dense_fanning_blob_data" + ".csv", dense_fanning_blob_data, delimiter=",", header = "x,y,z", comments="")

## dense squiggly blob
file = "simout/pattern_ex/dense_squiggly_blob/dense_squiggly-job-fa0.05-fr3-fal0.1-active2700-pause900-rproba0.001-occlu25-jumpD0.2-replicat50.simout"
simout_dict = parse_simout(file)
dense_squiggly_blob, dense_squiggly_blob_coords, dense_squiggly_blob_counts = parse_last_frame(simout_dict, density = False)
dense_squiggly_blob_data = np.hstack((dense_squiggly_blob_coords, dense_squiggly_blob_counts.reshape(len(dense_squiggly_blob_counts),1)))
np.savetxt("dense_squiggly_blob_data" + ".csv", dense_squiggly_blob_data, delimiter=",", header = "x,y,z", comments="")

## dense streams
file = "simout/pattern_ex/dense_streams/dense_streams-job-fa0.001-fr0.1-fal1.5-active2700-pause900-rproba0.001-occlu25-jumpD0.3-replicat47.simout"
simout_dict = parse_simout(file)
dense_streams, dense_streams_coords, dense_streams_counts = parse_last_frame(simout_dict, density = False)
dense_streams, dense_streams_coords, dense_streams_counts = parse_mid_frame(simout_dict, density = False)
dense_streams_data = np.hstack((dense_streams_coords, dense_streams_counts.reshape(len(dense_streams_counts),1)))
np.savetxt("dense_streams_data" + ".csv", dense_streams_data, delimiter=",", header = "x,y,z", comments="")

## fanning streams
file = "simout/pattern_ex/fanning_streams/fanning_streams-job-fa0.001-fr0.1-fal0.1-active2700-pause900-rproba0.001-occlu25-jumpD0.3-replicat6.simout"
simout_dict = parse_simout(file)
fanning_streams, fanning_streams_coords, fanning_streams_counts = parse_last_frame(simout_dict, density = False)
fanning_streams, fanning_streams_coords, fanning_streams_counts = parse_mid_frame(simout_dict, density = False)
fanning_streams_data = np.hstack((fanning_streams_coords, fanning_streams_counts.reshape(len(fanning_streams_counts),1)))
np.savetxt("fanning_streams_data" + ".csv", fanning_streams_data, delimiter=",", header = "x,y,z", comments="")

## loose fan
file = "simout/pattern_ex/loose_fan/loose_fan-job-fa0-fr3-fal0.1-active2700-pause900-rproba0.001-occlu25-jumpD0.2-replicat12.simout"
simout_dict = parse_simout(file)
loose_fan, loose_fan_coords, loose_fan_counts = parse_last_frame(simout_dict, density = False)
loose_fan_data = np.hstack((loose_fan_coords, loose_fan_counts.reshape(len(loose_fan_counts),1)))
np.savetxt("loose_fan_data" + ".csv", loose_fan_data, delimiter=",", header = "x,y,z", comments="")

#### Compute persistence Diagrams

tic()
res_comet = ripser(comet, n_perm=500, maxdim=1) 
toc()
idx_perm_comet = res_comet['idx_perm']

tic()
res_compact = ripser(compact, n_perm=500, maxdim=1) 
toc()
idx_perm_compact = res_compact['idx_perm']

tic()
res_dense_blob = ripser(dense_blob, n_perm=500, maxdim=1) 
toc()
idx_perm_dense_blob = res_dense_blob['idx_perm']

tic()
res_dense_fanning_blob = ripser(dense_fanning_blob, n_perm=500, maxdim=1) 
toc()
idx_perm_dense_fanning_blob = res_dense_fanning_blob['idx_perm']

tic()
res_dense_squiggly_blob = ripser(dense_squiggly_blob, n_perm=500, maxdim=1) 
toc()
idx_perm_dense_squiggly_blob = res_dense_squiggly_blob['idx_perm']

tic()
res_dense_streams = ripser(dense_streams, n_perm=500, maxdim=1) 
toc()
idx_perm_dense_streams = res_dense_streams['idx_perm']

tic()
res_fanning_streams = ripser(fanning_streams, n_perm=500, maxdim=1) 
toc()
idx_perm_fanning_streams = res_fanning_streams['idx_perm']

tic()
res_loose_fan = ripser(loose_fan, n_perm=500, maxdim=1) 
toc()
idx_perm_loose_fan = res_loose_fan['idx_perm']


#### Density scatter plots

plt.figure(figsize=(9, 9))

plt.subplot(331)
plt.scatter(comet_coords[:, 0], comet_coords[:, 1], c = comet_counts, cmap='viridis')
plt.axis('equal')
plt.title('comet')

plt.subplot(332)
plt.scatter(compact_coords[:, 0], compact_coords[:, 1], c = compact_counts, cmap='viridis')
plt.axis('equal')
plt.title('compact')

plt.subplot(333)
plt.scatter(dense_blob_coords[:, 0], dense_blob_coords[:, 1], c = dense_blob_counts, cmap='viridis')
plt.axis('equal')
plt.title('dense blob')

plt.subplot(334)
plt.scatter(dense_fanning_blob_coords[:, 0], dense_fanning_blob_coords[:, 1], c = dense_fanning_blob_counts, cmap='viridis')
plt.axis('equal')
plt.title('dense fanning blob')

plt.subplot(335)
plt.scatter(dense_squiggly_blob_coords[:, 0], dense_squiggly_blob_coords[:, 1], c = dense_squiggly_blob_counts, cmap='viridis')
plt.axis('equal')
plt.title('dense squiggly blob')

plt.subplot(336)
plt.scatter(dense_streams_coords[:, 0], dense_streams_coords[:, 1], c = dense_streams_counts, cmap='viridis')
plt.axis('equal')
plt.title('dense streams')

plt.subplot(337)
plt.scatter(fanning_streams_coords[:, 0], fanning_streams_coords[:, 1], c = fanning_streams_counts, cmap='viridis')
plt.axis('equal')
plt.title('fanning streams')

plt.subplot(338)
plt.scatter(loose_fan_coords[:, 0], loose_fan_coords[:, 1], c = loose_fan_counts, cmap='viridis')
plt.axis('equal')
plt.title('loose fan')

plt.show()



#### scatter plots ----------------------------------------------------------------------------------------------------

plt.figure(figsize=(9, 9))

plt.subplot(331)
plt.scatter(comet[idx_perm_comet, 0], comet[idx_perm_comet, 1])
plt.axis('equal')
plt.title('comet')

plt.subplot(332)
plt.scatter(compact[idx_perm_compact, 0], compact[idx_perm_compact, 1])
plt.axis('equal')
plt.title('compact')

plt.subplot(333)
plt.scatter(dense_blob[idx_perm_dense_blob, 0], dense_blob[idx_perm_dense_blob, 1])
plt.axis('equal')
plt.title('dense blob')

plt.subplot(334)
plt.scatter(dense_fanning_blob[idx_perm_dense_fanning_blob, 0], dense_fanning_blob[idx_perm_dense_fanning_blob, 1])
plt.axis('equal')
plt.title('dense fanning blob')

plt.subplot(335)
plt.scatter(dense_squiggly_blob[idx_perm_dense_squiggly_blob, 0], dense_squiggly_blob[idx_perm_dense_squiggly_blob, 1])
plt.axis('equal')
plt.title('dense squiggly blob')

plt.subplot(336)
plt.scatter(dense_streams[idx_perm_dense_streams, 0], dense_streams[idx_perm_dense_streams, 1])
plt.axis('equal')
plt.title('dense streams')

plt.subplot(337)
plt.scatter(fanning_streams[idx_perm_fanning_streams, 0], fanning_streams[idx_perm_fanning_streams, 1])
plt.axis('equal')
plt.title('fanning streams')

plt.subplot(338)
plt.scatter(loose_fan[idx_perm_loose_fan, 0], loose_fan[idx_perm_loose_fan, 1])
plt.axis('equal')
plt.title('loose fan')

plt.show()


#### Plot persistence diagrams

plt.figure(figsize=(9, 9))

plt.subplot(331)
plot_diagrams(res_comet['dgms'])
plt.title('comet')

plt.subplot(332)
plot_diagrams(res_compact['dgms'])
plt.title('compact')

plt.subplot(333)
plot_diagrams(res_dense_blob['dgms'])
plt.title('dense blob')

plt.subplot(334)
plot_diagrams(res_dense_fanning_blob['dgms'])
plt.title('dense fanning blob')

plt.subplot(335)
plot_diagrams(res_dense_squiggly_blob['dgms'])
plt.title('dense squiggly blob')

plt.subplot(336)
plot_diagrams(res_dense_streams['dgms'])
plt.title('dense streams')

plt.subplot(337)
plot_diagrams(res_fanning_streams['dgms'])
plt.title('fanning streams')

plt.subplot(338)
plot_diagrams(res_loose_fan['dgms'])
plt.title('loose fan')

plt.show()

#### Compute Persistence Landscapes

pers_land_comet_0 = PersLandscapeApprox(dgms = res_comet['dgms'], hom_deg = 0)
pers_land_comet_0.values = pers_land_comet_0.values[0:10,:]
round(pers_land_comet_0.p_norm(1),3)
# 402.729
# 12005.704
round(pers_land_comet_0.p_norm(2),3)
# 41.293
round(pers_land_comet_0.sup_norm(),3)
# 6.563


pers_land_comet_1 = PersLandscapeApprox(dgms = res_comet['dgms'], hom_deg = 1)
pers_land_comet_1.values = pers_land_comet_1.values[0:10,:]
round(pers_land_comet_1.p_norm(1),3)
# 120.879
# 485.704
round(pers_land_comet_1.sup_norm(),3)
# 3.411

pers_land_compact_0 = PersLandscapeApprox(dgms = res_compact['dgms'], hom_deg = 0)
pers_land_compact_0.values = pers_land_compact_0.values[0:10,:]
round(pers_land_compact_0.p_norm(1),3)
# 302.293
# 2450.448
round(pers_land_compact_0.sup_norm(),3)
# 10.795

pers_land_compact_1 = PersLandscapeApprox(dgms = res_compact['dgms'], hom_deg = 1)
pers_land_compact_1.values = pers_land_compact_1.values[0:10,:]
round(pers_land_compact_1.p_norm(1),3)
# 37.158
# 104.474
round(pers_land_compact_1.sup_norm(),3)
# 1.873

pers_land_dense_blob_0 = PersLandscapeApprox(dgms = res_dense_blob['dgms'], hom_deg = 0)
pers_land_dense_blob_0.values = pers_land_dense_blob_0.values[0:10,:]
round(pers_land_dense_blob_0.p_norm(1),3)
# 314.377
# 3581.665
round(pers_land_dense_blob_0.sup_norm(),3)
# 13.482

pers_land_dense_blob_1 = PersLandscapeApprox(dgms = res_dense_blob['dgms'], hom_deg = 1)
pers_land_dense_blob_1.values = pers_land_dense_blob_1.values[0:10,:]
round(pers_land_dense_blob_1.p_norm(1),3)
# 47.232
# 170.391
round(pers_land_dense_blob_1.sup_norm(),3)
# 2.227

pers_land_dense_fanning_blob_0 = PersLandscapeApprox(dgms = res_dense_fanning_blob['dgms'], hom_deg = 0)
pers_land_dense_fanning_blob_0.values = pers_land_dense_fanning_blob_0.values[0:10,:]
round(pers_land_dense_fanning_blob_0.p_norm(1),3)
# 263.87
# 6239.08
round(pers_land_dense_fanning_blob_0.sup_norm(),3)
# 7.89

pers_land_dense_fanning_blob_1 = PersLandscapeApprox(dgms = res_dense_fanning_blob['dgms'], hom_deg = 1)
pers_land_dense_fanning_blob_1.values = pers_land_dense_fanning_blob_1.values[0:10,:]
round(pers_land_dense_fanning_blob_1.p_norm(1),3)
# 61.38
# 268.498
round(pers_land_dense_fanning_blob_1.sup_norm(),3)
# 2.283

pers_land_dense_squiggly_blob_0 = PersLandscapeApprox(dgms = res_dense_squiggly_blob['dgms'], hom_deg = 0)
pers_land_dense_squiggly_blob_0.values = pers_land_dense_squiggly_blob_0.values[0:10,:]
round(pers_land_dense_squiggly_blob_0.p_norm(1),3)
# 527.477
# 2613.92
round(pers_land_dense_squiggly_blob_0.sup_norm(),3)
# 13.702

pers_land_dense_squiggly_blob_1 = PersLandscapeApprox(dgms = res_dense_squiggly_blob['dgms'], hom_deg = 1)
pers_land_dense_squiggly_blob_1.values = pers_land_dense_squiggly_blob_1.values[0:10,:]
round(pers_land_dense_squiggly_blob_1.p_norm(1),3)
# 45.091
# 99.046
round(pers_land_dense_squiggly_blob_1.sup_norm(),3)
# 2.656

pers_land_dense_streams_0 = PersLandscapeApprox(dgms = res_dense_streams['dgms'], hom_deg = 0)
pers_land_dense_streams_0.values = pers_land_dense_streams_0.values[0:10,:]
round(pers_land_dense_streams_0.p_norm(1),3)
# 148.414
# 1725.116
round(pers_land_dense_streams_0.sup_norm(),3)
# 7.795

pers_land_dense_streams_1 = PersLandscapeApprox(dgms = res_dense_streams['dgms'], hom_deg = 1)
pers_land_dense_streams_1.values = pers_land_dense_streams_1.values[0:10,:]
round(pers_land_dense_streams_1.p_norm(1),3)
# 26.287
# 76.314
round(pers_land_dense_streams_1.sup_norm(),3)
# 1.683

pers_land_fanning_streams_0 = PersLandscapeApprox(dgms = res_fanning_streams['dgms'], hom_deg = 0)
pers_land_fanning_streams_0.values = pers_land_fanning_streams_0.values[0:10,:]
round(pers_land_fanning_streams_0.p_norm(1),3)
# 400.894
# 9721.499
round(pers_land_fanning_streams_0.sup_norm(),3)
# 8.527

pers_land_fanning_streams_1 = PersLandscapeApprox(dgms = res_fanning_streams['dgms'], hom_deg = 1)
pers_land_fanning_streams_1.values = pers_land_fanning_streams_1.values[0:10,:]
round(pers_land_fanning_streams_1.p_norm(1),3)
# 130.376
# 444.518
round(pers_land_fanning_streams_1.sup_norm(),3)
# 4.024

pers_land_loose_fan_0 = PersLandscapeApprox(dgms = res_loose_fan['dgms'], hom_deg = 0)
pers_land_loose_fan_0.values = pers_land_loose_fan_0.values[0:10,:]
round(pers_land_loose_fan_0.p_norm(1),3)
# 353.717
# 10201.253
round(pers_land_loose_fan_0.sup_norm(),3)
# 6.091

pers_land_loose_fan_1 = PersLandscapeApprox(dgms = res_loose_fan['dgms'], hom_deg = 1)
pers_land_loose_fan_1.values = pers_land_loose_fan_1.values[0:10,:]
round(pers_land_loose_fan_1.p_norm(1),3)
# 90.509
# 434.232
round(pers_land_loose_fan_1.sup_norm(),3)
# 3.29

#### Plot H_0 landscapes

plt.figure(figsize=(9, 9))

plt.subplot(331)
plot_landscape_simple(pers_land_comet_0)
plt.title('comet')

plt.subplot(332)
plot_landscape_simple(pers_land_compact_0)
plt.title('compact')

plt.subplot(333)
plot_landscape_simple(pers_land_dense_blob_0)
plt.title('dense blob')

plt.subplot(334)
plot_landscape_simple(pers_land_dense_fanning_blob_0)
plt.title('dense fanning blob')

plt.subplot(335)
plot_landscape_simple(pers_land_dense_squiggly_blob_0)
plt.title('dense squiggly blob')

plt.subplot(336)
plot_landscape_simple(pers_land_dense_streams_0)
plt.title('dense streams')

plt.subplot(337)
plot_landscape_simple(pers_land_fanning_streams_0)
plt.title('fanning streams')

plt.subplot(338)
plot_landscape_simple(pers_land_loose_fan_0)
plt.title('loose fan')

plt.show()


#### Plot H_1 landscapes

plt.figure(figsize=(9, 9))

plt.subplot(331)
plot_landscape_simple(pers_land_comet_1)
plt.title('comet')

plt.subplot(332)
plot_landscape_simple(pers_land_compact_1)
plt.title('compact')

plt.subplot(333)
plot_landscape_simple(pers_land_dense_blob_1)
plt.title('dense blob')

plt.subplot(334)
plot_landscape_simple(pers_land_dense_fanning_blob_1)
plt.title('dense fanning blob')

plt.subplot(335)
plot_landscape_simple(pers_land_dense_squiggly_blob_1)
plt.title('dense squiggly blob')

plt.subplot(336)
plot_landscape_simple(pers_land_dense_streams_1)
plt.title('dense streams')

plt.subplot(337)
plot_landscape_simple(pers_land_fanning_streams_1)
plt.title('fanning streams')

plt.subplot(338)
plot_landscape_simple(pers_land_loose_fan_1)
plt.title('loose fan')

plt.show()


pers_land_comet_0.p_norm(1)
pers_land_comet_0.p_norm(2)
pers_land_comet_0.sup_norm()



## plots for friday's meeting

plt.figure(figsize=(17, 10))

plt.subplot(3,4,1)
plt.scatter(comet_coords[:, 0], comet_coords[:, 1], c = comet_counts, cmap='viridis', s = 1)
plt.axis('equal')
plt.axis([0, 512, 0, 512])

plt.subplot(3,4,2)
plot_diagrams(res_comet['dgms'])

plt.subplot(3,4,3)
plot_landscape_simple(pers_land_comet_0)

plt.subplot(3,4,4)
plot_landscape_simple(pers_land_comet_1)

plt.subplot(3,4,5)
plt.scatter(compact_coords[:, 0], compact_coords[:, 1], c = compact_counts, cmap='viridis', s = 1)
plt.axis('equal')
plt.axis([0, 512, 0, 512])

plt.subplot(3,4,6)
plot_diagrams(res_compact['dgms'])

plt.subplot(3,4,7)
plot_landscape_simple(pers_land_compact_0)

plt.subplot(3,4,8)
plot_landscape_simple(pers_land_compact_1)

plt.subplot(3,4,9)
plt.scatter(dense_blob_coords[:, 0], dense_blob_coords[:, 1], c = dense_blob_counts, cmap='viridis', s = 1)
plt.axis('equal')
plt.axis([0, 512, 0, 512])

plt.subplot(3,4,10)
plot_diagrams(res_dense_blob['dgms'])

plt.subplot(3,4,11)
plot_landscape_simple(pers_land_dense_blob_0)

plt.subplot(3,4,12)
plot_landscape_simple(pers_land_dense_blob_1)

plt.show()



plt.figure(figsize=(17, 10))

plt.subplot(3,4,1)
plt.scatter(dense_fanning_blob_coords[:, 0], dense_fanning_blob_coords[:, 1], c = dense_fanning_blob_counts, cmap='viridis', s = 1)
plt.axis('equal')
plt.axis([0, 512, 0, 512])

plt.subplot(3,4,2)
plot_diagrams(res_dense_fanning_blob['dgms'])

plt.subplot(3,4,3)
plot_landscape_simple(pers_land_dense_fanning_blob_0)

plt.subplot(3,4,4)
plot_landscape_simple(pers_land_dense_fanning_blob_1)

plt.subplot(3,4,5)
plt.scatter(dense_squiggly_blob_coords[:, 0], dense_squiggly_blob_coords[:, 1], c = dense_squiggly_blob_counts, cmap='viridis', s = 1)
plt.axis('equal')
plt.axis([0, 512, 0, 512])

plt.subplot(3,4,6)
plot_diagrams(res_dense_squiggly_blob['dgms'])

plt.subplot(3,4,7)
plot_landscape_simple(pers_land_dense_squiggly_blob_0)

plt.subplot(3,4,8)
plot_landscape_simple(pers_land_dense_squiggly_blob_1)

plt.subplot(3,4,9)
plt.scatter(loose_fan_coords[:, 0], loose_fan_coords[:, 1], c = loose_fan_counts, cmap='viridis', s = 1)
plt.axis('equal')
plt.axis([0, 512, 0, 512])

plt.subplot(3,4,10)
plot_diagrams(res_loose_fan['dgms'])

plt.subplot(3,4,11)
plot_landscape_simple(pers_land_loose_fan_0)

plt.subplot(3,4,12)
plot_landscape_simple(pers_land_loose_fan_1)

plt.show()