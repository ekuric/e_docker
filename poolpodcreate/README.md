## README 

poolpodcreate.sh scripts creates desired number of pods. It assumes working and functional OSE v3 environment 

Usage:

create pods 

`#./poolpodcreate.sh <action> IMAGE RANGE`

delete pods 

`#./poolcreate.sh d` 

- <action> can be `c` - create, or `d` delete`
- IMAGE - the docker image we want to use for pods
- RANGE - how many pods we want to create 
