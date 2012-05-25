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
    float log(float logMe)

# Import essential c packages:
import numpy as np
cimport numpy as np
cimport cython

# Compile-time type initialization for numpy arrays:
ctypedef np.float_t DTYPE_t    

################################################################################
######################## Main function, the workhorse:  ########################
################################################################################
@cython.boundscheck(False)
def DDMOU(settings, int FD,int perLoc):

    # Import necessary python packages:
    import random, uuid, os, product
    from numpy import zeros
    from math import exp
    import scipy
    
    # C initializations
    cdef int i, currN
    cdef float corr, dt, rP, rN
    cdef int N, tempS
    cdef float t, results, overShootP, theta
    cdef unsigned long mySeed[624]
    cdef c_MTRand myTwister
    cdef float cumSum, wp1, wp0, wn1, wn0, P0,P1, N0, N1
    
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
    overShootArray = zeros(totalLength, dtype=float)

    # Initialization of random number generator:
    myUUID = uuid.uuid4()
    random.seed(myUUID.int)
    for i in range(624): mySeed[i] = random.randint(0,int(exp(21)))
    myTwister.seed(mySeed)

    
    # for numpy
    DTYPE = np.float                    # Initialize a data-type for the array
    NMax = 1000
    cdef np.ndarray[DTYPE_t, ndim=1] binCoeffP = np.zeros(NMax, dtype=DTYPE)
    cdef np.ndarray[DTYPE_t, ndim=1] binCoeffN = np.zeros(NMax, dtype=DTYPE) 

    # Parameter space loop:
    counter = 0
    for currentSettings in settingsIterator:
        N, corr, dt, rN, rP, theta = currentSettings   # Alphabetized, caps first!

        # Initialize for current parameter space value
        overShootP = 0
        overShootN = 0
        results = 0
        for i in range(N+1):
            binCoeffP[i] = scipy.misc.comb(N,i)*(dt*rP*.001*(1-corr))**i*(1-(dt*rP*.001*(1-corr)))**(N-i)
            binCoeffN[i] = scipy.misc.comb(N,i)*(dt*rN*.001*(1-corr))**i*(1-(dt*rN*.001*(1-corr)))**(N-i)
        P0 = (1-dt*rP*.001/corr)
        N0 = (1-dt*rN*.001/corr)
        P1 = (dt*rP*.001/corr)
        N1 = (dt*rN*.001/corr)
        
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
                    tempS = N
                else:
                    tempS = 0
                    for currN in range(N):
                        if myTwister.randDblExc() < dt*rP*.001*(1-corr):
                            tempS += 1
                if tempS==N:
                    wp1 = log(P1 + P0*(dt*rP*.001*corr)**N)
                    wp0 = log(N1 + N0*(dt*rN*.001*corr)**N)
                else:
                    wp1 = log(P0*binCoeffP[tempS])
                    wp0 = log(N0*binCoeffN[tempS])
                cumSum += wp1 - wp0
                                
                # Null population:
                if myTwister.randDblExc() < dt*rN*.001*corr:
                    tempS = N
                else:
                    tempS = 0
                    for currN in range(N):
                        if myTwister.randDblExc() < dt*rN*.001*(1-corr):
                            tempS += 1
                if tempS==N:
                    wn1 = log(N1 + N0*(dt*rN*.001*corr)**N)
                    wn0 = log(P1 + P0*(dt*rP*.001*corr)**N)
                else:
                    wn1 = log(N0*binCoeffN[tempS])
                    wn0 = log(P0*binCoeffP[tempS])
                cumSum += wn1 - wn0

                    
            # Decide correct or not:
            if cumSum >= theta:
                results += 1
                overShootP += cumSum - theta
                    
                    

        # Record results:
        resultsArray[counter] = results
        overShootArray[counter] = overShootP
        counter += 1

    return (resultsArray, overShootArray)