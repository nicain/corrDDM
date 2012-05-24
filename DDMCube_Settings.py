# Define job:
quickNamePrefix = 'corrDDMSIPSIdtCheckBig'
dryRun = 0
localRun = 0
runType = 'batch'			# 'batch' or 'wallTimeEstimate'
waitForSims = 0
wallTime = 10000
wallTimeEstCount = 1
queue = 'default'
FD=0

# Divide jobs among processing unit settings:
nodes = 4*15
procsPerNode = 8
repsPerProc = 1
simsPerRep = 100

# Define job settings:
settings={
'theta':list(numpy.linspace(.01,1000,10)),
'N':[240],
'dt':[.5,.1,.05,.01],
'corr':[.15],
'rP':[21],
'rN':[19]}
