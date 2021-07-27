# fluxv2-basic
Basic repo to deploy an initial setup of fluxv2, with no helm charts involved.

# Bootstrap
Script created bootstrap.sh to run within your kubernetes cluster to boostrap with Fluxv2. 

The bootstrap will configure:-
- helm-controller
- kustomize-controller
- notification-controller
- source-controller

At a later stage, I will create another repo that will contain helm charts etc.
## Secret setup

As linked below, various areas you can deploy GitRepository using different authentication methods, in my example - it is username/password

https://github.com/fluxcd/kustomize-controller#define-a-git-repository-source