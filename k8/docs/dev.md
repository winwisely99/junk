# dev

For each layer of the stack the k8 manifests are tuned for each environment.

We use kpt:
Docs: https://googlecontainertools.github.io/kpt/
Code: https://github.com/GoogleContainerTools/kpt

It is able to generate kpt packages from Helm templates.
It is then able to output kustomize bundles as configuration packages.


## ci

Within CI the k8 manifests are manipulated, and hence output final manifest.

We use kpt-functions-sdk:  

Docs: https://googlecontainertools.github.io/kpt-functions-sdk/
Code: https://github.com/GoogleContainerTools/kpt-functions-sdk

This allows a pipeline style of manipulation to output to other systems and act as a gitops engine.



## ops

Gitops is used to perform changes to the running system that are idempotent.

