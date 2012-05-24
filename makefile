
pullHyak:
	rsync -vprzt --stats --progress nicain@hyak.washington.edu:/gscratch/riekesheabrown/nicain/currentProjects/corrDDM/savedResults-Hyak ./
	cp -pn ./savedResults-Hyak/* /Users/nicain/Desktop/localProjects/DDMCubeTeragrid/savedResults