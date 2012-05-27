# Define job:
quickNamePrefix = 'corrDDMMIPSIBig'
dryRun = 0
localRun = 0
runType = 'batch'			# 'batch' or 'wallTimeEstimate'
waitForSims = 0
wallTime = 5000
wallTimeEstCount = 1
queue = 'default'
FD=0

# Divide jobs among processing unit settings:
nodes = 24
procsPerNode = 8
repsPerProc = 1
simsPerRep = 520

# Define job settings:
settings={
'theta':list(numpy.linspace(.01,1200,200)),
'N':[240],
'dt':[.1],
'corr':[.15],
'rP':[21],
'rN':[19]}
