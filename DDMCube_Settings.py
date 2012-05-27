# Define job:
quickNamePrefix = 'MatchedRTSIPSPRT'
dryRun = 0
localRun = 1
runType = 'batch'			# 'batch' or 'wallTimeEstimate'
waitForSims = 1
wallTime = 10000
wallTimeEstCount = 1
queue = 'default'
FD=0

# Divide jobs among processing unit settings:
nodes = 1
procsPerNode = 1
repsPerProc = 1
simsPerRep = 1000

Coh = 6.4
rP = 40 + .4*Coh
rN = 40 - .4*Coh



# Define job settings:
settings={
'theta':list(numpy.arange(0,2,numpy.log(rP/rN))),
'N':[5],
'dt':[.1],
'corr':[.15],
'rP':[rP],
'rN':[rN]}
