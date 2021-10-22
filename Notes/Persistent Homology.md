# Persistent Homology

## Key Idea

Construct a network from your data points in $\mathbb{R}^n$, joining points if they are within a threshold distance $\varepsilon$ of one another. This results in a set of line segments, filled faces, volumes etc known as a *simplicial complex*. This allows for a notion of shape or connectedness within your data, measured by what are known as the *Betti numbers* $b_0, b_1, b_2, \dots$ of the complex. Loosely speaking, the first three Betti numbers tell you the number of connected components, loops and trapped volumes, respectively in your complex (the sets of these features are contained in what is known as the *$k$-th homology group* $H_k$, and the $k$-th Betti number $b_k$ is the cardinality of the $k$-th homology group). Now, the choice of threshold distance $\varepsilon$ made earlier was somewhat arbitrary. To address this, we consider a range of values of $\varepsilon$, in theory, $[0,\infty)$, and then construct the simplicial complex and compute the Betti numbers for each value in this interval. If the connected components, loops and trapped volumes *persist* over a range of threhsold distances, we can consider them to be *persistent* properties of the data, as opposed to ones which are true only for intervals which can be considered fleeting, or noise. It is from this that the term persistent homology arises. The intervals of $\varepsilon$ for which these proporties exist become key characterisitcs of our data, and are represented in what are known as persistence barcodes and persistence diagrams. These are visualisations which give us insight into the topological properties of our data, and can be (invertibly) transformed into what are known as persistence landscapes, which can be thought of as *summary statistics* of sorts, and used to compare sets of data via statistical tehniques such as machine learning or permutation testing. Pairs of persistence diagrams can also be compared via the *bottleneck distance* between them.

## Procedure

### Summarising Data using Persistent Homology

1. Construct simplicial complex of your data as a function of $\varepsilon$

2. Calculate the first two or three homology groups ($H_0, H_1, H_2$) of the simplicial complex as funtions of $\varepsilon$ (known also as *persistence modules*).

   - Each element can be represented by the endpoints of the interval of $\varepsilon$ Over which the feature persists.

   - These can be visually represented as persistence barcodes or diagrams.

3. Transform the persistence modules into persistence landscapes.

   - These landscapes $\lambda(n,t)$ are functions of a parameter $t$ which varies over the range of $\varepsilon$.
   - For each homology group, there are a number of persistence landscapes, indexed by $n$ defined as $\lambda(n,t) = \sup\{ h \geq 0 | [t-h, t+h] \subset I_j \text{ for at least } n \text{ distinct } j \}$ where $\{I_j\}$ is the persistnence module/barcode.
   - We can consider the first few persistence landscapes for each homology group to summarise the data.

### Classifying Data

1. Having established that persistence landscapes provide a summary of a point cloud, we can consider the persistence landscapes (of which we will have several for each homology group) as features for a machine learning model.
2. We can then obtain a training set of point clouds labelled by their (qualitative) shape, and compute the persistence landscapes for each observation.
3. Train a machine learning model on this set to classify point clouds based on their persistent homology.