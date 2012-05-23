#  DDMCube.pyx
#  Created by nicain on 11/1/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.

# Wrapper for the RNG:
cdef extern from "MersenneTwister.h":
    ctypedef struct c_MTRand "MTRand":
        double randNorm( double mean, double stddev)
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
#    cdef float xCurr, tCurr, yCurrP, yCurrN, C, xStd, xTau, xNoise, COn, CPost, tFrac, tieBreak,tBeginFrac, tBegin, CNull
#    cdef float dt, theta, crossTimes, results, chop, beta, K, yTau, A, B, yBegin, tMax,chopHat, noiseSigma


    cdef int i, overTime
    cdef double N, corr, dt, rP, rN
    cdef double t, results, crossTimes
    cdef unsigned long mySeed[624]
    cdef c_MTRand myTwister
    cdef double mean = 0, std = 1
    
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
    crossTimesArray = zeros(totalLength, dtype=float)

    # Initialization of random number generator:
    myUUID = uuid.uuid4()
    random.seed(myUUID.int)
    for i in range(624): mySeed[i] = random.randint(0,int(exp(21)))
    myTwister.seed(mySeed)

    # Parameter space loop:
    counter = 0
    for currentSettings in settingsIterator:
        N, corr, dt, rP, rN = currentSettings        # Must be alphabetized, with capitol letters coming first!


        # Initialize for current loop
        t = 0
        crossTimes = 0
        results = 0

        # Loop across number of sims, at this point in parameter space
        for i in range(perLoc):
            results += 1
            crossTimes += 1
                    
                    

        # Record results:
        resultsArray[counter] = results
        crossTimesArray[counter] = crossTimes
        counter += 1

    return (resultsArray, crossTimesArray)