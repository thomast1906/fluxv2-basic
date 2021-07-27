#!/bin/bash
set -ex


CLUSTER_ENV=00
CLUSTER_FULLNAME=sbox
FLUX_CONFIG_URL=https://raw.githubusercontent.com/thomast1906/fluxv2-basic/main

# Install Flux
kubectl apply -f ${FLUX_CONFIG_URL}/apps/flux-system/base/gotk-components.yaml

#Create Flux Sync CRDs
kubectl apply -f ${FLUX_CONFIG_URL}/apps/flux-system/base/flux-config-gitrepo.yaml


#Install kustomize
curl -s "https://raw.githubusercontent.com/\
kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
# -----------------------------------------------------------
(
cat <<EOF
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: flux-system
resources:
    - ${FLUX_CONFIG_URL}/apps/flux-system/base/kustomize.yaml
patchesStrategicMerge:
  - ${FLUX_CONFIG_URL}/apps/flux-system/${CLUSTER_FULLNAME}/${CLUSTER_ENV}/kustomize.yaml
EOF
) > "script/kustomization.yaml"
# -----------------------------------------------------------

./kustomize build script |  kubectl apply -f -

# rm -rf kustomize