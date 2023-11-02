## Part of the Red Hat Developer learning path entitled "Using Red Hat OpenShift labels"  

## Create

`oc create -f quotesdb_secrets.yaml`  
`oc create -f quotesdb.yaml` 



## Populate database

### Get pod
#### PowerShell
`$a = (kubectl get pods | select-string '^quote([^\s]+)-(?!deploy)') -match 'quote([^\s]+)'; $podname = $matches[0]`


### Copy files
#### PowerShell
`oc cp ./quotes.json ${podname}:quotes.json`


### Run import
`oc exec ${podname} -- mongoimport -u admin -p quote -c quote -d quote --authenticationDatabase admin quotes.json`


