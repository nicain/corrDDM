# Define job:
quickNamePrefix = 'corrDDMSIPSI'
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
simsPerRep = 10

# Define job settings:
settings={
'theta':list(numpy.linspace(.01,1000,10)),
'N':[240],
'dt':[.1],
'corr':[.15],
'rP':[rP],
'rN':[rN]}
