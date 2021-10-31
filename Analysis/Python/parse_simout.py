import csv
import numpy as np


def parse_simout(file, grid_size = 512) :
    current_frame = 0
    n_indiv = 0
    i_frame = -1

    frame_nb =[]
    n_cells =[]
    n_locusts = [[]]
    hash_val = [[]]


    with open(file) as csvfile:
        read_tsv = csv.reader(csvfile,delimiter = "\t")

        for row in read_tsv:
            if len(row) > 0 and row[0] == "GRID":
                frame = int(row[1])

                if frame != current_frame:
                    if current_frame > 0:
                        n_cells.append(int(n_indiv))
                        hash_val.append([])
                        n_locusts.append([])
                    current_frame = frame
                    i_frame += 1
                    n_indiv = 0
                    frame_nb.append(frame)
                    
                hash_val[i_frame].append(int(row[2]))
                n_locusts[i_frame].append(int(row[3]))
                n_indiv += 1

        n_cells.append(int(n_indiv))

    my_dict = {
        "frame_nb" : frame_nb,
        "n_cells" : n_cells,
        "n_locusts" : n_locusts,
        "hash_val" : hash_val
    }

    return my_dict


def parse_last_frame(simout_dict, grid_size = 512, density = True) :
    
    my_hash = simout_dict["hash_val"][-1]

    locust_coords = np.array([[coord % grid_size, coord // grid_size] for coord in my_hash])
    locust_counts = np.array(simout_dict["n_locusts"][-1])

    if density :
        my_dict = {
            "locust_coords" : locust_coords,
            "locust_counts" : locust_counts
        }

        return my_dict

    else :
        locust_x = [a[0] for a in locust_coords]
        locust_y = [a[1] for a in locust_coords]
        locust_x = np.repeat(locust_x, locust_counts)
        locust_y = np.repeat(locust_y, locust_counts)
        locust_coords_all = np.array([[locust_x[i], locust_y[i]] for i in range(len(locust_x))])

        return (locust_coords_all, locust_coords, locust_counts)


def parse_mid_frame(simout_dict, grid_size = 512, density = True) :
    
    my_hash = simout_dict["hash_val"][48]

    locust_coords = np.array([[coord % grid_size, coord // grid_size] for coord in my_hash])
    locust_counts = np.array(simout_dict["n_locusts"][-1])

    if density :
        my_dict = {
            "locust_coords" : locust_coords,
            "locust_counts" : locust_counts
        }

        return my_dict

    else :
        locust_x = [a[0] for a in locust_coords]
        locust_y = [a[1] for a in locust_coords]
        locust_x = np.repeat(locust_x, locust_counts)
        locust_y = np.repeat(locust_y, locust_counts)
        locust_coords_all = np.array([[locust_x[i], locust_y[i]] for i in range(len(locust_x))])

        return (locust_coords_all, locust_coords, locust_counts)



def export_for_R(last_frame, filename, density = True) :

    if density :
        locust_coords = last_frame["locust_coords"]
        locust_counts = last_frame["locust_counts"]
        out = [[locust_coords[i,0], locust_coords[i,1], locust_counts[i]] for i in range(len(locust_coords))]
        out = np.array(out)
        # write out to csv
        np.savetxt(filename + ".csv", out, delimiter=",", header = "x,y,z", comments="")
    else :
        np.savetxt(filename + ".csv", last_frame, delimiter=",", header = "x,y", comments="")

    



## Driver -----------------------------------------------------------------------------------------------------
# # imports
# import os
# import sys

# sys.path.append("~/usr/local/oliverlountain/Desktop/tictoc")
# tictocpath = os.path.relpath("/usr/local/oliverlountain/Desktop/tictoc")
# sys.path.insert(1, tictocpath)
# from tictoc import *

# # files
# file1 = "simout/rep43/job-fa0.01-fr0.1-fal1-active2700-pause900-rproba0.001-occlu25-jumpD0-replicat43.simout"
# file2 = "job-fa0-fr1-fal1-active2700-pause900-rproba0.001-occlu25-jumpD0.3-replicat1.simout"

# # parse simout file
# tic()
# simout_dict = parse_simout(file1)
# toc()
# simout_dict["frame_nb"]
# simout_dict["n_cells"]
# simout_dict["n_locusts"]
# simout_dict["hash_val"]

# # get locations and densities from last frame
# last_frame = parse_last_frame(simout_dict)
# last_frame["locust_coords"]
# last_frame["locust_counts"]

# # get locations with replicates from last frame
# last_frame = parse_last_frame(simout_dict, density = False)
# last_frame

# # save csv
# export_for_R(last_frame, filename = "test")








#### persitent homology stuff

# plt.scatter(locust_coords_all[:, 0], locust_coords_all[:, 1])
# plt.axis('equal')
# plt.show()

# tic()
# res = ripser(locust_coords_all, n_perm=1000)
# toc()

# dgms_sub = res['dgms']
# idx_perm = res['idx_perm']
# r_cover = res['r_cover']

# plt.figure(figsize=(10, 10))
# plt.subplot(221)
# plt.scatter(locust_coords_all[:, 0], locust_coords_all[:, 1])
# plt.title("Original Point Cloud (%i Points)"%(locust_coords_all.shape[0]))
# plt.axis("equal")
# plt.subplot(222)
# plt.scatter(locust_coords_all[idx_perm, 0], locust_coords_all[idx_perm, 1])
# plt.title("Subsampled Cloud (%i Points)"%(idx_perm.size))
# plt.axis("equal")
# plt.subplot(223)
# plot_diagrams(dgms_sub)
# plt.title("Subsampled persistence diagram")
# plt.show()


