#  DDMCube.pyx
#  Created by nicain on 11/1/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.

# Wrapper for the RNG:
cdef extern from "MersenneTwister.h":
    ctypedef struct c_MTRand "MTRand":
        double randDblExc()
        void seed( unsigned long bigSeed[])

# External math functions that are needed:
cdef extern from "math.h":
    float sqrt(float sqrtMe)
    float fabs(float absMe)

################################################################################
######################## Main function, the workhorse:  ########################
################################################################################
def DDMOU(settings, int FD,int perLoc):

    # Import necessary python packages:
    import random, uuid, os, product
    from numpy import zeros
    from math import exp
    
    # C initializations
    cdef int i, currN
    cdef float corr, dt, rP, rN
    cdef int N, tempS
    cdef float t, results, overShootP, overShootN, theta
    cdef unsigned long mySeed[624]
    cdef c_MTRand myTwister
    cdef float cumSum
    
    # Convert settings dictionary to iterator:
    params = settings.keys()
    params.sort()
    settingsList = []
    totalLength = 1
    for parameter in params: 
        settingsList.append(settings[parameter])
        totalLength *= len(settings[parameter])
    settingsIterator = product.product(*settingsList)
    resultsArray = zeros(totalLength, dtype=float)
    overShootArray = zeros(totalLength, dtype=complex)

    # Initialization of random number generator:
    myUUID = uuid.uuid4()
    random.seed(myUUID.int)
    for i in range(624): mySeed[i] = random.randint(0,int(exp(21)))
    myTwister.seed(mySeed)

    # Parameter space loop:
    counter = 0
    for currentSettings in settingsIterator:
        N, corr, dt, rN, rP, theta = currentSettings   # Alphabetized, caps first!

        # Initialize for current parameter space value
        overShootP = 0
        overShootN = 0
        results = 0
        
        # Loop across number of sims, at this point in parameter space
        for i in range(perLoc):
            
            # Initilize DDM
            t = 0
            cumSum = 0
            while fabs(cumSum) < theta:
                
                # Increment time
                t += dt
            
                # Pref population:
                if myTwister.randDblExc() < dt*rP*.001*corr:
                    cumSum += N
                else:
                    for currN in range(N):
                        if myTwister.randDblExc() < dt*rP*.001*(1-corr):
                            cumSum += 1
                                
                # Null population:
                if myTwister.randDblExc() < dt*rN*.001*corr:
                    cumSum -= N
                else:
                    for currN in range(N):
                        if myTwister.randDblExc() < dt*rN*.001*(1-corr):
                            cumSum -= 1

                    
            # Decide correct or not:
            if cumSum >= theta:
                results += 1
                overShootP += cumSum - theta
            else:
                overShootN += cumSum + theta                    

        # Record results:
        resultsArray[counter] = results
        overShootArray[counter] = overShootP + 1J*overShootN
        counter += 1

    return (resultsArray, overShootArray)