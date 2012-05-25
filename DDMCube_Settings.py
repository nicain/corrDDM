# Define job:
<<<<<<< HEAD
quickNamePrefix = 'corrDDMSIPSPRTOvershootDebug'
=======
quickNamePrefix = 'corrDDMSIPSPRTOvershoot'
>>>>>>> 8e2cb88c002d3cef140326aa3b7ff750bf995614
dryRun = 0
localRun = 0
runType = 'batch'			# 'batch' or 'wallTimeEstimate'
waitForSims = 0
wallTime = 10000
wallTimeEstCount = 1
queue = 'default'
FD=0

# Divide jobs among processing unit settings:
nodes = 1
procsPerNode = 8
repsPerProc = 1
simsPerRep = 50

Coh = 6.4
rP = 40 + .4*Coh
rN = 40 - .4*Coh

# Define job settings:
settings={
'theta':list(numpy.linspace(.01,6,20)),
'N':[240],
'dt':[.1],
'corr':[.15],
'rP':[rP],
'rN':[rN]}
