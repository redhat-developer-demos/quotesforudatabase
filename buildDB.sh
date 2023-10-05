echo 'BUILD AND POPULATE QUOTE DATABASE'
echo '---------------------------------'

echo 'getting pod name ...'
export PODNAME=$(oc get pods -o custom-columns=POD:.metadata.name --no-headers | grep -v 'deploy$' | grep quote)
echo $PODNAME

echo 'creating database and user account...'
oc exec $PODNAME -- mongosh -u admin -p quote --authenticationDatabase admin --eval 'use quote' --eval 'db.createUser({user: "quote", pwd: "quote", roles: [{ role: "dbAdmin", db: "quote" },{role: "readWrite", db: "quote"}]})' --quiet

echo 'copying quotes to temporary folder in pod...'
oc cp ./quotes.json $PODNAME:/tmp/quotes.json

echo 'importing quotes data...'
oc exec $PODNAME -- mongoimport -u admin -p quote -c quote -d quote --authenticationDatabase admin /tmp/quotes.json

echo 'FINISHED'