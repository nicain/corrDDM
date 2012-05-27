# Define job:
quickNamePrefix = 'corrDDMSIPSIOvershoot'
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
simsPerRep = 1000

Coh = 6.4
rP = 40 + .4*Coh
rN = 40 - .4*Coh

# Define job settings:
settings={
'theta':list(numpy.linspace(.01,250,20)),
'N':[240],
'dt':[.1],
'corr':[.15],
'rP':[rP],
'rN':[rN]}
