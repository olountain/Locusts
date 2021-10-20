from ripser import ripser
from persim import plot_diagrams
import matplotlib.pyplot as plt
import matplotlib as mpl
import numpy as np
from sklearn import datasets


data = np.random.random((100,2))
data = np.random.normal(size = (100,2))

data = np.concatenate((np.random.normal(size = (100,2)), np.random.normal(loc = (3,4),size = (100,2))), axis = 0)
plt.scatter(data[:,0], data[:,1])
plt.show()
diagrams = ripser(data)['dgms']
plot_diagrams(diagrams, show=True)

# circles data
data = datasets.make_circles(n_samples=100)[0] + 5 * datasets.make_circles(n_samples=100)[0]
plt.scatter(data[:,0], data[:,1])
plt.show()

# plot diagrams fr H_0 and H_1
dgms = ripser(data)['dgms']
plot_diagrams(dgms, show=True)

# Plot each diagram by itself
plot_diagrams(dgms, plot_only=[0], ax=plt.subplot(121))
plot_diagrams(dgms, plot_only=[1], ax=plt.subplot(122), show = True)

# Homology over Z/3Z
dgms = ripser(data, coeff=3)['dgms']
plot_diagrams(dgms, plot_only=[1], title="Homology of Z/3Z", show=True)

# Homology over Z/7Z
dgms = ripser(data, coeff=3)['dgms']
plot_diagrams(dgms, plot_only=[1], title="Homology of Z/7Z", show=True) # Only plot H_1

# Specify which homology classes to compute
# computes H_0, H_1 and H_2 (default is only up to 1)
dgms = ripser(data, maxdim=2)['dgms']
plot_diagrams(dgms, show=True)

# Specify maximum radius for Rips filtration
dgms = ripser(data, thresh=0.2)['dgms']
plot_diagrams(dgms, show=True)

dgms = ripser(data, thresh=1)['dgms']
plot_diagrams(dgms, show=True)

dgms = ripser(data, thresh=2)['dgms']
plot_diagrams(dgms, show=True)

dgms = ripser(data, thresh=999)['dgms']
plot_diagrams(dgms, show=True)

# plot lifetimes
plot_diagrams(dgms, lifetime=True, show = True)
