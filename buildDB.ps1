echo 'BUILD AND POPULATE QUOTE DATABASE'
echo '---------------------------------'

echo 'Waiting for pod to be ready...'
oc wait pod --for=condition=Ready -l tier=database,systemname=quotesforu

echo 'getting pod name ...'
$a = (kubectl get pods | select-string '^quote([^\s]+)-(?!deploy)') -match 'quote([^\s]+)'; $podname = $matches[0]

echo 'creating database and user account...'
oc exec ${podname} -- mongosh -u admin -p quote --authenticationDatabase admin --eval 'use quote' --eval 'db.createUser({user: "quote", pwd: "quote", roles: [{ role: "dbAdmin", db: "quote" },{role: "readWrite", db: "quote"}]})' --quiet

echo 'copying quotes to temporary folder in pod...'
oc cp ./quotes.json ${podname}:/tmp/quotes.json

echo 'importing quotes data...'
oc exec ${podname} -- mongoimport -u admin -p quote -c quote -d quote --authenticationDatabase admin /tmp/quotes.json

echo 'FINISHED'