# Define job:
quickNamePrefix = 'corrDDMSIPSPRTDebug'
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
simsPerRep = 100

# Define job settings:
settings={
'theta':list(numpy.linspace(.01,5,10)),
'N':[5],
'dt':[.1],
'corr':[.15],
'rP':[21],
'rN':[19]}
