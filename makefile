
pullHyak:
	rsync -vprzt --stats --progress nicain@hyak.washington.edu:/gscratch/riekesheabrown/nicain/currentProjects/corrDDM/savedResults-Hyak ./
	root=/Users/nicain/Desktop/localProjects/DDMCubeTeragrid
	cp -pn ./savedResults-Hyak/* $root/savedResults