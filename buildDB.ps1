$a = (kubectl get pods | select-string '^quote([^\s]+)-(?!deploy)') -match 'quote([^\s]+)'; $podname = $matches[0]

oc exec ${podname} -- mongosh -u admin -p quote --authenticationDatabase admin --eval 'use quotes' --eval 'db.createUser({user: "quotes", pwd: "quotes", roles: [{ role: "dbAdmin", db: "quotes" },{role: "readWrite", db: "quotes"}]})' --quiet


oc cp ./quotes.json ${podname}:/tmp/quotes.json
oc exec ${podname} -- mongoimport -u admin -p quote -c quote -d quote --authenticationDatabase admin /tmp/quotes.json