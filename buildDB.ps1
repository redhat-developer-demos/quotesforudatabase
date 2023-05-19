$a = (kubectl get pods | select-string '^quote([^\s]+)-(?!deploy)') -match 'quote([^\s]+)'; $podname = $matches[0]
oc cp ./quotes.json ${podname}:quotes.json
oc exec ${podname} -- mongoimport -u admin -p quote -c quote -d quote --authenticationDatabase admin quotes.json