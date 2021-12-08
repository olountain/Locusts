## jitter data
pacman::p_load(tictoc)

data_sets

take_samples <- function(data_set) {
    # data_set <- comet
    
    samples <- vector(mode = "list", length = nrow(data_set))
    
    for (i in 1:nrow(data_set)) {
        samples[[i]] <- numeric(4)
        z <- data_set[i,3] %>% pull(z)
        for (j in 1:3) {
            samples[[i]][j] <- sample(0:z, 1)
            z <- z - samples[[i]][j]
        }
        samples[[i]][4] <- z
        
    }
    
    return(samples)
    
    
}

tic()
samples <- take_samples(comet)
toc()

get_jittered_data <- function(samples) {
    
    # samples <- take_samples(data_set)
    
    jitter_data <- vector(mode = "list", length = 4)
    
    for (i in 1:4){
        jitter_data[[i]] <- data_set    
        jitter_data[[i]]$z <- map(samples, i) %>% unlist()
        jitter_data[[i]] <- jitter_data[[i]] %>% 
            filter(z > 0)
        jitter_data[[i]]$x <- jitter_data[[i]]$x + round(rnorm(nrow(jitter_data[[i]])))
        jitter_data[[i]]$x <- ifelse(jitter_data[[i]]$x > 0, jitter_data[[i]]$x, 0)
        jitter_data[[i]]$y <- jitter_data[[i]]$y + round(rnorm(nrow(jitter_data[[i]])))
        jitter_data[[i]]$y <- ifelse(jitter_data[[i]]$y > 0, jitter_data[[i]]$y, 0)
    }
    
    
    jitter_data <- jitter_data %>%
        map_dfr(~ bind_rows(.)) %>% 
        group_by(x,y) %>%
        summarise(z = sum(z)) %>% 
        ungroup()
    
    return(jitter_data)
    
}


get_jittered_data <- function(data_set) {
    
    # samples <- take_samples(data_set)
    
    jitter_data <- data_set

    jitter_data$z <- jitter_data$z + round(rnorm(nrow(jitter_data), sd = jitter_data$z/5))
    jitter_data$z <- ifelse(jitter_data$z > 0, jitter_data$z, 0)
    
    jitter_data$x <- jitter_data$x + round(rnorm(nrow(jitter_data)))
    jitter_data$x <- ifelse(jitter_data$x > 0, jitter_data$x, 0)
    jitter_data$y <- jitter_data$y + round(rnorm(nrow(jitter_data)))
    jitter_data$y <- ifelse(jitter_data$y > 0, jitter_data$y, 0)
    
    return(jitter_data)
    
}





jitter_data <- get_jittered_data(samples)

size = 512
jitter_data %>% ggplot(aes(x=x, y=y, fill=z)) +
    geom_tile() +
    geom_segment(aes(x=0, xend=0, y=0, yend=size), size = 1)+
    geom_segment(aes(x=size, xend=size, y=0, yend=size), size = 1)+
    geom_segment(aes(x=0, xend=size, y=0, yend=0), size = 1)+
    geom_segment(aes(x=0, xend=size, y=size, yend=size), size = 1)+
    xlim(c(0,size)) +
    ylim(c(0,size)) +
    coord_fixed() +
    scale_fill_viridis_c() +
    theme_minimal() +
    theme(panel.grid = element_blank(),
          axis.text = element_blank(),
          axis.ticks = element_blank(),
          axis.title = element_blank(),
          legend.position = "none")
comet %>% ggplot(aes(x=x, y=y, fill=z)) +
    geom_tile() +
    geom_segment(aes(x=0, xend=0, y=0, yend=size), size = 1)+
    geom_segment(aes(x=size, xend=size, y=0, yend=size), size = 1)+
    geom_segment(aes(x=0, xend=size, y=0, yend=0), size = 1)+
    geom_segment(aes(x=0, xend=size, y=size, yend=size), size = 1)+
    xlim(c(0,size)) +
    ylim(c(0,size)) +
    coord_fixed() +
    scale_fill_viridis_c() +
    theme_minimal() +
    theme(panel.grid = element_blank(),
          axis.text = element_blank(),
          axis.ticks = element_blank(),
          axis.title = element_blank(),
          legend.position = "none")

    







sample(1:nrow(comet), prob = comet$z)


samples <- numeric(4)
z <- 10
for (i in 1:3) {
    samples[i] <- sample(0:z, 1)
    z <- z - samples[i]
}
samples[4] <- z
samples
sum(samples)
