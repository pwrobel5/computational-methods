#visualize Newton fractal for z^5 + 1 in complex domain
#author: Piotr Wróbel

#epsilon for determining the end of calculations and size of grid
EPS = 1e-4
SIZE = 500

#functions defining p(z), its derivative, and next approximation of Newton's method
def p(z):
    return z ** 5 + 1

def dp(z):
    return 5 * (z ** 4)
    
def next_x(xn):
    return xn - (p(xn) / dp(xn))

#transformation of indexes of net to values: 0 -> -1, SIZE - 1 (max value of index) -> 1
def transform(index):
    return (2 / (SIZE - 1)) * index - 1

#create list of roots of equation (calculated anatically)
import math
roots = []
for i in range(0,5):
    root = math.sin(math.pi * (1/5 + (2 * i) / 5)) * 1.0j + math.cos(math.pi * (1/5 + (2 * i) / 5))
    roots.append(root)

#create array simulating [-1,1] x [-1,1], without (0,0) in which derivative of p vanishes
import numpy as np
net = np.zeros((SIZE,SIZE))

#additional list with scale of array axes (will be neccesary to make plot from matplotlib)
scale = []
for i in range(0, SIZE):
    scale.append(transform(i))

for i in range(0,SIZE):
    for j in range(0,SIZE):
        x = scale[i]
        y = scale[j] * 1.0j
        x0 = x + y
        xn = 100 #big value, just to start while loop
        #real part taken to avoid having imaginary part as a numerical error
        difference = math.sqrt(((xn - x0) * (xn - x0).conjugate()).real) 
        while(difference > EPS):
            xn = next_x(x0)
            difference = math.sqrt(((xn - x0) * (xn - x0).conjugate()).real)
            x0 = xn
        index = -1 #start value
        for r in roots:
            difference = math.sqrt(((xn - r) * (xn - r).conjugate()).real)
            if(difference < EPS):
                index = roots.index(r)
                break
        net[i][j] = index + 1

#drawing and saving .png file
import matplotlib.pyplot as plt
plt.pcolormesh(scale, scale, net)
plt.savefig("wstega_newtona_" + str(SIZE) + ".png")
plt.show()
            
