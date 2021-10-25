from ctypes import pythonapi
from inspect import signature
import matplotlib.pyplot as plt
import numpy as np
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
last_frame = parse_last_frame(simout_dict, density = False)
comet = last_frame

## compact
file = "simout/pattern_ex/compact/compact-job-fa0.001-fr0.1-fal0.1-active2700-pause900-rproba0.001-occlu25-jumpD0-replicat50.simout"
simout_dict = parse_simout(file)
last_frame = parse_last_frame(simout_dict, density = False)
compact = last_frame

## dense blob
file = "simout/pattern_ex/dense_blob/dense_blob_job-fa0.001-fr1-fal1.5-active2700-pause900-rproba0.001-occlu25-jumpD0-replicat1.simout"
simout_dict = parse_simout(file)
last_frame = parse_last_frame(simout_dict, density = False)
dense_blob = last_frame

## dense fanning blob
file = "simout/pattern_ex/dense_fanning_blob/dense_fanning_blob-job-fa0.001-fr3-fal1.5-active2700-pause900-rproba0.001-occlu25-jumpD0-replicat6.simout"
simout_dict = parse_simout(file)
last_frame = parse_last_frame(simout_dict, density = False)
dense_fanning_blob = last_frame

## dense squiggly blob
file = "simout/pattern_ex/dense_squiggly_blob/dense_squiggly-job-fa0.05-fr3-fal0.1-active2700-pause900-rproba0.001-occlu25-jumpD0.2-replicat50.simout"
simout_dict = parse_simout(file)
last_frame = parse_last_frame(simout_dict, density = False)
dense_squiggly_blob = last_frame

## dense streams
file = "simout/pattern_ex/dense_streams/dense_streams-job-fa0.001-fr0.1-fal1.5-active2700-pause900-rproba0.001-occlu25-jumpD0.3-replicat47.simout"
simout_dict = parse_simout(file)
last_frame = parse_last_frame(simout_dict, density = False)
dense_streams = last_frame

## fanning streams
file = "simout/pattern_ex/fanning_streams/fanning_streams-job-fa0.001-fr0.1-fal0.1-active2700-pause900-rproba0.001-occlu25-jumpD0.3-replicat6.simout"
simout_dict = parse_simout(file)
last_frame = parse_last_frame(simout_dict, density = False)
fanning_streams = last_frame

## loose fan
file = "simout/pattern_ex/loose_fan/loose_fan-job-fa0-fr3-fal0.1-active2700-pause900-rproba0.001-occlu25-jumpD0.2-replicat12.simout"
simout_dict = parse_simout(file)
last_frame = parse_last_frame(simout_dict, density = False)
loose_fan = last_frame

#### scatter plots ----------------------------------------------------------------------------------------------------

plt.figure(figsize=(9, 9))

plt.subplot(331)
plt.scatter(comet[:, 0], comet[:, 1])
plt.axis('equal')
plt.title('comet')

plt.subplot(332)
plt.scatter(compact[:, 0], compact[:, 1])
plt.axis('equal')
plt.title('compact')

plt.subplot(333)
plt.scatter(dense_blob[:, 0], dense_blob[:, 1])
plt.axis('equal')
plt.title('dense_blob')

plt.subplot(334)
plt.scatter(dense_fanning_blob[:, 0], dense_fanning_blob[:, 1])
plt.axis('equal')
plt.title('dense_fanning_blob')

plt.subplot(335)
plt.scatter(dense_squiggly_blob[:, 0], dense_squiggly_blob[:, 1])
plt.axis('equal')
plt.title('dense_squiggly_blob')

plt.subplot(336)
plt.scatter(dense_streams[:, 0], dense_streams[:, 1])
plt.axis('equal')
plt.title('dense_streams')

plt.subplot(337)
plt.scatter(fanning_streams[:, 0], fanning_streams[:, 1])
plt.axis('equal')
plt.title('fanning_streams')

plt.subplot(338)
plt.scatter(loose_fan[:, 0], loose_fan[:, 1])
plt.axis('equal')
plt.title('loose_fan')

plt.show()
