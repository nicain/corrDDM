# Define job:
quickNamePrefix = 'corrDDMDebug'
dryRun = 0
localRun = 1
runType = 'batch'			# 'batch' or 'wallTimeEstimate'
waitForSims = 1
wallTime = 5000
wallTimeEstCount = 1
queue = 'default'
FD=0

# Divide jobs among processing unit settings:
nodes = 1
procsPerNode = 1
repsPerProc = 1
simsPerRep = 100

# Define job settings:
settings={
'theta':list(numpy.linspace(.01,50,10)),
'N':[5],
'dt':[.01],
'corr':[.15],
'rP':[19],
'rN':[21]}