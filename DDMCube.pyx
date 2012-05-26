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
    cdef float corr, corrInv, dt, rP, rN
    cdef int N, tempS
    cdef float t, results, overShootP, theta
    cdef unsigned long mySeed[624]
    cdef c_MTRand myTwister
    cdef float cumSum, wp1, wp0, wn1, wn0, P0,P1, N0, N1
    cdef float logP1N1Ratio, logN1P1Ratio
    
    
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
    cdef np.ndarray[DTYPE_t, ndim=1] binCoeff = np.zeros(NMax, dtype=DTYPE)

    # Parameter space loop:
    counter = 0
    for currentSettings in settingsIterator:
        N, corr, dt, rN, rP, theta = currentSettings   # Alphabetized, caps first!

        # Initialize for current parameter space value
        corrInv = 1/corr
        overShootP = 0
        results = 0
        for i in range(N+1):
            binCoeff[i] = scipy.misc.comb(N,i)*(corr)**i*(1-corr)**(N-i)
        P0 = (1-dt*rP*.001*corrInv)
        N0 = (1-dt*rN*.001*corrInv)
        P1 = (dt*rP*.001*corrInv)
        N1 = (dt*rN*.001*corrInv)
        logP1N1Ratio = log(P1/N1)
        logN1P1Ratio = log(N1/P1)
        
        # Loop across number of sims, at this point in parameter space
        for i in range(perLoc):
            
            # Initilize DDM
            t = 0
            cumSum = 0
            while fabs(cumSum) < theta:
                
                # Increment time
                t += dt
            
                # Pref population:
                if myTwister.randDblExc() < dt*rP*.001*corrInv:
                    tempS = 0
                    for currN in range(N):
                        if myTwister.randDblExc() < corr:
                            tempS += 1
                
                    if tempS == 0:
                        wp1 = log(P0 + P1*binCoeff[tempS])
                        wp0 = log(N0 + N1*binCoeff[tempS])
                    else:
                        wp1 = logP1N1Ratio
                        wp0 = 0
                    cumSum += wp1 - wp0

                # Null population
                if myTwister.randDblExc() < dt*rN*.001*corrInv:
                    tempS = 0
                    for currN in range(N):
                        if myTwister.randDblExc() < corr:
                            tempS += 1

                    if tempS == 0:
                        wn1 = log(N0 + N1*binCoeff[tempS])
                        wn0 = log(P0 + P1*binCoeff[tempS])
                    else:
                        wn1 = logN1P1Ratio
                        wn0 = 0
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