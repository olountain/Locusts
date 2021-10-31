# Summary Statistics

So far I have considered the following summary statistics for distinguishing between shapes of locust swarms:

- X and Y spread
- Ratio of X spread to Y spread
- Number of squares with locusts in them
- Proportion of squares containing above a threshold number of locusts
- Fractal dimension
- X and Y rotations given by PCA
- Standard deviation of the first and second principal components
- $L_1$ norm of the landscapes of the homology groups $H_0$ and $H_1$. Could alternatively consider $L_2$ or $L_{\infty}$ norm.

Measures of spread do a good job of quantifying the broad shape of swarms. There is quite a bit of correlation between several of these variables, and I think that the ratio of  X to Y and the number of squares might be the best combination to keep. The reason being that the ratio of X to Y captures whether the swarm is tall, long or round, and the number of squares captures the size. The proportion of squares captures how dense the swarm is, whether most of the locusts are in a few cells or if they are very spread out. I'm not really sure what the fractal dimension does to be honest. X and Y roations can be useful, but are affected by whether the X or Y spread is larger. The landscapes themselves qualitatively show some distinction between the swarms, but we will have to test whether 1-d projections of this information can be used to distinguish.



The table below shows the summery statistics for the six data sets.

| data                | x_spread | y_spread | x_to_y | num_sqs | prop_above_thresh | fractal_dim | rot_x   | rot_y   | stdev_1 | stdev_2 | land_norm_0 | land_norm_1 |
| ------------------- | -------- | -------- | ------ | ------- | ----------------- | ----------- | ------- | ------- | ------- | ------- | ----------- | ----------- |
| comet               | 334      | 209      | 1.60   | 37501   | 0.422             | 2.72        | 0.999   | -0.0329 | 77.8    | 44.8    | 403.        | 121.        |
| compact             | 165      | 126      | 1.31   | 5084    | 0.356             | 2.34        | 1.00    | -0.0277 | 44.6    | 18.4    | 302.        | 37.2        |
| dense_blob          | 164      | 139      | 1.18   | 10351   | 0.538             | 2.68        | 1.00    | -0.0288 | 42.3    | 25.8    | 314.        | 47.2        |
| dense_fanning_blob  | 159      | 217      | 0.733  | 21348   | 0.504             | 2.67        | -0.0411 | 0.999   | 53.4    | 38.5    | 264.        | 61.4        |
| dense_squiggly_blob | 146      | 166      | 0.880  | 5440    | 0.706             | 2.45        | -0.582  | 0.813   | 38.0    | 35.9    | 527.        | 45.1        |
| loose_fan           | 185      | 308      | 0.601  | 42552   | 0.486             | 2.73        | 0.00751 | 1.00    | 79.0    | 47.6    | 354.        | 90.5        |



I also considered coarsening the grid. After reducing the number of squares by a factor of 16, (now the grid is 128 x 128), the following summary statistics were obtained.

| data                | x_spread | y_spread | x_to_y | num_sqrs | prop_above_thresh | fractal_dim | rot_x      | rot_y   | stdev_1 | stdev_2 |
| ------------------- | -------- | -------- | ------ | -------- | ----------------- | ----------- | ---------- | ------- | ------- | ------- |
| comet               | 83       | 53       | 1.57   | 3302     | 0.492             | 2.48        | 1.00       | -0.0180 | 21.7    | 12.5    |
| compact             | 41       | 31       | 1.32   | 661      | 0.262             | 2.26        | 1.00       | -0.0315 | 10.2    | 6.16    |
| dense_blob          | 40       | 35       | 1.14   | 1002     | 0.452             | 2.24        | 1.00       | -0.0186 | 11.3    | 7.36    |
| dense_fanning_blob  | 39       | 54       | 0.722  | 1755     | 0.622             | 2.43        | -0.0231    | 1.00    | 13.8    | 10.2    |
| dense_squiggly_blob | 36       | 42       | 0.857  | 645      | 0.853             | 2.49        | 0.751      | -0.661  | 9.01    | 8.77    |
| loose_fan           | 46       | 77       | 0.597  | 2879     | 0.826             | 2.50        | -0.0000193 | 1.00    | 19.8    | 12.2    |



I have also looked at the boxplots of the distribution of density values in each swarm, which I think could give some insight into how densely clustered the locusts are in different swarms. For example, he "compact" and "dense squiggly blob" swarms have very right-skewed distributions.



## Density and Persistent Homology Plots

![comp_plot1](/Users/oliverlountain/Box/Locusts/Analysis/Plots/comp_plot1.png)



![comp_plot2](/Users/oliverlountain/Box/Locusts/Analysis/Plots/comp_plot2.png)



## Boxplots

### Original Data

![densities_boxplots_fine](/Users/oliverlountain/Box/Locusts/Analysis/Plots/densities_boxplots_fine.png)

### Coarse Data

![densities_boxplots_coarse](/Users/oliverlountain/Box/Locusts/Analysis/Plots/densities_boxplots_coarse.png)



## Comet as example of coarsening data

### Original

![comet_fine](/Users/oliverlountain/Box/Locusts/Analysis/Plots/comet_fine.png)

### Coarse

![comet_coarse](/Users/oliverlountain/Box/Locusts/Analysis/Plots/comet_coarse.png)



