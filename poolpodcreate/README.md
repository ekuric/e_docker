## README 

poolpodcreate.sh scripts creates desired number of pods. It assumes working and functional OSE v3 environment 

Usage:

`#./poolpodcreate <action> IMAGE RANGE`

- IMAGE - the docker image we want to use for pods
- RANGE - how many pods we want to create 
- action - can be create od delete 

create pods 

`# ./poolpodcreate.sh c <IMAGE> <RANGE>`

delete pods 

`#./poolpodcreate d`