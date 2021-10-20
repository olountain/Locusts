from ctypes import pythonapi
import matplotlib.pyplot as plt
import numpy as np
from persim import plot_diagrams
from ripser import ripser

# from parse_simout import *
# sys.path.append("/usr/local/oliverlountain/Box/Locusts/Python")

last_frame = parse_last_frame(simout_dict, density = False)
# get locust coords
locust_coords = last_frame

# plot locust coords
plt.scatter(locust_coords[:, 0], locust_coords[:, 1])
plt.axis('equal')
plt.show()

tic()
res = ripser(locust_coords, n_perm=1500)
toc()

dgms_sub = res['dgms']
idx_perm = res['idx_perm']
r_cover = res['r_cover']

plt.figure(figsize=(10, 10))
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
plt.show()

