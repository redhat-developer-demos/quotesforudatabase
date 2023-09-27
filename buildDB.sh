
export PODNAME=$(oc get pods -o custom-columns=POD:.metadata.name --no-headers | grep -v 'deploy$' | grep quote)
echo $PODNAME

oc cp ./quotes.json $PODNAME:quotes.json
oc exec $PODNAME -- mongoimport -u admin -p quote -c quote -d quote --authenticationDatabase admin quotes.json