import numpy as np
import math
import random
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt

envSize = 30
env = np.zeros((envSize,envSize,2)) # 100x100 environment, with two layers - one return trails, one for for exploration trails respectively
print(env.shape)
print(env[0,0,0])
print(env[0,0,1])

#nest = {'x':80,'y':80} # Nest pos
#food = {'x':80,'y':20} # Food pos
nest = {'x':25,'y':25} # Nest pos
food = {'x':5,'y':5} # Food pos

pheroDrop = 1 # How much pheromone is dropped per position
evapRate = 0.01

# Convenience:
X = 'x'
Y = 'y'
FOOD = 'hasFood'

ants = [] # Array of ants
# Ant 'object': (xpos, ypos, hasFood)

getLeavingIndex = lambda ant: 1 if ant[FOOD] else 0
getSensingIndex = lambda ant: 0 if ant[FOOD] else 1
loopBack = lambda n: (n+envSize)%envSize # Looparound
xyOffsets = [(round(math.cos(a)), round(math.sin(a))) for a in [math.pi/8*i for i in range(8)]]# Horrific abuse of list comprehensions to get possible x/y offset paths an ant could take

# Plotting
fig = plt.figure()

# Populate the ants array
for a in range(20):
  ants.append({'x':nest[X], 'y':nest[Y], 'hasFood':True})

for t in range(10000):
  # Move ants
  for ant in ants:
    # Get rid of the ant's food if it's at the nest (depositing)
    if ant[X] == nest[X] and ant[Y] == nest[Y] and ant[FOOD]:
      ant[FOOD] = False
      print("Food Returned")

    # Pick up food if the ant's at the food
    if ant[X] == food[X] and ant[Y] == food[Y] and not ant[FOOD]:
      ant[FOOD] = True
      print("Food Found")

    # Leave current pheromone trail
    env[ant[Y], ant[X], getLeavingIndex(ant)] = env[ant[Y], ant[X], getLeavingIndex(ant)] + pheroDrop

    # Move dependant on whether the ant has food or not
    potentialLocations = [(loopBack(ant[X] + x), loopBack(ant[Y] + y)) for (x,y) in xyOffsets]
    scoredLocations =  [(env[x,y,getSensingIndex(ant)], x,y) for (x, y) in potentialLocations]
    bestLocations = []
    for location in scoredLocations:
      if (len(bestLocations) == 0 or location[0] < bestLocations[0][0]) and not location[0] == 0:
        bestLocations = [location]
      if (len(bestLocations) == 0 or location[0] == bestLocations[0][0]) and not location[0] == 0:
        bestLocations.append(location)
    # Choose a random best location (best location is a location that has the weakest, pheromone trail excluding 0 trail)
    if len(bestLocations) > 0:
      cL = bestLocations[random.randint(0,len(bestLocations)-1)]
      chosenLocation = (cL[1],cL[2])
    else:
      chosenLocation = potentialLocations[random.randint(0,len(potentialLocations)-1)]
    ant[X] = chosenLocation[0]
    ant[Y] = chosenLocation[1]

  # Evaporate things
  for (x,y) in [(x,y) for x in range(envSize) for y in range(envSize)]:
    env[x,y,:] = env[x,y,:] - evapRate
    env[x,y,0] = max(0, env[x,y,0])
    env[x,y,1] = max(0, env[x,y,1])

  # Finally draw the thing:
  if(t%20 == 0):
    plt.imshow(env[:,:,0], cmap = 'inferno')
    plt.pause(0.0001)
