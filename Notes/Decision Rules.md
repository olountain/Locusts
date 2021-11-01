# Decision Rules

Here we discuss some rules by which to classify swarm shapes based on some of the summary statistics which we have investigated. The rules presented here are, of course, very broad and imprecise, but provide a proof of concept that these measures can be used to distinguish between swarm shapes.

## X to Y spread ratio

We begin by considering the simple ratio of x spread to y spread.

| data                     | x_to_y      | x_to_y > 1  |
| ------------------------ | ----------- | ----------- |
| comet                    | 1.68        | TRUE        |
| compact                  | 2.13        | TRUE        |
| dense_blob               | 1.61        | TRUE        |
| ***dense_fanning_blob*** | ***0.735*** | ***FALSE*** |
| ***loose_fan***          | ***0.595*** | ***FALSE*** |
| dense_streams            | 5.86        | TRUE        |
| fanning_streams          | 3.63        | TRUE        |

We note that the fanning swarms can be distinguished from all other swarms on this basis alone.

## X to Y spread and skewness

Next we consider the X to Y spread in combination with the skewness of the distribution of densities among the grid squares. We see that this allows for good discrimination between the streams and all other swarms.

![x_to_y_z_skew](/Users/oliverlountain/Box/Locusts/Analysis/Plots/x_to_y_z_skew.png)



## Landscape Supremum Norms

Next we consider the $L_{\infty}$ norms of the landscape functions of the homology groups $H_0$ and $H_1$. We see that these two variables allow for more discrimination between the swarms. In particular, the norm of $H_1$ allows for discrimination between the more and less dense swarms. The norm of $H_0$, on the other hand distinguishes the dense blob and the compact swarms both from each other and from the remaining swarms. We note that the dense fanning blob and dense streams are not obviously distinguished, but they were previously distinguished by the x to y ratio. The same is true for the comet, fanning streams and loose fan.

![supremum_norms](/Users/oliverlountain/Box/Locusts/Analysis/Plots/supremum_norms.png)