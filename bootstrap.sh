#!/bin/bash
set -ex


CLUSTER_ENV=00
CLUSTER_FULLNAME=sbox
FLUX_CONFIG_URL=https://raw.githubusercontent.com/thomast1906/fluxv2-basic/main
GITHUB_USERNAME=GITHUB_USERNAME
GITHUB_PASSWORD=GITHUB_PAT_TOKEN

# Install Flux
kubectl apply -f ${FLUX_CONFIG_URL}/apps/flux-system/base/gotk-components.yaml

# Create Flux Sync CRDs
kubectl apply -f ${FLUX_CONFIG_URL}/apps/flux-system/base/fluxv2-basic-gitrepo.yaml

# Create secret credentials for GitHub authorisation (username/password auth)
kubectl -n flux-system create secret generic flux-git-details --from-literal=username=$GITHUB_USERNAME --from-literal=password=$GITHUB_PASSWORD

#Install kustomize
curl -s "https://raw.githubusercontent.com/\
kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
TMP_DIR=/tmp/flux/${CLUSTER_FULLNAME}/${CLUSTER_ENV}
mkdir -p $TMP_DIR
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
) > "${TMP_DIR}/kustomization.yaml"
# -----------------------------------------------------------

kustomize build ${TMP_DIR} |  kubectl apply -f -

rm -rf kustomize