wget https://bbglab.irbbarcelona.org/oncodriverole/OncodriveROLE.RData
wget https://bbglab.irbbarcelona.org/oncodriverole/testset.txt
wget https://bbglab.irbbarcelona.org/oncodriverole/OncodriveROLE.HCD.features.txt
wget https://bbglab.irbbarcelona.org/oncodriverole/OncodriveROLE.Cancer5000.features.txt
cat Onco*.txt |sort -u > dataset.txt