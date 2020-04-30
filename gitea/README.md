# gitea

code: https://github.com/go-gitea/gitea
docs: https://code.gitea.io/

conf
/Users/apple/workspace/go/src/github.com/go-gitea/gitea/custom

oauth2 - check it out

deploy to google

search: https://github.com/search?l=Go&o=desc&q=github.com%2Fgo-gitea%2Fgitea&s=indexed&type=Code


## aims

Mirror from github into our gitea

Run on a rasp pi, as a backup from the cloud going down
- but also setup inlets in Cloudrun and point it to a local rasp pi.

## search all public gitea repos
https://github.com/sapk/gitea-explore

## Dockers
raspi
https://github.com/Kunde21/raspberry-dev/blob/master/gitea-arm/Dockerfile

k8
https://github.com/ops-itop/gitea-k8s



## hoosk for CI

We can run our OWN CI / CD by hooking in.
The logic will allow us to kick oof make based builds anywhere we want.
- For example Dyans MAC at night
- Use Inlets so the Cloud run server can then call Dyans laptop to tell it to run a build and deploy to ??
https://github.com/jenkins-x/lighthouse
- uses
	- https://github.com/jenkins-x/go-scm
 - Tekton pipelines, not POW

