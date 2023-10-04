
export PODNAME=$(oc get pods -o custom-columns=POD:.metadata.name --no-headers | grep -v 'deploy$' | grep quote)
echo $PODNAME

oc cp ./quotes.json $PODNAME:/tmp/quotes.json
oc exec $PODNAME -- mongoimport -u admin -p quote -c quote -d quote --authenticationDatabase admin /tmp/quotes.json