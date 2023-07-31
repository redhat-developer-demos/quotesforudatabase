## Install MongoDB template
oc create -f https://raw.githubusercontent.com/openshift-labs/starter-guides/ocp-4.8/mongodb-template.yaml -n rhn-engineering-dsch-dev

## Create MongoDB instance
oc new-app --template=mongodb-ephemeral --param DATABASE_SERVICE_NAME=quote --param MONGODB_USER=quote --param MONGODB_PASSWORD=quote --param MONGODB_DATABASE=quote --param MONGODB_ADMIN_PASSWORD=quote --param NAMESPACE=rhn-engineering-dsch-dev --labels=app.kubernetes.io/part-of=quotesforu

## Create MongoDB pod
oc import-image mongodb:3.6 --from=registry.access.redhat.com/rhscl/mongodb-36-rhel7 --confirm -n rhn-engineering-dsch-dev


## Populate database

### Get pod
#### PowerShell
`$a = (kubectl get pods | select-string '^quote([^\s]+)-(?!deploy)') -match 'quote([^\s]+)'; $podname = $matches[0]`


### Copy files
#### PowerShell
`oc cp ./quotes.json ${podname}:quotes.json`


### Run import
`oc exec ${podname} -- mongoimport -u admin -p quote -c quote -d quote --authenticationDatabase admin quotes.json`


