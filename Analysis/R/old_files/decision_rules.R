source("Analysis/R/fractal_dim.R")

summs

important_summs <- summs %>%
    select(data, x_to_y, num_sqrs, prop_above_thresh, fractal_dim, z_skew,
           land_norm_0, land_norm_1, sup_norm_0, sup_norm_1)



important_summs %>% select(-data,
                           -land_norm_0,
                           -land_norm_1,
                           -prop_above_thresh,
                           -fractal_dim,
                           -num_sqrs) %>% cor() %>% corrplot::corrplot()

important_summs %>% select(-data,
                           -land_norm_0,
                           -land_norm_1,
                           -prop_above_thresh,
                           -fractal_dim,
                           -num_sqrs) %>% pairs()


m## decision rule ---------------------------------------------------------------------------------

# x_to_y < 1
    # fan
# x_to_y > 1
    # x_to_y > 2.5 (or 3?)
        # stream
    # x_to_y < 2.5 (or 3?)
        # comet/compact/blob
        # sup_norm_1 > 3 (alternatively num_sqrs > 25000)
            # comet
        # sup_norm_1 < 3 (alternatively num_sqrs < 25000)
            # sup_norm_0 > 12
                # dense_blob
            # sup_norm_0 < 12
                # compact



# ratio of max to q3?
# or q3 to q2?

important_summs %>%
    ggplot(aes(land_norm_0, land_norm_1)) +
    geom_point() +
    geom_text(aes(label = data))

important_summs %>%
    mutate(my_col = as.character(c(1,2,3,4,1,4,1))) %>% 
    ggplot(aes(sup_norm_0, sup_norm_1, color = my_col)) +
    geom_point() +
    geom_text(aes(label = data), nudge_y = 0.1) +
    geom_vline(aes(xintercept = 9.5)) +
    geom_vline(aes(xintercept = 12)) +
    geom_hline(aes(yintercept = 3)) +
    theme(legend.position = "none") +
    xlim(6,14)

important_summs %>%
    ggplot(aes(x_to_y, z_skew, color = x_to_y > 3)) +
    geom_point() +
    geom_text(aes(label = data), nudge_y = 0.1) +
    theme(legend.position = "none") +
    xlim(0.3,6.1)

important_summs %>% 
    filter(data %in% c("comet", "loose_fan")) %>% 
    ggplot(aes(x = data, y = x_to_y, fill = x_to_y > 1)) +
    geom_col() +
    geom_hline(aes(yintercept = 1))
    theme(legend.position = "none")

pairs(important_summs[,-1])






important_data_sets <- data_sets
important_data_sets$dense_squiggly_blob <- NULL
important_data_sets %>%
    map_dfr(~ bind_rows(.), .id = "data") %>% 
    filter(z > 5) %>%
    ggplot(aes(x=x, y=y, fill=z)) +
    geom_tile() +
    geom_segment(aes(x=0, xend=0, y=0, yend=size), size = 1)+
    geom_segment(aes(x=size, xend=size, y=0, yend=size), size = 1)+
    geom_segment(aes(x=0, xend=size, y=0, yend=0), size = 1)+
    geom_segment(aes(x=0, xend=size, y=size, yend=size), size = 1)+
    xlim(c(0,size)) +
    ylim(c(0,size)) +
    coord_fixed() +
    facet_wrap(facets = vars(data)) +
    scale_fill_viridis_c() +
    theme_minimal() +
    theme(panel.grid = element_blank(),
          axis.text = element_blank(),
          axis.ticks = element_blank(),
          axis.title = element_blank(),
          legend.position = "none")


important_data_sets %>%
    map_dfr(~ bind_rows(.), .id = "data") %>% 
    filter(z > 5) %>%
    ggplot(aes(y =  z, x = data)) +
    geom_boxplot() +
    ylab("density")

skewness(fanning_streams$z)
kurtosis(fanning_streams$z)
